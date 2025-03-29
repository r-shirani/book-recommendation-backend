USE [BookWormDB]
GO
/****** Object:  StoredProcedure [User].[spRemoveUser]    Script Date: 01/01/1404 12:24:15 ب.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   PROCEDURE [User].[spRemoveUser]
(
    @userID AS NVARCHAR(255) = NULL,
    @userName AS NVARCHAR(255) = NULL,
    @email AS NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserCount INT;
    DECLARE @DeletedUserID INT;

    SELECT @DeletedUserID = UserID, @UserCount = COUNT(*) OVER()
    FROM [User].[User]
    WHERE (UserID = @userID) OR (UserName = @userName) OR (Email = @email);

    IF (@UserCount = 0) OR (@UserCount IS NULL)
    BEGIN
        SELECT NULL AS UserID, 'Failed' AS Status, 'Not_Found' AS Message;
        RETURN;
    END

    IF @UserCount > 1
    BEGIN
        SELECT NULL AS UserID, 'Failed' AS Status, 'More_Than_One' AS Message;
        RETURN;
    END

    DELETE FROM [User].[Security]
    WHERE UserID = @DeletedUserID;

    DELETE FROM [User].[User]
    WHERE UserID = @DeletedUserID;

    SELECT @DeletedUserID AS UserID, 'Succeeded' AS Status, 'Delete_Complete' AS Message;
END
GO
