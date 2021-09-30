select count(*) from Tasks
declare @NumberOfDaysToKeep int
set @NumberOfDaysToKeep = 30
begin transaction
    
delete from Tasks
where 1=1 
and ((IsDeleted = 1 and DateDiff(day, DeletionTime, GetDate()) > @NumberOfDaysToKeep)
or (Status = 2
/*
  0 = Unassigned, 1 = Pending, 2 = Completed
*/
-- and TenantId = 1 -- default tenant
-- and OrganizationUnitId = 1 -- switch to the OrganizationUnit for which you want to delete
and DateDiff(day, LastModificationTime, GetDate()) > @NumberOfDaysToKeep))

commit transaction
select count(*) from Tasks