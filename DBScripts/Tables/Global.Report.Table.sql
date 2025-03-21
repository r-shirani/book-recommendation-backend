USE [BookWormDB]
GO
/****** Object:  Table [Global].[Report]    Script Date: 01/01/1404 12:23:29 ب.ظ ******/
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
ALTER TABLE [Global].[Report] ADD  CONSTRAINT [DF_Report_IsChecked]  DEFAULT ((0)) FOR [IsChecked]
GO
ALTER TABLE [Global].[Report]  WITH CHECK ADD  CONSTRAINT [FK_Report_User] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
ON UPDATE CASCADE
GO
ALTER TABLE [Global].[Report] CHECK CONSTRAINT [FK_Report_User]
GO
