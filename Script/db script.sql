USE [master]
GO
/****** Object:  Database [TestDb2]    Script Date: 6/17/2021 4:45:29 PM ******/
CREATE DATABASE [TestDb2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TestDb2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\TestDb2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TestDb2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\TestDb2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [TestDb2] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TestDb2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TestDb2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TestDb2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TestDb2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TestDb2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TestDb2] SET ARITHABORT OFF 
GO
ALTER DATABASE [TestDb2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TestDb2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TestDb2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TestDb2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TestDb2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TestDb2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TestDb2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TestDb2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TestDb2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TestDb2] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TestDb2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TestDb2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TestDb2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TestDb2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TestDb2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TestDb2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TestDb2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TestDb2] SET RECOVERY FULL 
GO
ALTER DATABASE [TestDb2] SET  MULTI_USER 
GO
ALTER DATABASE [TestDb2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TestDb2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TestDb2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TestDb2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TestDb2] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'TestDb2', N'ON'
GO
ALTER DATABASE [TestDb2] SET QUERY_STORE = OFF
GO
USE [TestDb2]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 6/17/2021 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[JoinDate] [datetime] NULL,
	[Designation] [varchar](100) NULL,
	[Salary] [decimal](18, 2) NULL,
	[IsBonusAdded] [bit] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblManagerMap]    Script Date: 6/17/2021 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblManagerMap](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpID] [int] NULL,
	[ImmediateManagerID] [int] NULL,
	[RootManagerID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Map]    Script Date: 6/17/2021 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Map]
AS
SELECT TOP (100) PERCENT dbo.Employee.Id, dbo.Employee.Name, dbo.Employee.Designation, dbo.Employee.Salary, dbo.Employee.JoinDate, YEAR(dbo.Employee.JoinDate) AS [Join Year], dbo.tblManagerMap.RootManagerID, 
                  dbo.tblManagerMap.ImmediateManagerID, dbo.Employee.IsBonusAdded
FROM     dbo.Employee INNER JOIN
                  dbo.tblManagerMap ON dbo.Employee.Id = dbo.tblManagerMap.Id
ORDER BY dbo.tblManagerMap.RootManagerID
GO
/****** Object:  View [dbo].[FinalView]    Script Date: 6/17/2021 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FinalView]
AS
SELECT TOP (100) PERCENT dbo.Employee.Id, dbo.Employee.Name, dbo.Employee.Designation, dbo.Employee.Salary, dbo.Employee.JoinDate, dbo.Employee.IsBonusAdded, CASE WHEN DATEDIFF(YEAR, JoinDate, GETDATE()) > 4 AND 
                  (CAST(Year(JoinDate) AS int) % 4 = 0) AND (CAST(Year(JoinDate) AS int) % 100 <> 0) OR
                  (CAST(Year(JoinDate) AS int) % 400 = 0) AND dbo.Employee.IsBonusAdded = 'True' THEN Salary + 10000 WHEN DATEDIFF(YEAR, JoinDate, GETDATE()) > 4 AND (CAST(Year(JoinDate) AS int) % 4 <> 0) AND 
                  dbo.Employee.IsBonusAdded = 'True' THEN (Salary + 8000) WHEN DATEDIFF(YEAR, JoinDate, GETDATE()) < 4 AND (CAST(Year(JoinDate) AS int) % 4 = 0) AND (CAST(Year(JoinDate) AS int) % 100 <> 0) OR
                  (CAST(Year(JoinDate) AS int) % 400 = 0) AND dbo.Employee.IsBonusAdded = 'True' THEN Salary + 5000 WHEN DATEDIFF(YEAR, JoinDate, GETDATE()) < 4 AND (CAST(Year(JoinDate) AS int) % 4 <> 0) AND 
                  dbo.Employee.IsBonusAdded = 'True' THEN Salary + 3000 ELSE Salary END AS [Salary with bonus]
FROM     dbo.Employee INNER JOIN
                  dbo.tblManagerMap ON dbo.Employee.Id = dbo.tblManagerMap.Id
WHERE  (dbo.tblManagerMap.RootManagerID =
                      (SELECT RootManagerID
                       FROM      dbo.Map
                       WHERE   (Id = 1)
                       GROUP BY RootManagerID))
ORDER BY dbo.tblManagerMap.RootManagerID
GO
/****** Object:  View [dbo].[View_2]    Script Date: 6/17/2021 4:45:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_2]
AS
SELECT Id, Name, Designation, Salary, JoinDate, [Join Year], ImmediateManagerID, RootManagerID, CASE WHEN DATEDIFF(YEAR, JoinDate, GETDATE()) > 4 THEN (Salary + 8000) WHEN DATEDIFF(YEAR, JoinDate, GETDATE()) > 4 AND 
                  (CAST(Year(JoinDate) AS int) % 4 = 0) AND (CAST(Year(JoinDate) AS int) % 100 <> 0) OR
                  (CAST(Year(JoinDate) AS int) % 400 = 0) THEN Salary + 10000 WHEN DATEDIFF(YEAR, JoinDate, GETDATE()) < 4 AND (CAST(Year(JoinDate) AS int) % 4 = 0) AND (CAST(Year(JoinDate) AS int) % 100 <> 0) OR
                  (CAST(Year(JoinDate) AS int) % 400 = 0) THEN Salary + 5000 WHEN DATEDIFF(YEAR, JoinDate, GETDATE()) < 4 AND (CAST(Year(JoinDate) AS int) % 4 <> 0) THEN Salary + 3000 END AS [Salary with bonus]
FROM     dbo.Map
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Employee"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblManagerMap"
            Begin Extent = 
               Top = 7
               Left = 290
               Bottom = 170
               Right = 531
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 2424
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2052
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1356
         Filter = 11400
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'FinalView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'FinalView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[13] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Employee"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "tblManagerMap"
            Begin Extent = 
               Top = 7
               Left = 290
               Bottom = 170
               Right = 531
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1836
         Width = 1692
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3720
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Map'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Map'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Map"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 289
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 2028
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_2'
GO
USE [master]
GO
ALTER DATABASE [TestDb2] SET  READ_WRITE 
GO
