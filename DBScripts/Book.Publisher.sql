USE [BookWormDB]
GO

/****** Object:  Table [Book].[Publisher]    Script Date: 19/12/1403 12:57:28 ق.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Book].[Publisher](
	[PublisherID] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[CountryID] [int] NULL,
	[Website] [nvarchar](255) NULL,
 CONSTRAINT [PK_Publisher] PRIMARY KEY CLUSTERED 
(
	[PublisherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Book].[Publisher]  WITH CHECK ADD  CONSTRAINT [FK_Publisher_Country] FOREIGN KEY([CountryID])
REFERENCES [Zone].[Country] ([CountryID])
ON UPDATE CASCADE
GO

ALTER TABLE [Book].[Publisher] CHECK CONSTRAINT [FK_Publisher_Country]
GO

