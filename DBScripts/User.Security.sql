USE [BookWormDB]
GO

/****** Object:  Table [User].[Security]    Script Date: 19/12/1403 12:57:43 ق.ظ ******/
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
 CONSTRAINT [PK_Security] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [User].[Security] ADD  CONSTRAINT [DF_Security_IsEmailVerified]  DEFAULT ((0)) FOR [IsEmailVerified]
GO

ALTER TABLE [User].[Security] ADD  CONSTRAINT [DF_Security_IsPhoneVerified]  DEFAULT ((0)) FOR [IsPhoneVerified]
GO

ALTER TABLE [User].[Security] ADD  CONSTRAINT [DF_Security_FailedLoginAttempts]  DEFAULT ((0)) FOR [FailedLoginAttempts]
GO

ALTER TABLE [User].[Security]  WITH CHECK ADD  CONSTRAINT [FK_Security_Users] FOREIGN KEY([UserID])
REFERENCES [User].[Users] ([UserID])
ON UPDATE CASCADE
GO

ALTER TABLE [User].[Security] CHECK CONSTRAINT [FK_Security_Users]
GO

