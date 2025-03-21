USE [BookWormDB]
GO
/****** Object:  Table [Book].[Book]    Script Date: 01/01/1404 12:23:29 ب.ظ ******/
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
