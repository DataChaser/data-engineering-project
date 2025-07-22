USE [customer-support-ticketing-database];
GO

-- Creating index for ticket created date of ticket_details table
CREATE NONCLUSTERED INDEX idx_created_at
ON ticket_details(created_at);

-- Creating index for status_id of ticket_details table
CREATE NONCLUSTERED INDEX idx_status_id
ON ticket_details(status_id);

-- Creating index for agent_id of ticket_details table
CREATE NONCLUSTERED INDEX idx_agent_id
ON ticket_details(agent_id);

-- Creating composite index for status_id and created_at of ticket_details table
CREATE NONCLUSTERED INDEX idx_status_created
ON ticket_details(status_id, created_at);

-- Creating composite index for status_id and created_at of ticket_details table
CREATE NONCLUSTERED INDEX idx_status_and_created
ON ticket_details(status_id, created_at);

-- Creating composite index for agent_id and status_id and created_at of ticket_details table
CREATE NONCLUSTERED INDEX idx_agent_and_status
ON ticket_details(agent_id, status_id);
