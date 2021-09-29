select count(*) from jobs
declare @NumberOfDaysToKeep int
set @NumberOfDaysToKeep = 30
begin transaction

delete from jobs
where 1=1
-- and State = 5
/*
  0 = Pending, 1 = Running, 2 = Stopping, 3 = Terminating, 4 = Faulted, 
  5 = Successful, 6 = Stopped, 7 = Suspended, 8 = Resumed
*/
-- and TenantId = 1 -- default tenant
and DateDiff(day, CreationTime, GetDate()) > @NumberOfDaysToKeep

commit transaction
select count(*) from jobs