# Setting up the connection
import pyodbc
import pandas as pd
from email.message import EmailMessage
from datetime import datetime

try:
    # Establish connection to SQL Server
    conn = pyodbc.connect(
        "Driver = {SQL Server};"      
        "Server = DESKTOP-P8KHD45\SQL_SERVER_2025;"   
        "Database = customer-support-ticketing-database;"
        "Trusted_Connection = yes;"                     
    )
    
    print("✅ Connection successful!")

except pyodbc.Error as e:
    print("❌ Connection failed.")
    print("Error message:", e)

#Running queries
query = """
SELECT td.ticket_id, td.summary, ts.status, c.full_name AS customer, sa.full_name AS agent
FROM ticket_details td
JOIN ticket_status ts ON td.status_id = ts.status_id
JOIN customers c ON td.customer_id = c.customer_id
LEFT JOIN support_agents sa ON td.agent_id = sa.agent_id
WHERE ts.status NOT IN ('Resolved', 'Closed');
"""
df = pd.read_sql(query, conn)
print(df.head())

#Exporting results in an excel file
df.to_excel("open_tickets.xlsx", index=False)
print("✅ Data saved to open_tickets.xlsx")

# Query to get ticket counts by agent and status
query1 = """
SELECT sa.full_name AS agent_name, ts.status, 
COUNT(td.ticket_id) AS ticket_count
FROM ticket_details td
JOIN support_agents sa ON td.agent_id = sa.agent_id
JOIN ticket_status ts ON td.status_id = ts.status_id
GROUP BY sa.full_name, ts.status
ORDER BY sa.full_name, ts.status;
"""
df = pd.read_sql(query1, conn)

# Save to Excel
filename = f"ticket_counts_by_agent_status.xlsx"
df.to_excel(filename, index=False)
print("Report saved to:", filename)

# Query to get feedback ratings
query2 = """
SELECT sa.full_name AS agent_name, f.rating, f.comment, f.submitted_at
FROM feedback f
JOIN ticket_details td ON f.ticket_id = td.ticket_id
JOIN support_agents sa ON td.agent_id = sa.agent_id
ORDER BY f.submitted_at DESC;
"""
df_feedback = pd.read_sql(query2, conn)

# Save to Excel
filename2 = f"feedback_ratings.xlsx"
df_feedback.to_excel(filename2, index=False)
print("Feedback report saved to:", filename2)

# Close the connection
conn.close()



