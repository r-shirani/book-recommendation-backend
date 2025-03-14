USE [BookWormDB]
GO

/****** Object:  Table [Book].[AccessibilityDetail]    Script Date: 24/12/1403 10:56:56 Þ.Ù ******/
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

ALTER TABLE [Book].[AccessibilityDetail] ADD  CONSTRAINT [DF_AccessibilityDetail_Priority]  DEFAULT ((0)) FOR [Priority]
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


