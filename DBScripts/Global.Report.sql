USE [BookWormDB]
GO

/****** Object:  Table [Global].[Report]    Script Date: 22/12/1403 12:00:47 ب.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Global].[Report](
	[ReportID] [bigint] NOT NULL,
	[Text] [nvarchar](255) NULL,
	[UserID] [bigint] NULL,
	[CommentID] [bigint] NULL,
	[IsChecked] [bit] NULL,
	[ReportTypeID] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [Global].[Report] ADD  CONSTRAINT [DF_Report_IsChecked]  DEFAULT ((0)) FOR [IsChecked]
GO

