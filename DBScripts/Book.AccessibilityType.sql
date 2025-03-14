USE [BookWormDB]
GO

/****** Object:  Table [Book].[AccessibilityType]    Script Date: 24/12/1403 10:58:04 ق.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Book].[AccessibilityType](
	[AccessibilityTypeID] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[CanRead] [bit] NOT NULL,
	[CanInsert] [bit] NOT NULL,
	[CanDelete] [bit] NOT NULL,
	[CanChangeHeader] [bit] NOT NULL,
 CONSTRAINT [PK_AccessibilityType] PRIMARY KEY CLUSTERED 
(
	[AccessibilityTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Book].[AccessibilityType] ADD  CONSTRAINT [DF_AccessibilityType_CanRead]  DEFAULT ((1)) FOR [CanRead]
GO

ALTER TABLE [Book].[AccessibilityType] ADD  CONSTRAINT [DF_AccessibilityType_CanInsert]  DEFAULT ((0)) FOR [CanInsert]
GO

ALTER TABLE [Book].[AccessibilityType] ADD  CONSTRAINT [DF_AccessibilityType_CanDelete]  DEFAULT ((0)) FOR [CanDelete]
GO

ALTER TABLE [Book].[AccessibilityType] ADD  CONSTRAINT [DF_AccessibilityType_CanChangeHeader]  DEFAULT ((0)) FOR [CanChangeHeader]
GO

