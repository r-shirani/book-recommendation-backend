USE [BookWormDB]
GO

/****** Object:  Table [User].[User]    Script Date: 22/12/1403 12:00:19 ب.ظ ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [User].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserType] FOREIGN KEY([UserTypeID])
REFERENCES [User].[UserType] ([UserTypeID])
ON UPDATE CASCADE
GO

ALTER TABLE [User].[User] CHECK CONSTRAINT [FK_User_UserType]
GO

