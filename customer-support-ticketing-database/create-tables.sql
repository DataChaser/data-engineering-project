CREATE DATABASE [customer-support-ticketing-database];
GO

USE [customer-support-ticketing-database];
GO

-- CUSTOMERS TABLE
-- Stores customer info (people who raise support tickets)
CREATE TABLE customers (
customer_id INT IDENTITY(1,1) PRIMARY KEY,
full_name NVARCHAR(100),
email_id NVARCHAR(100)
);
GO

-- SUPPORT AGENTS TABLE
-- Stores agents who handle support tickets
CREATE TABLE support_agents(
agent_id INT IDENTITY(1,1) PRIMARY KEY,
full_name NVARCHAR(100),
email_id NVARCHAR(100),
designation NVARCHAR(50)
);
GO

-- TICKET CATEGORIES TABLE
-- Stores issue types (acts like an enum)
CREATE TABLE ticket_category(
category_id INT IDENTITY(1,1) PRIMARY KEY,
category_name NVARCHAR(100) UNIQUE
);
GO

-- TICKET STATUSES TABLE
-- Workflow states of a ticket (acts like an enum)
CREATE TABLE ticket_status(
status_id INT IDENTITY(1,1) PRIMARY KEY,
status NVARCHAR(100) UNIQUE
);
GO

-- TICKETS TABLE
-- Main table: holds support request data
CREATE TABLE ticket_details(
ticket_id INT IDENTITY(1,1) PRIMARY KEY,
summary NVARCHAR(100),
ticket_description NVARCHAR(255),
customer_id INT,
agent_id INT,
category_id INT,
status_id INT,
created_at DATETIME DEFAULT GETDATE(),
resolved_at DATETIME NULL,
sla_due_at DATETIME NULL,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (agent_id) REFERENCES support_agents(agent_id),
FOREIGN KEY (category_id) REFERENCES ticket_category(category_id),
FOREIGN KEY (status_id) REFERENCES ticket_status(status_id)
);
GO

-- TICKET LOGS TABLE
-- Tracks each ticket’s status changes (audit log)
CREATE TABLE ticket_logs(
log_id INT IDENTITY(1,1) PRIMARY KEY,
ticket_id INT,
status_id INT,
changed_at DATETIME DEFAULT GETDATE(),
changed_by NVARCHAR(100),
FOREIGN KEY (ticket_id) REFERENCES ticket_details(ticket_id),
FOREIGN KEY (status_id) REFERENCES ticket_status(status_id)
);
GO

-- FEEDBACK TABLE
-- Captures customer feedback after ticket is resolved
CREATE TABLE feedback(
feedback_id INT IDENTITY(1,1) PRIMARY KEY,
ticket_id INT,
rating INT CHECK (rating >= 0 AND rating <= 5),
comment NVARCHAR(255),
submitted_at DATETIME DEFAULT GETDATE(),
FOREIGN KEY (ticket_id) REFERENCES ticket_details(ticket_id)
);
GO