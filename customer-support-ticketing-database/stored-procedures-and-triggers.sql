USE [customer-support-ticketing-database];
GO

DROP PROCEDURE IF EXISTS AssignTickettoAgent;
GO

CREATE PROCEDURE AssignTickettoAgent @ticket_id INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @selected_agent INT;

	-- finding agent with fewest ticket
	SELECT TOP 1 @selected_agent = s.agent_id 
	FROM support_agents s
	LEFT JOIN ticket_details td ON s.agent_id = td.agent_id
	WHERE td.status_id IN (SELECT status_id FROM ticket_status WHERE status NOT IN ('Closed', 'Resolved'))
	GROUP BY s.agent_id
	ORDER BY COUNT(td.ticket_id) ASC;

	-- if no agents found
	IF @selected_agent IS NULL 
	BEGIN
		PRINT ('No agents found');
		RETURN;
	END

	-- update tickets to the selected agent
	UPDATE ticket_details 
	SET agent_id = @selected_agent
	WHERE ticket_id = @ticket_id
	PRINT('Ticket assigned to Agent ID: ' + CAST(@selected_agent AS NVARCHAR(10)));
END;
GO

CREATE TRIGGER ticket_logs_update
ON ticket_details
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into ticket_logs only if status_id has changed
    INSERT INTO ticket_logs (ticket_id, status_id, changed_at, changed_by)
    SELECT i.ticket_id, i.status_id, GETDATE(), SYSTEM_USER
    FROM inserted i
    INNER JOIN deleted d ON i.ticket_id = d.ticket_id
    WHERE i.status_id <> d.status_id;
END;
GO






	