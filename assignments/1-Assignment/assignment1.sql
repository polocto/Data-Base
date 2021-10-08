-- Query 1
 SELECT
  DISTINCT c.residence
FROM
  orders o
  INNER JOIN customers c ON c.cid = o.cid
WHERE
  YEAR(o.odate) = 2014
  AND c.residence != "NULL";

-- Query 2

SELECT
  p.origin,
  COUNT(*) AS numberOfProduct,
  MIN(p.price) AS MinPrice,
  MAX(p.price) AS maxPrice
FROM
  products p
GROUP BY
  p.origin;


-- Query 3
SELECT DISTINCT *
FROM customers NATURAL JOIN orders
WHERE YEAR(odate) = 2014 AND pid IN
(
    SELECT DISTINCT pid
    FROM orders NATURAL JOIN customers
    WHERE cname='Smith' AND YEAR(odate) = 2013
) GROUP BY cid
HAVING COUNT(pid) >= (SELECT COUNT(DISTINCT pid) FROM orders NATURAL JOIN customers WHERE cname='Smith' AND YEAR(odate) = 2013);

-- QUery 4
SELECT DISTINCT c.cname, p.pname, o.quantity*p.price AS price
FROM customers AS c
NATURAL JOIN orders AS o 
NATURAL JOIN products AS p
GROUP BY cid, pid
ORDER BY cname, price DESC, pid;


-- Query 5
SELECT
  DISTINCT c.*
FROM
  customers c
  INNER JOIN orders o ON c.cid = o.cid
  INNER JOIN products p ON o.pid = p.pid
WHERE
  p.origin = c.residence
  AND NOT c.cid = ANY(
    SELECT
      DISTINCT c.cid
    FROM
      customers c
      INNER JOIN orders o ON c.cid = o.cid
      INNER JOIN products p ON o.pid = p.pid
    WHERE
      p.origin != c.residence
  );

-- Query 6
SELECT
  DISTINCT c.*
FROM
  customers c
  INNER JOIN orders o ON c.cid = o.cid
  INNER JOIN products p ON o.pid = p.pid
WHERE
  p.origin != c.residence
  AND NOT c.cid = ANY(
    SELECT
      DISTINCT c.cid
    FROM
      customers c
      INNER JOIN orders o ON c.cid = o.cid
      INNER JOIN products p ON o.pid = p.pid
    WHERE
      p.origin = c.residence
  );

-- Query 7
SELECT (
        SELECT AVG(quantity)
        FROM(
                SELECT quantity
                FROM orders
                NATURAL JOIN customers
                WHERE residence = "USA"
        )q1
)
-
(
        SELECT AVG(quantity)
        FROM(
                SELECT DISTINCT quantity
                FROM orders
                NATURAL JOIN customers
                WHERE residence = 'France'
        )q2
);


-- Query 8
SELECT products.*
FROM products
NATURAL JOIN
(
    SELECT pid, COUNT(DISTINCT MONTH(odate)) AS months
    FROM orders
    WHERE YEAR(odate)=2014
    GROUP BY pid
) tabmonths
WHERE
months =12;

-- Query 9
SELECT
  c.*
FROM
  customers c
  INNER JOIN orders o ON c.cid = o.cid
  INNER JOIN products p ON o.pid = p.pid
WHERE
  p.price < 5
GROUP BY
  c.cid
HAVING
  COUNT(DISTINCT p.pid) = (
    SELECT
      COUNT(DISTINCT products.pid)
    FROM
      products
    WHERE
      products.price < 5
  );


-- Query 10

SELECT
  cname1,
  cname2,
  COUNT(tab1.pid) AS numberOfProducts
FROM(
    SELECT
      DISTINCT o.pid,
      c.cname AS cname1
    FROM
      customers c NATURAL
      JOIN orders o
  ) tab1
  INNER JOIN (
    SELECT
      DISTINCT o.pid,
      c.cname AS cname2
    FROM
      customers c NATURAL
      JOIN orders o
  ) tab2 ON tab1.pid = tab2.pid
  AND tab1.cname1 < tab2.cname2
GROUP BY
  tab1.cname1,
  tab2.cname2
