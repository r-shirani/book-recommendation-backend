USE [BookWormDB]
GO

/****** Object:  Table [Book].[Comment]    Script Date: 24/12/1403 10:59:20 ق.ظ ******/
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
 CONSTRAINT [PK_Comment\] PRIMARY KEY CLUSTERED 
(
	[CommentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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

ALTER TABLE [Book].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_User] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
GO

ALTER TABLE [Book].[Comment] CHECK CONSTRAINT [FK_Comment_User]
GO

