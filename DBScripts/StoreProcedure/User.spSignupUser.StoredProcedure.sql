USE [BookWormDB]
GO
/****** Object:  StoredProcedure [User].[spSignupUser]    Script Date: 1403/12/29 05:51:24 عـصـر ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [User].[spSignupUser]
	@name  NVARCHAR(255),
	@pass  NVARCHAR(255),
	@email NVARCHAR(255),
	@clientEmailID NVARCHAR(255),
	@VerificationCode NVARCHAR(255)
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
		([UserID], [Status], PasswordHash, ClientEmailID, VerificationCode)
    VALUES (@UserID, 1, @pass, @clientEmailID, @VerificationCode);
	COMMIT TRAN;

    SELECT @UserID AS userID, @UserName AS userName,'success' AS message;
END;
