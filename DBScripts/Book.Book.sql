USE [BookWormDB]
GO

/****** Object:  Table [Book].[Book]    Script Date: 19/12/1403 12:56:48 ق.ظ ******/
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
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[Version] [timestamp] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Book].[Book] ADD  CONSTRAINT [DF_Book_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO

ALTER TABLE [Book].[Book] ADD  CONSTRAINT [DF_Book_UpdatedAt]  DEFAULT (getdate()) FOR [UpdatedAt]
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

