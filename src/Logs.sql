select count(*) from Logs
select count(*) from RobotLicenseLogs
declare @NumberOfDaysToKeep int
set @NumberOfDaysToKeep = 30
begin transaction

-------------------- Logs
delete from Logs
where 1=1
-- and level = 2
/*
  0 = Verbose, 1 = Trace, 2 = Info,
  3 = Warn, 4 = Error, 5 = Fatal
*/
-- and TenantId = 1 -- default tenant
and DateDiff(day, TimeStamp, GetDate()) > @NumberOfDaysToKeep

-------------------- RobotLicenseLogs
delete from RobotLicenseLogs
where EndDate is not null
-- and TenantId = 1 -- default tenant
and DateDiff(day, EndDate, GetDate()) > @NumberOfDaysToKeep

commit transaction
select count(*) from Logs
select count(*) from RobotLicenseLogs