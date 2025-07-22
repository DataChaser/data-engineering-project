USE [customer-support-ticketing-database];

-- List all tickets with customer and agent names
SELECT td.ticket_id, td.summary, td.ticket_description, 
c.full_name AS customer_name, s.full_name AS support_agent_name
FROM ticket_details td 
JOIN customers c ON td.customer_id = c.customer_id
JOIN support_agents s ON td.agent_id = s.agent_id;

-- Count of tickets by status
SELECT ts.status, COUNT(td.ticket_id) AS count_of_tickets
FROM ticket_details td 
JOIN ticket_status ts ON td.status_id = ts.status_id
GROUP BY ts.status
ORDER BY count_of_tickets DESC;

-- Tickets created in the last one month
SELECT ticket_id, summary, created_at 
FROM ticket_details 
WHERE created_at >= DATEADD(MONTH, -1, GETDATE());

-- List all overdue tickets (SLA Due Date has passed, not resolved)
SELECT ticket_id, summary, sla_due_at
FROM ticket_details
WHERE sla_due_at < GETDATE() AND resolved_at IS NULL;

-- Average feedback rating by support agent
SELECT s.full_name, AVG(rating) as average_rating, count(f.feedback_id) AS count_of_tickets -- adding count to check the number of feedbacks agents have got
FROM support_agents s 
JOIN ticket_details td ON s.agent_id = td.agent_id
JOIN feedback f ON td.ticket_id = f.ticket_id
GROUP BY full_name
ORDER BY average_rating DESC;

-- Tickets with longest resolution time
SELECT ticket_id, summary, DATEDIFF(HOUR, created_at, resolved_at) as number_of_hours
FROM ticket_details 
WHERE resolved_at IS NOT NULL
ORDER BY number_of_hours DESC;

-- List agents who have never received feedback
SELECT full_name, email_id FROM support_agents
WHERE agent_id NOT IN 
(SELECT DISTINCT td.agent_id FROM ticket_details td JOIN feedback f ON td.ticket_id = f.ticket_id);
