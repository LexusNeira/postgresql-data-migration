# postgresql-data-migration

This pgpsql procedure migrates data from one table to another by default with 10 tuple chunk size. You can change chunk size while calling procedure.

How to use it ?

--> Make sure your table and column name are correct. You can put " call transfer_data(100); " in sql file and call with psql and nohup. It works in background and it is safe to kill session whenever you want. It will start again where it was.
    
    
  ## Points you should consider 

    1. Table and column name are hardcoded, make sure it is correct for you or you can change it to parametric.
    
    2. This procedure move data between blocks so it means IO load, take this load into account while working and prefer the times when the system is not very busy.
    
    3. If there are updates on your source table, you will may miss your some data. Best use case for this procedure is insert only tables.
    
    4. There should be no data entry other than procedure to the target table, it may crush all moving logic.


