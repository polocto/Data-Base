package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Jean-Michel Busca
 */
public class DataAccess {

  // class fields
  private static final String[] GET_DEPARTMENTS_QUERIES = {
    "select DID, DNAME, DLOC from DEPT",
    "select DID, DNAME, DLOC from DEPT where DLOC = ?",
    "select DID, DNAME, DLOC from DEPT where DNAME = ?",
    "select DID, DNAME, DLOC from DEPT where DNAME = ? and DLOC = ?",
    "select DID, DNAME, DLOC from DEPT where DID = ?",
    "select DID, DNAME, DLOC from DEPT where DID = ? and DLOC = ?",
    "select DID, DNAME, DLOC from DEPT where DID = ? and DNAME = ?",
    "select DID, DNAME, DLOC from DEPT where DID = ? and DNAME = ? and DLOC = ?"
  };

  // instance fields
  private final Connection connection;
  private PreparedStatement getEmployeesPS;
  private PreparedStatement updateSalaryPS;
  private PreparedStatement[] getDepartmentsPSs;

  /**
   * Important note on Prepared Statements:
   * <p>
   * Prepared statements are primarily intended to improve performances. As a
   * side effect, they also prevent SQL injection. For both reasons, <b>you must
   * use</b> prepared statements whenever you can. The only situation you can't
   * use a prepared statement is when you don't know the SQL statement to
   * execute beforehand.
   * <p>
   * For a prepared statement to be efficient:<ul>
   * <li>It has to be created <b>only once</b>. Upon creation, the RDMS parses
   * the statement of the SQL statement associated with the prepared statement
   * and then computes its the execution plan
   * <li> And then executed many times, possibly billions times. The execution
   * plan computed at creation time is re-used again and again, saving
   * processing time
   * </ul>
   * Therefore, a prepared statement must be:<ul>
   * <li>an instance attribute; it cannot be a local variable, beacause such a
   * variable is allocated every time you enter the method that declares it,
   * <li>initialized only once, either: (a) beforehand, in the constructor or
   * (b) at the very last time, in the method using the prepared statement; this
   * is a design pattern called "lazy intialization".
   * </ul>
   *
   * @param url the database to connect to
   * @param login the login to use for the connection
   * @param password the password to use for the connection
   *
   * @throws SQLException if an SQL error occurs
   * @throws ClassNotFoundException
   */
  public DataAccess(String url, String login, String password) throws
      SQLException, ClassNotFoundException {

    // connect to the database
      Class.forName("com.mysql.jdbc.Driver");
      connection = DriverManager.getConnection(url, login, password);
      connection.setAutoCommit(false);
      System.out.println("AutoCommit : " + connection.getAutoCommit());
      int transaction = connection.getTransactionIsolation();
      System.out.print("Transaction Isolation (" + transaction + ") : ");
      switch(transaction)
      {
        case 0:
        System.out.println("TRANSACTION_NONE");
        break;
        case 1:
        System.out.println("TRANSACTION_READ_UNCOMMITTED");
        break;
        case 2:
        System.out.println("TRANSACTION_READ_COMMITTED");
        break;
        case 4:
        System.out.println("TRANSACTION_REPEATABLE_READ");
        break;
        default:
        System.out.println("TRANSACTION_SERIALIZABLE");
        break;
      }

  }

  public synchronized List<EmployeeInfo> getEmployees() throws SQLException {

    // create a statement; whatever happens, the try-with-resource construct
    // will close the statement, which in turn will close the result set
    // convert the result set to a list
    List<EmployeeInfo> list = new ArrayList<>();
    try (Statement statement = connection.createStatement()) {

      // execute the query
      ResultSet result = statement.executeQuery(
          "select EID, ENAME, SAL from EMP");

      while (result.next()) {
        // accessing attributes by rank: 1, 2 & 3
        list.add(new EmployeeInfo(result.getInt(1),
            result.getString(2),
            result.getFloat(3)));
      }
      connection.commit();
      
    }catch(SQLException e)
    {
      connection.rollback();
      close();
      System.exit(1);
    }
    
    return list;
  }

  public synchronized List<EmployeeInfo> getEmployeesPS() throws SQLException {

    // create the prepared statement, if not created yet (lazy initialisation
    // design pattern)
    List<EmployeeInfo> list = new ArrayList<>();
      try{
        if (getEmployeesPS == null) {
          getEmployeesPS = connection.prepareStatement(
              "select EID, ENAME, SAL from EMP");
        }

        // execute the prepared statement; whatever happens, the try-with-resource
        // construct will close the result set
        try (ResultSet result = getEmployeesPS.executeQuery()) {

          while (result.next()) {
            list.add(new EmployeeInfo(result.getInt(1), result.getString(2),
                result.getFloat(3)));
          }
          connection.commit();
        }
      }
      catch(SQLException e)
      {
        connection.rollback();
        close();
        System.exit(1);
      }
      return list;

  }

  public synchronized boolean raiseSalary(String job, double amount)
      throws SQLException {
        boolean r=false;
    try {
      Statement statement = connection.createStatement();
  
      // do not forget to enclose string litterals (e.g. job) between single quotes:
      String query = "update EMP set SAL = SAL + " + amount + " where JOB = '" + job + "'";
      r = statement.executeUpdate(query)>= 1;
      connection.commit();
      // at least one tuple should have been updated:
      
    } catch(SQLException e)
    {
      connection.rollback();
      close();
      System.exit(1);
    }
    return r ;

  }

