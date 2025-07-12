USE [customer-support-ticketing-database];

-- View: Open Tickets Summary - Shows all tickets that are currently open (i.e., not resolved yet) with basic info.
GO
CREATE VIEW vw_open_ticket_summary AS
SELECT td.ticket_id, td.summary, 
c.full_name AS customer_name, s.full_name AS assigned_agent,
tc.category_name, ts.status,
td.created_at, td.sla_due_at
FROM ticket_details td 
JOIN customers c ON td.customer_id = c.customer_id
JOIN support_agents s ON td.agent_id = s.agent_id
JOIN ticket_category tc ON td.category_id = tc.category_id
JOIN ticket_status ts ON td.status_id = ts.status_id
WHERE status NOT IN ('Resolved', 'Closed');
GO

SELECT * FROM vw_open_ticket_summary;

-- View: Agent Performance View - Summarizes how many tickets each agent has handled and resolved.
GO
CREATE VIEW vw_agent_performance AS
SELECT s.full_name AS agent_name, COUNT(td.ticket_id) AS number_of_tickets
FROM ticket_details td 
JOIN support_agents s ON td.agent_id = s.agent_id
JOIN ticket_status ts ON td.status_id = ts.status_id 
WHERE ts.status IN ('Resolved', 'Closed')
GROUP BY s.full_name;
GO

SELECT * FROM vw_agent_performance

-- View: Ticket Resolution Metrics - Provide resolution-related KPIs
GO
CREATE VIEW vw_ticket_resolution_metrics AS
SELECT td.ticket_id,td.summary,DATEDIFF(HOUR, td.created_at, td.resolved_at) AS hours_to_resolve,
tc.category_name, s.full_name AS agent_name
FROM ticket_details td
JOIN ticket_category tc ON td.category_id = tc.category_id
JOIN support_agents s ON td.agent_id = s.agent_id
WHERE td.resolved_at IS NOT NULL;
GO

SELECT * FROM vw_ticket_resolution_metrics



