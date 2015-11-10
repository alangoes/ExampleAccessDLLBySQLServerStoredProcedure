/* Habilitando o trustworthy */
ALTER DATABASE DBTest SET trustworthy ON

/* Criando o Assembly */
USE DBTest
GO
CREATE ASSEMBLY SPAssembly
FROM 'C:\DBTest\StoredProcedures.dll'
WITH PERMISSION_SET = UNSAFE;
GO

/* Procedures */
CREATE PROCEDURE [dbo].[SampleWSPut]
      @weburl [nvarchar](4000),
      @returnval [nvarchar](2000) OUTPUT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [SPAssembly].[StoredProcedures].[SampleWSPut]
GO

CREATE PROCEDURE [dbo].[SampleWSPost]
      @weburl [nvarchar](4000),
      @returnval [nvarchar](2000) OUTPUT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [SPAssembly].[StoredProcedures].[SampleWSPost]

CREATE PROCEDURE [dbo].[SampleWSGET]
      @weburl [nvarchar](4000),
      @returnval [nvarchar](2000) OUTPUT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [SPAssembly].[StoredProcedures].[SampleWSGET]

/* clr enabled */
sp_configure 'clr enabled', 1
GO
RECONFIGURE
GO

/* Comandos */
Declare @Response NVARCHAR(2000)
EXECUTE SampleWSPOST 'http://sampledev03/wcfweb/calendarWS.svc/?appid=MMM&AuctionCode=ABC&months=4',@Response OUT
SELECT @Response
GO
 
Declare @Response NVARCHAR(2000)
EXECUTE SampleWSPUT 'http://sampledev03/wcfweb/calendarWS.svc/?appid=MMM&AuctionCode=ABC&months=4',@Response OUT
SELECT @Response

Declare @Response NVARCHAR(2000)
EXECUTE SampleWSGET 'https://public.opencpu.org/ocpu/library/',@Response OUT
SELECT @Response

/* Consultando os assemblies registrados na DataBase */
SELECT * FROM sys.assemblies
