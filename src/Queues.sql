select count(*) from QueueItems
select count(*) from QueueItemEvents
select count(*) from QueueItemComments
declare @NumberOfDaysToKeep int
set @NumberOfDaysToKeep = 30
begin transaction

-- create temp table with list of IDs that we want to delete
select ID as IdToDelete into #TempDeletedIds from QueueItems
where status=3
-- and TenantId = 1
-- and ReviewStatus != 0
and DateDiff(day, CreationTime, GetDate()) > @NumberOfDaysToKeep

-------------------- QueueItemEvents
delete from QueueItemEvents
where Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItemId)

-------------------- QueueItemComments
delete from QueueItemComments
where Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItemId)

-------------------- QueueItems
delete from QueueItems
where Exists (select 1 from #TempDeletedIds where IdToDelete = QueueItems.Id)

-- drop temp table with list of IDs that we deleted
drop table #TempDeletedIds
commit transaction
select count(*) from QueueItems
select count(*) from QueueItemEvents
select count(*) from QueueItemComments