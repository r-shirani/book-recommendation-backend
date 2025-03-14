USE [BookWormDB]
GO

/****** Object:  Table [Book].[AccessibilityGroup]    Script Date: 24/12/1403 10:57:39 ق.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Book].[AccessibilityGroup](
	[AccessibilityGroupID] [bigint] NOT NULL,
	[Title] [nvarchar](255) NULL,
	[Discription] [nvarchar](max) NULL,
	[AccessibilityTypeID] [int] NULL,
 CONSTRAINT [PK_AccessibilityGroup] PRIMARY KEY CLUSTERED 
(
	[AccessibilityGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Book].[AccessibilityGroup]  WITH CHECK ADD  CONSTRAINT [FK_AccessibilityGroup_AccessibilityType] FOREIGN KEY([AccessibilityTypeID])
REFERENCES [Book].[AccessibilityType] ([AccessibilityTypeID])
ON UPDATE CASCADE
GO

ALTER TABLE [Book].[AccessibilityGroup] CHECK CONSTRAINT [FK_AccessibilityGroup_AccessibilityType]
GO

