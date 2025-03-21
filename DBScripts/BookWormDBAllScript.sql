USE [master]
GO
/****** Object:  Database [BookWormDB]    Script Date: 01/01/1404 12:26:01 ب.ظ ******/
CREATE DATABASE [BookWormDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BookWormDB', FILENAME = N'H:\BookWorm\DBFiles\BookWormDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BookWormDB_log', FILENAME = N'H:\BookWorm\DBFiles\BookWormDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BookWormDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BookWormDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BookWormDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BookWormDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BookWormDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BookWormDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BookWormDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [BookWormDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BookWormDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BookWormDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BookWormDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BookWormDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BookWormDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BookWormDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BookWormDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BookWormDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BookWormDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BookWormDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BookWormDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BookWormDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BookWormDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BookWormDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BookWormDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BookWormDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BookWormDB] SET RECOVERY FULL 
GO
ALTER DATABASE [BookWormDB] SET  MULTI_USER 
GO
ALTER DATABASE [BookWormDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BookWormDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BookWormDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BookWormDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BookWormDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BookWormDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BookWormDB', N'ON'
GO
ALTER DATABASE [BookWormDB] SET QUERY_STORE = OFF
GO
USE [BookWormDB]
GO
/****** Object:  Schema [Book]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
CREATE SCHEMA [Book]
GO
/****** Object:  Schema [Global]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
CREATE SCHEMA [Global]
GO
/****** Object:  Schema [User]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
CREATE SCHEMA [User]
GO
/****** Object:  Schema [Zone]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
CREATE SCHEMA [Zone]
GO
/****** Object:  Table [User].[User]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [User].[User](
	[UserID] [bigint] NOT NULL,
	[UserName] [varchar](255) NOT NULL,
	[FirstName] [nvarchar](250) NOT NULL,
	[LastName] [nvarchar](250) NULL,
	[PhoneNumber] [char](11) NULL,
	[Email] [nvarchar](250) NULL,
	[Bio] [nvarchar](250) NULL,
	[Gender] [tinyint] NULL,
	[DateOfBrith] [date] NULL,
	[WebSite] [nvarchar](250) NULL,
	[UserTypeID] [tinyint] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UX_User] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [User].[UserType]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [User].[UserType](
	[UserTypeID] [tinyint] NOT NULL,
	[Code] [nvarchar](10) NOT NULL,
	[MainName] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
 CONSTRAINT [PK_UserType] PRIMARY KEY CLUSTERED 
(
	[UserTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [User].[Security]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [User].[Security](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[PassHint] [nvarchar](250) NULL,
	[LastLogin] [datetime] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[LockOutEnd] [date] NULL,
	[IsEmailVerified] [bit] NOT NULL,
	[IsPhoneVerified] [bit] NOT NULL,
	[FailedLoginAttempts] [tinyint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[ClientEmailID] [nvarchar](max) NULL,
	[PasswordHash] [nvarchar](max) NOT NULL,
	[Salt] [nvarchar](max) NULL,
	[VerificationCode] [nvarchar](250) NULL,
 CONSTRAINT [PK_Security] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [User].[vwAllFieldUser]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE     VIEW [User].[vwAllFieldUser]
AS
	SELECT 
		U.[UserID], U.[UserName], U.[FirstName], U.[LastName], 
		U.[PhoneNumber], U.[Email], U.[Bio], U.[Gender], 
		U.[WebSite], U.[UserTypeID], U.[DateOfBrith], 
		S.[ID], S.[PassHint], S.[LastLogin], 
		S.[Status], S.[LockOutEnd], S.[IsEmailVerified], 
		S.[IsPhoneVerified], S.[FailedLoginAttempts], 
		S.[CreateDate], S.[ClientEmailID], S.[PasswordHash], S.[Salt], S.[VerificationCode],
		T.[Code] AS UserTypeCode, T.[MainName] AS UserTypeTitle, T.[Description] AS UserTypeDescription
	FROM [User].[User] AS U
	LEFT JOIN [User].[Security] AS S
		ON U.UserID = S.UserID
	LEFT JOIN [User].[UserType] AS T
		ON U.UserID = T.UserTypeID
GO
/****** Object:  UserDefinedFunction [User].[funLogin]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     FUNCTION [User].[funLogin]
(
	@userName NVARCHAR(255),
	@email NVARCHAR(255)
)
RETURNS TABLE 
AS RETURN 
(
	SELECT 
		[UserID], [UserName], [FirstName], [LastName], 
		[PhoneNumber], [Email], [Bio], [Gender], 
		[WebSite], [UserTypeID], [DateOfBrith], 
		[ID], [PassHint], [LastLogin], 
		[Status], [LockOutEnd], [IsEmailVerified], 
		[IsPhoneVerified], [FailedLoginAttempts], 
		[CreateDate], [ClientEmailID], [PasswordHash], [Salt], [VerificationCode],
		UserTypeCode, UserTypeTitle, UserTypeDescription	
	FROM vwAllFieldUser 
	WHERE (UserName = @userName) OR (Email = @email)
);
GO
/****** Object:  Table [Book].[AccessibilityDetail]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[AccessibilityDetail](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccessibilityGroupID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL,
	[Priority] [bigint] NULL,
 CONSTRAINT [PK_AccessibilityDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Book].[AccessibilityGroup]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[AccessibilityGroup](
	[AccessibilityGroupID] [bigint] NOT NULL,
	[Title] [nvarchar](255) NULL,
	[Discription] [nvarchar](max) NULL,
	[AccessibilityTypeID] [int] NULL,
 CONSTRAINT [PK_AccessibilityGroup] PRIMARY KEY CLUSTERED 
(
	[AccessibilityGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Book].[AccessibilityType]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[AccessibilityType](
	[AccessibilityTypeID] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[CanRead] [bit] NOT NULL,
	[CanInsert] [bit] NOT NULL,
	[CanDelete] [bit] NOT NULL,
	[CanChangeHeader] [bit] NOT NULL,
 CONSTRAINT [PK_AccessibilityType] PRIMARY KEY CLUSTERED 
(
	[AccessibilityTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Book].[Author]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[Author](
	[AuthorID] [int] NOT NULL,
	[FirstName] [nvarchar](255) NOT NULL,
	[MiddleName] [nvarchar](255) NULL,
	[Lastname] [nvarchar](255) NOT NULL,
	[Pseudonym] [nvarchar](255) NULL,
	[BirthDate] [date] NULL,
	[Gender] [tinyint] NULL,
	[DeathDate] [date] NULL,
	[IsAlive] [bit] NULL,
	[NumberOfBooks] [smallint] NULL,
	[CountryID] [int] NULL,
	[Biography] [nvarchar](max) NULL,
	[Website] [nvarchar](255) NULL,
 CONSTRAINT [PK_Author] PRIMARY KEY CLUSTERED 
(
	[AuthorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Book].[Book]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[Book](
	[BookID] [bigint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[AuthorID] [int] NULL,
	[PublisherID] [int] NULL,
	[GenreID1] [smallint] NULL,
	[GenreID2] [smallint] NULL,
	[GenreID3] [smallint] NULL,
	[GenreExtra] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[PublishedYear] [smallint] NULL,
	[LanguageID] [int] NULL,
	[PageCount] [int] NULL,
	[ISBN] [nchar](10) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[UpdatedAt] [datetime] NOT NULL,
	[Version] [timestamp] NULL,
 CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED 
(
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Book].[Collection]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[Collection](
	[CollectionID] [bigint] NOT NULL,
	[CollectionTypeID] [tinyint] NULL,
	[AccessibilityGroupID] [bigint] NOT NULL,
	[Title] [nvarchar](255) NULL,
	[CreateDate] [date] NULL,
	[Discription] [nvarchar](max) NULL,
	[GenreID] [int] NULL,
	[HashTagString] [nvarchar](max) NULL,
	[ReportID] [bigint] NULL,
 CONSTRAINT [PK_Collection] PRIMARY KEY CLUSTERED 
(
	[CollectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Book].[CollectionType]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[CollectionType](
	[CollectionTypeID] [tinyint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Discription] [nvarchar](max) NULL,
 CONSTRAINT [PK_CollectionType] PRIMARY KEY CLUSTERED 
(
	[CollectionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Book].[Comment]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[Comment](
	[CommentID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL,
	[BookID] [bigint] NOT NULL,
	[Text] [nvarchar](max) NULL,
	[CommentRefID] [bigint] NULL,
	[CreatedAt] [datetime] NOT NULL,
	[LikeCount] [int] NULL,
	[DisLikeCount] [int] NULL,
	[IsBlocked] [bit] NULL,
	[IsEdited] [bit] NULL,
	[IsSpoiled] [bit] NULL,
	[ReportCount] [int] NULL,
	[ReportID] [bigint] NULL,
 CONSTRAINT [PK_Comment\] PRIMARY KEY CLUSTERED 
(
	[CommentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Book].[Genre]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[Genre](
	[GenreID] [smallint] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[SuitableAge] [tinyint] NOT NULL,
	[SDescription] [nvarchar](max) NULL,
 CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED 
(
	[GenreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Genre] UNIQUE NONCLUSTERED 
(
	[Title] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Book].[Hashtag]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[Hashtag](
	[HashtagCollectionID] [bigint] IDENTITY(1,1) NOT NULL,
	[CollectionID] [bigint] NULL,
	[Title] [nvarchar](50) NULL,
 CONSTRAINT [PK_Hashtag] PRIMARY KEY CLUSTERED 
(
	[HashtagCollectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Book].[Language]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[Language](
	[LanguageID] [int] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[ISOCode] [varchar](3) NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Book].[Publisher]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[Publisher](
	[PublisherID] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[CountryID] [int] NULL,
	[Website] [nvarchar](255) NULL,
 CONSTRAINT [PK_Publisher] PRIMARY KEY CLUSTERED 
(
	[PublisherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Book].[Rate]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Book].[Rate](
	[UserID] [bigint] NOT NULL,
	[BookID] [bigint] NOT NULL,
	[Rate] [tinyint] NOT NULL,
 CONSTRAINT [PK_Rate] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Global].[Report]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Global].[Report](
	[ReportID] [bigint] NOT NULL,
	[Text] [nvarchar](255) NULL,
	[UserID] [bigint] NULL,
	[IsChecked] [bit] NULL,
	[ReportTypeID] [int] NULL,
 CONSTRAINT [PK_Report] PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Global].[ReportType]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Global].[ReportType](
	[ReportTypeID] [tinyint] NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ReportType] PRIMARY KEY CLUSTERED 
(
	[ReportTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Zone].[Continent]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Zone].[Continent](
	[ContinentID] [int] IDENTITY(1,1) NOT NULL,
	[ContinentName] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ContinentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Zone].[Country]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Zone].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [nvarchar](100) NOT NULL,
	[ISOCode] [char](2) NULL,
	[Capital] [nvarchar](100) NULL,
	[ContinentID] [int] NULL,
	[LanguageID] [int] NULL,
 CONSTRAINT [PK__Countrie__10D160BFA4395944] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Book].[AccessibilityDetail] ADD  CONSTRAINT [DF_AccessibilityDetail_Priority]  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [Book].[AccessibilityType] ADD  CONSTRAINT [DF_AccessibilityType_CanRead]  DEFAULT ((1)) FOR [CanRead]
GO
ALTER TABLE [Book].[AccessibilityType] ADD  CONSTRAINT [DF_AccessibilityType_CanInsert]  DEFAULT ((0)) FOR [CanInsert]
GO
ALTER TABLE [Book].[AccessibilityType] ADD  CONSTRAINT [DF_AccessibilityType_CanDelete]  DEFAULT ((0)) FOR [CanDelete]
GO
ALTER TABLE [Book].[AccessibilityType] ADD  CONSTRAINT [DF_AccessibilityType_CanChangeHeader]  DEFAULT ((0)) FOR [CanChangeHeader]
GO
ALTER TABLE [Book].[Book] ADD  CONSTRAINT [DF_Book_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [Book].[Book] ADD  CONSTRAINT [DF_Book_UpdatedAt]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [Book].[Collection] ADD  CONSTRAINT [DF_Collection_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [Book].[Comment] ADD  CONSTRAINT [DF_Comment_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [Book].[Comment] ADD  CONSTRAINT [DF_Comment_CountLike]  DEFAULT ((0)) FOR [LikeCount]
GO
ALTER TABLE [Book].[Comment] ADD  CONSTRAINT [DF_Comment_CountDisLike]  DEFAULT ((0)) FOR [DisLikeCount]
GO
ALTER TABLE [Book].[Comment] ADD  CONSTRAINT [DF_Comment_IsBlocked]  DEFAULT ((0)) FOR [IsBlocked]
GO
ALTER TABLE [Book].[Comment] ADD  CONSTRAINT [DF_Comment_IsEdited]  DEFAULT ((0)) FOR [IsEdited]
GO
ALTER TABLE [Book].[Comment] ADD  CONSTRAINT [DF_Comment_IsSpoiled]  DEFAULT ((0)) FOR [IsSpoiled]
GO
ALTER TABLE [Book].[Comment] ADD  CONSTRAINT [DF_Comment_ReportCount]  DEFAULT ((0)) FOR [ReportCount]
GO
ALTER TABLE [Global].[Report] ADD  CONSTRAINT [DF_Report_IsChecked]  DEFAULT ((0)) FOR [IsChecked]
GO
ALTER TABLE [User].[Security] ADD  CONSTRAINT [DF_Security_LastLogin]  DEFAULT (getdate()) FOR [LastLogin]
GO
ALTER TABLE [User].[Security] ADD  CONSTRAINT [DF_Security_IsEmailVerified]  DEFAULT ((0)) FOR [IsEmailVerified]
GO
ALTER TABLE [User].[Security] ADD  CONSTRAINT [DF_Security_IsPhoneVerified]  DEFAULT ((0)) FOR [IsPhoneVerified]
GO
ALTER TABLE [User].[Security] ADD  CONSTRAINT [DF_Security_FailedLoginAttempts]  DEFAULT ((0)) FOR [FailedLoginAttempts]
GO
ALTER TABLE [User].[Security] ADD  CONSTRAINT [DF_Security_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [Book].[AccessibilityDetail]  WITH CHECK ADD  CONSTRAINT [FK_Accessibility_User] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[AccessibilityDetail] CHECK CONSTRAINT [FK_Accessibility_User]
GO
ALTER TABLE [Book].[AccessibilityDetail]  WITH CHECK ADD  CONSTRAINT [FK_AccessibilityDetail_AccessibilityGroup] FOREIGN KEY([AccessibilityGroupID])
REFERENCES [Book].[AccessibilityGroup] ([AccessibilityGroupID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[AccessibilityDetail] CHECK CONSTRAINT [FK_AccessibilityDetail_AccessibilityGroup]
GO
ALTER TABLE [Book].[AccessibilityGroup]  WITH CHECK ADD  CONSTRAINT [FK_AccessibilityGroup_AccessibilityType] FOREIGN KEY([AccessibilityTypeID])
REFERENCES [Book].[AccessibilityType] ([AccessibilityTypeID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[AccessibilityGroup] CHECK CONSTRAINT [FK_AccessibilityGroup_AccessibilityType]
GO
ALTER TABLE [Book].[Author]  WITH CHECK ADD  CONSTRAINT [FK_Author_Country] FOREIGN KEY([CountryID])
REFERENCES [Zone].[Country] ([CountryID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[Author] CHECK CONSTRAINT [FK_Author_Country]
GO
ALTER TABLE [Book].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_Author] FOREIGN KEY([AuthorID])
REFERENCES [Book].[Author] ([AuthorID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[Book] CHECK CONSTRAINT [FK_Book_Author]
GO
ALTER TABLE [Book].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_Genre] FOREIGN KEY([GenreID1])
REFERENCES [Book].[Genre] ([GenreID])
ON UPDATE SET NULL
GO
ALTER TABLE [Book].[Book] CHECK CONSTRAINT [FK_Book_Genre]
GO
ALTER TABLE [Book].[Book]  WITH NOCHECK ADD  CONSTRAINT [FK_Book_Genre1] FOREIGN KEY([GenreID2])
REFERENCES [Book].[Genre] ([GenreID])
NOT FOR REPLICATION 
GO
ALTER TABLE [Book].[Book] CHECK CONSTRAINT [FK_Book_Genre1]
GO
ALTER TABLE [Book].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_Genre2] FOREIGN KEY([GenreID3])
REFERENCES [Book].[Genre] ([GenreID])
GO
ALTER TABLE [Book].[Book] CHECK CONSTRAINT [FK_Book_Genre2]
GO
ALTER TABLE [Book].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_Language] FOREIGN KEY([LanguageID])
REFERENCES [Book].[Language] ([LanguageID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[Book] CHECK CONSTRAINT [FK_Book_Language]
GO
ALTER TABLE [Book].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_Publisher] FOREIGN KEY([PublisherID])
REFERENCES [Book].[Publisher] ([PublisherID])
GO
ALTER TABLE [Book].[Book] CHECK CONSTRAINT [FK_Book_Publisher]
GO
ALTER TABLE [Book].[Collection]  WITH CHECK ADD  CONSTRAINT [FK_Collection_CollectionType] FOREIGN KEY([CollectionTypeID])
REFERENCES [Book].[CollectionType] ([CollectionTypeID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[Collection] CHECK CONSTRAINT [FK_Collection_CollectionType]
GO
ALTER TABLE [Book].[Collection]  WITH CHECK ADD  CONSTRAINT [FK_Collection_Report] FOREIGN KEY([ReportID])
REFERENCES [Global].[Report] ([ReportID])
GO
ALTER TABLE [Book].[Collection] CHECK CONSTRAINT [FK_Collection_Report]
GO
ALTER TABLE [Book].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Book] FOREIGN KEY([BookID])
REFERENCES [Book].[Book] ([BookID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[Comment] CHECK CONSTRAINT [FK_Comment_Book]
GO
ALTER TABLE [Book].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Comment] FOREIGN KEY([CommentRefID])
REFERENCES [Book].[Comment] ([CommentID])
GO
ALTER TABLE [Book].[Comment] CHECK CONSTRAINT [FK_Comment_Comment]
GO
ALTER TABLE [Book].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Report] FOREIGN KEY([ReportID])
REFERENCES [Global].[Report] ([ReportID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[Comment] CHECK CONSTRAINT [FK_Comment_Report]
GO
ALTER TABLE [Book].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_User] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
GO
ALTER TABLE [Book].[Comment] CHECK CONSTRAINT [FK_Comment_User]
GO
ALTER TABLE [Book].[Hashtag]  WITH CHECK ADD  CONSTRAINT [FK_Hashtag_Collection] FOREIGN KEY([CollectionID])
REFERENCES [Book].[Collection] ([CollectionID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[Hashtag] CHECK CONSTRAINT [FK_Hashtag_Collection]
GO
ALTER TABLE [Book].[Publisher]  WITH CHECK ADD  CONSTRAINT [FK_Publisher_Country] FOREIGN KEY([CountryID])
REFERENCES [Zone].[Country] ([CountryID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[Publisher] CHECK CONSTRAINT [FK_Publisher_Country]
GO
ALTER TABLE [Book].[Rate]  WITH CHECK ADD  CONSTRAINT [FK_Rate_Book] FOREIGN KEY([BookID])
REFERENCES [Book].[Book] ([BookID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[Rate] CHECK CONSTRAINT [FK_Rate_Book]
GO
ALTER TABLE [Book].[Rate]  WITH CHECK ADD  CONSTRAINT [FK_Rate_User] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
ON UPDATE CASCADE
GO
ALTER TABLE [Book].[Rate] CHECK CONSTRAINT [FK_Rate_User]
GO
ALTER TABLE [Global].[Report]  WITH CHECK ADD  CONSTRAINT [FK_Report_User] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
ON UPDATE CASCADE
GO
ALTER TABLE [Global].[Report] CHECK CONSTRAINT [FK_Report_User]
GO
ALTER TABLE [User].[Security]  WITH CHECK ADD  CONSTRAINT [FK_Security_User] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
ON UPDATE CASCADE
GO
ALTER TABLE [User].[Security] CHECK CONSTRAINT [FK_Security_User]
GO
ALTER TABLE [User].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserType] FOREIGN KEY([UserTypeID])
REFERENCES [User].[UserType] ([UserTypeID])
ON UPDATE CASCADE
GO
ALTER TABLE [User].[User] CHECK CONSTRAINT [FK_User_UserType]
GO
ALTER TABLE [Zone].[Country]  WITH CHECK ADD  CONSTRAINT [FK_Countries_Continent] FOREIGN KEY([ContinentID])
REFERENCES [Zone].[Continent] ([ContinentID])
GO
ALTER TABLE [Zone].[Country] CHECK CONSTRAINT [FK_Countries_Continent]
GO
ALTER TABLE [Zone].[Country]  WITH CHECK ADD  CONSTRAINT [FK_Countries_Language] FOREIGN KEY([LanguageID])
REFERENCES [Book].[Language] ([LanguageID])
GO
ALTER TABLE [Zone].[Country] CHECK CONSTRAINT [FK_Countries_Language]
GO
/****** Object:  StoredProcedure [User].[spRemoveUser]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [User].[spRemoveUser]
(
    @userID AS NVARCHAR(255) = NULL,
    @userName AS NVARCHAR(255) = NULL,
    @email AS NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserCount INT;
    DECLARE @DeletedUserID INT;

    SELECT @DeletedUserID = UserID, @UserCount = COUNT(*) OVER()
    FROM [User].[User]
    WHERE (UserID = @userID) OR (UserName = @userName) OR (Email = @email);

    IF (@UserCount = 0) OR (@UserCount IS NULL)
    BEGIN
        SELECT NULL AS UserID, 'Failed' AS Status, 'Not_Found' AS Message;
        RETURN;
    END

    IF @UserCount > 1
    BEGIN
        SELECT NULL AS UserID, 'Failed' AS Status, 'More_Than_One' AS Message;
        RETURN;
    END

    DELETE FROM [User].[Security]
    WHERE UserID = @DeletedUserID;

    DELETE FROM [User].[User]
    WHERE UserID = @DeletedUserID;

    SELECT @DeletedUserID AS UserID, 'Succeeded' AS Status, 'Delete_Complete' AS Message;
END
GO
/****** Object:  StoredProcedure [User].[spSignupUser]    Script Date: 01/01/1404 12:26:02 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [User].[spSignupUser]
	@name  NVARCHAR(255),
	@pass  NVARCHAR(255),
	@email NVARCHAR(255),
	@clientEmailID NVARCHAR(255),
	@VerificationCode NVARCHAR(255)
AS
BEGIN
	DECLARE @UserID AS BIGINT;
	DECLARE @UserName NVARCHAR(MAX);

    SELECT @UserID = UserID FROM [User].[User] WHERE Email = @email

	If ISNULL(@UserID,0) <> 0
    BEGIN
        SELECT @UserID AS UserID, 'exists' AS Message;
        RETURN;
    END
    
	BEGIN TRAN;
	SELECT @UserID = ISNULL(MAX(UserID),0) + 1 FROM [User].[User];

	SET @UserName = CONCAT(@name,'-',(@UserID*7));

    INSERT INTO [User].[User](UserID, UserName, FirstName, Email, UserTypeID)
    VALUES (@UserID,  @UserName, @name, @email, 1);

    INSERT INTO [User].[Security]	
		([UserID], [Status], PasswordHash, ClientEmailID, VerificationCode)
    VALUES (@UserID, 1, @pass, @clientEmailID, @VerificationCode);
	COMMIT TRAN;

    SELECT @UserID AS userID, @UserName AS userName,'success' AS message;
END;
GO
USE [master]
GO
ALTER DATABASE [BookWormDB] SET  READ_WRITE 
GO
