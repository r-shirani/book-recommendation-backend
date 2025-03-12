USE [BookWormDB]
GO

/****** Object:  StoredProcedure [User].[spSignupUser]    Script Date: 22/12/1403 12:02:27 ب.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [User].[spSignupUser]
	@name  NVARCHAR(255),
	@pass  NVARCHAR(255),
	@email NVARCHAR(255),
	@clientEmailID NVARCHAR(MAX)
AS
BEGIN
	DECLARE @MAXUserID AS BIGINT;
	DECLARE @UserName NVARCHAR(MAX);

    IF EXISTS (SELECT 1 FROM [User].[User] WHERE Email = @email)
    BEGIN
        SELECT -1 AS UserID, 'exists' AS Message;
        RETURN;
    END
    
	BEGIN TRAN;
	SELECT @MAXUserID = ISNULL(MAX(UserID),0) + 1 FROM [User].[User];

	SET @UserName = CONCAT(@name,'-',@MAXUserID);

    INSERT INTO [User].[User](UserID, UserName, FirstName, Email, UserTypeID)
    VALUES (@MAXUserID,  @UserName, @name, @email, 1);

    INSERT INTO [User].[Security]	
		([UserID], [Status], [IsEmailVerified], PasswordHash, ClientEmailID)
    VALUES (@MAXUserID, 1, 1, @pass, @clientEmailID);
	COMMIT TRAN;

    SELECT @MAXUserID AS userID, @UserName AS userName,'success' AS message;
END;
GO

