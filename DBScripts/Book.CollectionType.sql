USE [BookWormDB]
GO

/****** Object:  Table [Book].[CollectionType]    Script Date: 24/12/1403 10:58:56 ق.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Book].[CollectionType](
	[CollectionTypeID] [tinyint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Discription] [nvarchar](max) NULL,
 CONSTRAINT [PK_CollectionType] PRIMARY KEY CLUSTERED 
(
	[CollectionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

