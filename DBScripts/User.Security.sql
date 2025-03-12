USE [BookWormDB]
GO

/****** Object:  Table [User].[Security]    Script Date: 22/12/1403 12:00:09 ب.ظ ******/
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
 CONSTRAINT [PK_Security] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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

ALTER TABLE [User].[Security]  WITH CHECK ADD  CONSTRAINT [FK_Security_User] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
ON UPDATE CASCADE
GO

ALTER TABLE [User].[Security] CHECK CONSTRAINT [FK_Security_User]
GO

