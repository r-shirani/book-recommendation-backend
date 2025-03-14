USE [BookWormDB]
GO

/****** Object:  Table [Book].[Hashtag]    Script Date: 24/12/1403 10:59:47 ق.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Book].[Hashtag](
	[HashtagCollectionID] [bigint] IDENTITY(1,1) NOT NULL,
	[CollectionID] [bigint] NULL,
	[Title] [nvarchar](50) NULL,
 CONSTRAINT [PK_Hashtag] PRIMARY KEY CLUSTERED 
(
	[HashtagCollectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Book].[Hashtag]  WITH CHECK ADD  CONSTRAINT [FK_Hashtag_Collection] FOREIGN KEY([CollectionID])
REFERENCES [Book].[Collection] ([CollectionID])
ON UPDATE CASCADE
GO

ALTER TABLE [Book].[Hashtag] CHECK CONSTRAINT [FK_Hashtag_Collection]
GO

