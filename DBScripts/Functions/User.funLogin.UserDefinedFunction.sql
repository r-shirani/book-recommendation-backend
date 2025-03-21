USE [BookWormDB]
GO
/****** Object:  UserDefinedFunction [User].[funLogin]    Script Date: 01/01/1404 12:23:54 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     FUNCTION [User].[funLogin]
(
	@userName NVARCHAR(255),
	@email NVARCHAR(255)
)
RETURNS TABLE 
AS RETURN 
(
	SELECT 
		[UserID], [UserName], [FirstName], [LastName], 
		[PhoneNumber], [Email], [Bio], [Gender], 
		[WebSite], [UserTypeID], [DateOfBrith], 
		[ID], [PassHint], [LastLogin], 
		[Status], [LockOutEnd], [IsEmailVerified], 
		[IsPhoneVerified], [FailedLoginAttempts], 
		[CreateDate], [ClientEmailID], [PasswordHash], [Salt], [VerificationCode],
		UserTypeCode, UserTypeTitle, UserTypeDescription	
	FROM vwAllFieldUser 
	WHERE (UserName = @userName) OR (Email = @email)
);
GO
