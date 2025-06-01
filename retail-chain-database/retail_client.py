#Importing the required libraries
import mysql.connector
from mysql.connector import Error

#Connecting to the retail chain database
try:
    connection = mysql.connector.connect(host = 'localhost', user = 'root', password = 'Snake@123', database = 'retail_chain_db')
    if connection.is_connected():
          print('Connection is established')
except Error as e:
    print('Connection is not established:', e)

#Cursor object
cursor = connection.cursor()

#Running a simple SQL query 
sql_query = """SELECT * FROM users LIMIT 10;"""
cursor.execute(sql_query)
rows = cursor.fetchall()
for row in rows():
     print(row)

#Calling user order history stored procedure which was created in Workbench
cursor.callproc('get_user_order_history', [11])
for result in cursor.stored_results():
     rows = result.fetchall()
     for row in rows:
          print(row)

#Closing the connection
cursor.close()
connection.close()












