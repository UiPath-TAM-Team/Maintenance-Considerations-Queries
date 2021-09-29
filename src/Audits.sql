select count(*) from AuditLogs
select count(*) from AuditLogEntities
declare @NumberOfDaysToKeep int
set @NumberOfDaysToKeep = 30
begin transaction

-- create temp table with list of IDs that we want to delete
select ID as IdToDelete into #TempDeletedIds from AuditLogs
where 1=1
-- and TenantId = 1
and DateDiff(day, ExecutionTime, GetDate()) > @NumberOfDaysToKeep

-------------------- AuditLogEntities
delete from AuditLogEntities
where Exists (select 1 from #TempDeletedIds where IdToDelete = AuditLogId)

-------------------- AuditLogs
delete from AuditLogs
where Exists (select 1 from #TempDeletedIds where IdToDelete = AuditLogs.Id)

-- drop temp table with list of IDs that we deleted
drop table #TempDeletedIds
commit transaction
select count(*) from AuditLogs
select count(*) from AuditLogEntities