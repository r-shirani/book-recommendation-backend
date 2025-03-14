USE [BookWormDB]
GO

/****** Object:  Table [Book].[Collection]    Script Date: 24/12/1403 10:58:42 ق.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Book].[Collection](
	[CollectionID] [bigint] NOT NULL,
	[CollectionTypeID] [tinyint] NULL,
	[AccessibilityGroupID] [bigint] NOT NULL,
	[Title] [nvarchar](255) NULL,
	[CreateDate] [date] NULL,
	[Discription] [nvarchar](max) NULL,
	[GenreID] [int] NULL,
	[HashTagString] [nvarchar](max) NULL,
 CONSTRAINT [PK_Collection] PRIMARY KEY CLUSTERED 
(
	[CollectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Book].[Collection] ADD  CONSTRAINT [DF_Collection_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO

ALTER TABLE [Book].[Collection]  WITH CHECK ADD  CONSTRAINT [FK_Collection_CollectionType] FOREIGN KEY([CollectionTypeID])
REFERENCES [Book].[CollectionType] ([CollectionTypeID])
ON UPDATE CASCADE
GO

ALTER TABLE [Book].[Collection] CHECK CONSTRAINT [FK_Collection_CollectionType]
GO

