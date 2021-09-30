select count(*) from Ledger
select count(*) from LedgerDeliveries

-- Ledger table cleanup
DELETE FROM Ledger WHERE  DateDiff(day, CreationTime, GetDate()) > 30

--LedgerDeliveries table cleanup
DELETE FROM LedgerDeliveries WHERE  DateDiff(day, LastUpdatedTime, GetDate()) > 30

select count(*) from Ledger
select count(*) from LedgerDeliveries