HAVING
  numberOfProducts = (
    SELECT
      MAX(m)
    FROM
      (
        SELECT
          COUNT(tab1.pid) AS m
        FROM(
            SELECT
              DISTINCT o.pid,
              c.cname AS cname1
            FROM
              customers c NATURAL
              JOIN orders o
          ) tab1
          INNER JOIN (
            SELECT
              DISTINCT  o.pid,
              c.cname AS cname2
            FROM
              customers c NATURAL
              JOIN orders o
          ) tab2 ON tab1.pid = tab2.pid
          AND tab1.cname1 < tab2.cname2
        GROUP BY
          tab1.cname1,
          tab2.cname2
      ) q
  );


-- Query 11

SELECT
  c.*
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
GROUP BY
  c.cid
HAVING
  SUM(o.quantity) = (
    SELECT
      MAX(m)
    FROM(
        SELECT
          c.*,
          SUM(o.quantity) AS m
        FROM
          customers c NATURAL
          JOIN orders o NATURAL
          JOIN products p
        GROUP BY
          c.cid
      ) q
  );

-- Query 12
SELECT DISTINCT
  p.*
FROM
  customers c
  INNER JOIN orders o ON c.cid = o.cid
  INNER JOIN products p ON o.pid = p.pid
WHERE
  c.residence = "FRANCE";

-- Query 13
SELECT
  c.cname
FROM
  customers c
WHERE c.residence IN
  (
    SELECT
      c.residence
    FROM
      customers c
    WHERE
      c.cname = "Smith"
  )  
  AND c.cname != "Smith";

-- Query 14
SELECT
  c.*
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
WHERE
  YEAR(o.odate) = 2014
GROUP BY
  c.cid
HAVING
  SUM(p.price * o.quantity) = (
    SELECT
      MAX(m)
    FROM(
        SELECT
          SUM(p.price * o.quantity) AS m
        FROM
          customers c NATURAL
          JOIN orders o NATURAL
          JOIN products p
        WHERE
          YEAR(o.odate) = 2014
        GROUP BY
          c.cid
      ) q
  );

-- Query 15
SELECT
  table1.pid,
  table1.pname,
  table1.price,
  table1.origin
FROM
  (
    SELECT
      price * quantity AS total,
      products.*
    FROM
      products NATURAL
      JOIN orders
  ) table1
GROUP BY
  pid
HAVING
  AVG(total) = (
    SELECT
      MAX(m)
    FROM
      (
        SELECT
          AVG(total) AS m,
          pid,
          pname
        FROM
          (
            SELECT
              price * quantity AS total,
              pid,
              pname
            FROM
              products NATURAL
              JOIN orders
          ) table1
        GROUP BY
          pid
      ) q
  );

-- Query 16
SELECT
  DISTINCT p.*
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
WHERE
  c.residence = "USA";


-- Query 17
SELECT  cname1, cname2, pname

FROM

(
        SELECT DISTINCT cname AS cname1, pid, pname
        FROM customers
        NATURAL JOIN orders
        NATURAL JOIN products
        WHERE YEAR(odate)=2014
        )table1

INNER JOIN

(
        SELECT DISTINCT cname AS cname2, pid
        FROM customers
        NATURAL JOIN orders
        NATURAL JOIN products
        WHERE YEAR(odate)=2014
        )table2

ON table1.pid = table2.pid AND table1.cname1 < table2.cname2;

-- Query 18
SELECT
  p.*
FROM
  products p
WHERE
  p.price > (
    SELECT
      MAX(p.price)
    FROM
      customers c NATURAL
      JOIN orders o NATURAL
      JOIN products p
    WHERE
      p.origin = "India"
  );


-- Query 19
SELECT
  p.*
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
GROUP BY
  p.pid
HAVING
  COUNT(DISTINCT cid) = (
    SELECT
      MIN(m)
    FROM(
        SELECT
          COUNT(DISTINCT cid) AS m
        FROM
          customers c NATURAL
          JOIN orders o NATURAL
          JOIN products p
        GROUP BY
          p.pid
      ) q
  );

-- Query 20

SELECT country, MAX(numberCID) AS "Number of resident", MAX(numberPID) AS "Number of product"
FROM
(
(
    SELECT origin AS country, 0 AS numberCID, COUNT(DISTINCT pid) AS numberPID
    FROM products
    GROUP BY origin
)
UNION
(
    SELECT residence, COUNT(DISTINCT cid), 0
    FROM customers
    GROUP BY residence
)) t

GROUP BY country;
