# Assignment 2

1. Commit and rollback
    
When the **autocommit** is disable, if you make some **modifications** in the *DataBase* you can cancel them using `ROLLBACK`. If you want to save thoses **modifications** and not be able to cancel them using the method `ROLLBACK` you have to commit your changes using the method `COMMIT`.

2. Client Failure

If the **connection is close** before the modifications have been **commited** using the function `COMMIT`, all modification will be lost. But if modifications have been commited before the connection is closed, they will be save.

3. Transaction Isolation

If there is no commit the modifications are visible only by the connection where they has been done.

4. Isolation levels

Only the connection where the transaction isolation is set to read uncommited is able to access to modifications from other connection that are not commited yet. For the other connection they don't have access to modifications which have not been commited on other connection.

5. Isolation levels - Continued

Instructions cannot read data that has been modified but not yet committed by other transactions.
No other transaction can modify data that has been read by the active transaction until the active transaction has completed.
Other transactions cannot insert new rows with key values included in the group of keys read by instructions of the active transaction, until the active transaction has finished.