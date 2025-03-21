USE [BookWormDB]
GO
/****** Object:  View [User].[vwAllFieldUser]    Script Date: 01/01/1404 12:24:54 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE     VIEW [User].[vwAllFieldUser]
AS
	SELECT 
		U.[UserID], U.[UserName], U.[FirstName], U.[LastName], 
		U.[PhoneNumber], U.[Email], U.[Bio], U.[Gender], 
		U.[WebSite], U.[UserTypeID], U.[DateOfBrith], 
		S.[ID], S.[PassHint], S.[LastLogin], 
		S.[Status], S.[LockOutEnd], S.[IsEmailVerified], 
		S.[IsPhoneVerified], S.[FailedLoginAttempts], 
		S.[CreateDate], S.[ClientEmailID], S.[PasswordHash], S.[Salt], S.[VerificationCode],
		T.[Code] AS UserTypeCode, T.[MainName] AS UserTypeTitle, T.[Description] AS UserTypeDescription
	FROM [User].[User] AS U
	LEFT JOIN [User].[Security] AS S
		ON U.UserID = S.UserID
	LEFT JOIN [User].[UserType] AS T
		ON U.UserID = T.UserTypeID
GO
