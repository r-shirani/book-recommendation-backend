USE [BookWormDB]
GO

/****** Object:  Table [User].[Users]    Script Date: 19/12/1403 12:57:53 ق.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [User].[Users](
	[UserID] [bigint] NOT NULL,
	[UserName] [varchar](30) NOT NULL,
	[PasswordHash] [varbinary](64) NOT NULL,
	[Salt] [varbinary](16) NULL,
	[MainName] [nvarchar](250) NOT NULL,
	[SecondName] [nvarchar](250) NULL,
	[PhoneNumber] [char](11) NULL,
	[Email] [nvarchar](250) NULL,
	[Bio] [nvarchar](250) NULL,
	[Sex] [tinyint] NULL,
	[DateOfBrith] [date] NULL,
	[WebSite] [nvarchar](250) NULL,
	[UserTypeID] [tinyint] NOT NULL,
	[LastIPAddress] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [User].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UserType] FOREIGN KEY([UserTypeID])
REFERENCES [User].[UserType] ([UserTypeID])
ON UPDATE CASCADE
GO

ALTER TABLE [User].[Users] CHECK CONSTRAINT [FK_Users_UserType]
GO

