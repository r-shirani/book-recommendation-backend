USE [BookWormDB]
GO

/****** Object:  UserDefinedFunction [User].[funLogin]    Script Date: 22/12/1403 12:02:43 ب.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [User].[funLogin]
(
	@userName NVARCHAR(255),
	@email NVARCHAR(255)
)
RETURNS TABLE 
AS RETURN 
(
	SELECT * 
	FROM vwAllFieldUser 
	WHERE (UserName = @userName) OR (Email = @email)
);
GO

