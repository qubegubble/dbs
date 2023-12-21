USE msdb
GO

IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs WHERE (name = N'MonthlyFullBackupJob'))
BEGIN
    EXEC msdb.dbo.sp_delete_job @job_name = N'MonthlyFullBackupJob', @delete_unused_schedule=1;
    EXEC msdb.dbo.sp_delete_job @job_name = N'WeeklyIncrementalBackupJob', @delete_unused_schedule=1;
    EXEC msdb.dbo.sp_delete_job @job_name = N'DailyLogBackupJob', @delete_unused_schedule=1;
END

EXEC dbo.sp_add_schedule
    @schedule_name = N'MonthlyFullBackupScheduleLolDB',
    @freq_type = 16,                      -- Monthly
    @freq_interval = 1,                   -- First day of every month
    @freq_recurrence_factor = 1,          -- Every month
    @active_start_time = 210000;          -- At 21:00


EXEC dbo.sp_add_job
    @job_name = N'MonthlyFullBackupJob';


EXEC sp_add_jobstep
    @job_name = N'MonthlyFullBackupJob',
    @step_name = N'FullBackupStep',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE [LeagueOfLegends] TO DISK = N''C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Monthly\LeagueOfLegends_Full.bak'' WITH FORMAT;',
    @retry_attempts = 5,
    @retry_interval = 5;


EXEC sp_attach_schedule
   @job_name = N'MonthlyFullBackupJob',
   @schedule_name = N'MonthlyFullBackupScheduleLolDB';


EXEC dbo.sp_add_schedule
    @schedule_name = N'WeeklyIncrementalBackupSchedule',
    @freq_type = 8,                       -- Weekly
    @freq_interval = 1,                   -- Every Sunday
    @freq_recurrence_factor = 1,
    @active_start_time = 220000;          -- At 22:00


EXEC dbo.sp_add_job
    @job_name = N'WeeklyIncrementalBackupJob';


EXEC sp_add_jobstep
    @job_name = N'WeeklyIncrementalBackupJob',
    @step_name = N'IncrementalBackupStep',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE [LeagueOfLegends] TO DISK = N''C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Weekly\LeagueOfLegends_Incremental.bak'' WITH DIFFERENTIAL;',
    @retry_attempts = 5,
    @retry_interval = 5;


EXEC sp_attach_schedule
   @job_name = N'WeeklyIncrementalBackupJob',
   @schedule_name = N'WeeklyIncrementalBackupSchedule';


EXEC dbo.sp_add_schedule
    @schedule_name = N'DailyLogBackupSchedule',
    @freq_type = 4,                       -- Daily
    @freq_interval = 1,                   -- Every day
    @active_start_time = 200000;          -- At 20:00


EXEC dbo.sp_add_job
    @job_name = N'DailyLogBackupJob';


EXEC sp_add_jobstep
    @job_name = N'DailyLogBackupJob',
    @step_name = N'LogBackupStep',
    @subsystem = N'TSQL',
    @command = N'BACKUP LOG [LeagueOfLegends] TO DISK = N''C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Daily\LeagueOfLegends_Log.trn'';',
    @retry_attempts = 5,
    @retry_interval = 5;

EXEC sp_attach_schedule
   @job_name = N'DailyLogBackupJob',
   @schedule_name = N'DailyLogBackupSchedule';


EXEC dbo.sp_update_job
    @job_name = N'MonthlyFullBackupJob',
    @enabled = 1;

EXEC dbo.sp_update_job
    @job_name = N'WeeklyIncrementalBackupJob',
    @enabled = 1;

EXEC dbo.sp_update_job
    @job_name = N'DailyLogBackupJob',
    @enabled = 1;

GO