  public synchronized boolean raiseSalaryPS(String job, double amount)
      throws SQLException {
        boolean r =false;
    try {
      if (updateSalaryPS == null) {
        updateSalaryPS = connection.prepareStatement(
            "update EMP set SAL = SAL + ? where JOB = ?");
      }
  
      // assign a value to all query parameters ("?")
      updateSalaryPS.setDouble(1, amount);
      updateSalaryPS.setString(2, job);
      connection.commit();
      r = updateSalaryPS.executeUpdate() >= 1;
      
    } catch(SQLException e)
    {
      connection.rollback();
      close();
      System.exit(1);
    }
    return r;

  }

  public List<DepartmentInfo> getDepartments(Integer id, String name,
      String location)
      throws SQLException {
        
    // build the query string
    String query = "select DID, DNAME, DLOC from DEPT where true";
    if (id != null) {
      query += " and DID = " + id;
    }
    if (name != null) {
      query += " and DNAME = '" + name + "'";
    }
    if (location != null) {
      query += " and DLOC = '" + location + "'";
    }
    
    List<DepartmentInfo> list = new ArrayList<>();
    try (Statement statement = connection.createStatement()) {

      ResultSet result = statement.executeQuery(query);

      while (result.next()) {
        list.add(new DepartmentInfo(result.getInt(1),
            result.getString(2),
            result.getString(3)));
      }
      connection.commit();
      
    }catch(SQLException e)
    {
      connection.rollback();
      close();
      System.exit(1);
    }
    return list;

  }

  public List<DepartmentInfo> getDepartmentsPS(Integer id, String name,
      String location) throws SQLException {

    // compute the prepared statement key; the key has three bits, one for
    // each parameter: a bit is set to 1 if the parameter is specified
    // and left to 0 if not
    int key = 0;
    key += (id == null ? 0 : 4);
    key += (name == null ? 0 : 2);
    key += (location == null ? 0 : 1);

    if (getDepartmentsPSs == null) {
      getDepartmentsPSs = new PreparedStatement[GET_DEPARTMENTS_QUERIES.length];
    }

    // retrieve the appropriate prepared statement
    PreparedStatement getDepartementsPS = getDepartmentsPSs[key];
    if (getDepartementsPS == null) {
      getDepartementsPS = connection.prepareStatement(
          GET_DEPARTMENTS_QUERIES[key]);
      getDepartmentsPSs[key] = getDepartementsPS;
    }

    // set the prepared statement's parameters: one for each specified parameter
    int index = 0;
    if (id != null) {
      index += 1;
      getDepartementsPS.setInt(index, id);
    }
    if (name != null) {
      index += 1;
      getDepartementsPS.setString(index, name);
    }
    if (location != null) {
      index += 1;
      getDepartementsPS.setString(index, location);
    }
    List<DepartmentInfo> list = new ArrayList<>();

    try (ResultSet result = getDepartementsPS.executeQuery()) {

      while (result.next()) {
        list.add(new DepartmentInfo(result.getInt(1),
            result.getString(2),
            result.getString(3)));
      }
      connection.commit();
      
    }catch(SQLException e)
    {
      connection.rollback();
      close();
      System.exit(1);
    }
    return list;

  }

  public List<String> executeQuery(String query) throws SQLException {

    // execute the query using a statement: we cannot use a prepared statement
    // since the query can change from one call to the next
    List<String> list = new ArrayList<>();
    try (Statement statement = connection.createStatement()) {
      ResultSet result = statement.executeQuery(query);

      // retrieve the result set's metadata
      ResultSetMetaData metaData = result.getMetaData();

      // list attributes, i.e. column names
      String attributes = "| ";
      for (int index = 1; index <= metaData.getColumnCount(); index++) {
        attributes += metaData.getColumnName(index) + " | ";
      }
      list.add(attributes);

      // list tuples
      while (result.next()) {
        String tuple = "| ";
        for (int index = 1; index <= metaData.getColumnCount(); index++) {
          tuple += result.getObject(index) + " | ";
        }
        list.add(tuple);
      }
      connection.commit();
      
    }catch(SQLException e)
    {
      connection.rollback();
      close();
      System.exit(1);
    }
    return list;
  }

  public List<String> executeStatement(String statement) throws SQLException {

    List<String> list = new ArrayList<>();
    // if the statement is a query
    try {
      if (statement.toLowerCase().startsWith("select")) {
        return executeQuery(statement);
      }
  
      // else we assume it is an update
      Statement jdbcStatement = connection.createStatement();
      int r = jdbcStatement.executeUpdate(statement);
  
      list.add(r + "");
      connection.commit();
      
    } catch(SQLException e)
    {
      connection.rollback();
      close();
      System.exit(1);
    }
    return list;

  }

  public void close() throws SQLException {
    try {
      if (getEmployeesPS != null) {
        getEmployeesPS.close();
      }
    } catch (SQLException e) {
      // exception is ignored: go on closing other resources
    }

    try {
      if (updateSalaryPS != null) {
        updateSalaryPS.close();
      }
    } catch (SQLException e) {
    }

    if (getDepartmentsPSs != null) {
      for (PreparedStatement ps : getDepartmentsPSs) {
        try {
          if (ps != null) {
            ps.close();
          }
        } catch (SQLException e) {
        }
      }
    }

    connection.close();
  }

}
