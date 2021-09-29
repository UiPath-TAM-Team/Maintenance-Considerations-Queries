select count(*) from UserNotifications
select count(*) from TenantNotifications
declare @NumberOfDaysToKeep int
set @NumberOfDaysToKeep = 30
begin transaction

-- create a temp table with list of IDs that we want to delete
select ID as IdToDelete into #TempDeletedIds from TenantNotifications
where 1=1
-- and TenantId = 1
and DateDiff(day, CreationTime, GetDate()) > @NumberOfDaysToKeep

-------------------- UserNotifications
delete from UserNotifications
where Exists (select 1 from #TempDeletedIds where IdToDelete = TenantNotificationId)

-------------------- TenantNotifications
delete from TenantNotifications
where Exists (select 1 from #TempDeletedIds where IdToDelete = TenantNotifications.Id)

-- drop temp table with list of IDs that we deleted
drop table #TempDeletedIds
commit transaction
select count(*) from UserNotifications
select count(*) from TenantNotifications