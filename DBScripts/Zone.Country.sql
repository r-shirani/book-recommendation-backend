USE [BookWormDB]
GO

/****** Object:  Table [Zone].[Country]    Script Date: 19/12/1403 12:58:22 Þ.Ù ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Zone].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [nvarchar](100) NOT NULL,
	[ISOCode] [char](2) NULL,
	[Capital] [nvarchar](100) NULL,
	[ContinentID] [int] NULL,
	[LanguageID] [int] NULL,
 CONSTRAINT [PK__Countrie__10D160BFA4395944] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Zone].[Country]  WITH CHECK ADD  CONSTRAINT [FK_Countries_Continent] FOREIGN KEY([ContinentID])
REFERENCES [Zone].[Continent] ([ContinentID])
GO

ALTER TABLE [Zone].[Country] CHECK CONSTRAINT [FK_Countries_Continent]
GO

ALTER TABLE [Zone].[Country]  WITH CHECK ADD  CONSTRAINT [FK_Countries_Language] FOREIGN KEY([LanguageID])
REFERENCES [Book].[Language] ([LanguageID])
GO

ALTER TABLE [Zone].[Country] CHECK CONSTRAINT [FK_Countries_Language]
GO


