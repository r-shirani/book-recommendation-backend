USE [BookWormDB]
GO
/****** Object:  StoredProcedure [User].[spSignupUser]    Script Date: 23/12/1403 11:35:35 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [User].[spSignupUser]
	@name  NVARCHAR(255),
	@pass  NVARCHAR(255),
	@email NVARCHAR(255),
	@clientEmailID NVARCHAR(MAX)
AS
BEGIN
	DECLARE @UserID AS BIGINT;
	DECLARE @UserName NVARCHAR(MAX);

    SELECT @UserID = UserID FROM [User].[User] WHERE Email = @email

	If ISNULL(@UserID,0) <> 0
    BEGIN
        SELECT @UserID AS UserID, 'exists' AS Message;
        RETURN;
    END
    
	BEGIN TRAN;
	SELECT @UserID = ISNULL(MAX(UserID),0) + 1 FROM [User].[User];

	SET @UserName = CONCAT(@name,'-',(@UserID*7));

    INSERT INTO [User].[User](UserID, UserName, FirstName, Email, UserTypeID)
    VALUES (@UserID,  @UserName, @name, @email, 1);

    INSERT INTO [User].[Security]	
		([UserID], [Status], [IsEmailVerified], PasswordHash, ClientEmailID)
    VALUES (@UserID, 1, 1, @pass, @clientEmailID);
	COMMIT TRAN;

    SELECT @UserID AS userID, @UserName AS userName,'success' AS message;
END;
