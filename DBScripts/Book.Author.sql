USE [BookWormDB]
GO

/****** Object:  Table [Book].[Author]    Script Date: 19/12/1403 12:56:35 ق.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Book].[Author](
	[AuthorID] [int] NOT NULL,
	[FirstName] [nvarchar](255) NOT NULL,
	[MiddleName] [nvarchar](255) NULL,
	[Lastname] [nvarchar](255) NOT NULL,
	[Pseudonym] [nvarchar](255) NULL,
	[BirthDate] [date] NULL,
	[Gender] [tinyint] NULL,
	[DeathDate] [date] NULL,
	[IsAlive] [bit] NULL,
	[NumberOfBooks] [smallint] NULL,
	[CountryID] [int] NULL,
	[Biography] [nvarchar](max) NULL,
	[Website] [nvarchar](255) NULL,
 CONSTRAINT [PK_Author] PRIMARY KEY CLUSTERED 
(
	[AuthorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Book].[Author]  WITH CHECK ADD  CONSTRAINT [FK_Author_Country] FOREIGN KEY([CountryID])
REFERENCES [Zone].[Country] ([CountryID])
ON UPDATE CASCADE
GO

ALTER TABLE [Book].[Author] CHECK CONSTRAINT [FK_Author_Country]
GO

