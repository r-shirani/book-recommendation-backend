CREATE OR ALTER PROCEDURE Book.spFavoritBook(@UserID AS BIGINT)
AS
BEGIN
	SELECT 
		B.[BookID], [Title], [AuthorID], [PublisherID], 
		[GenreID1], [GenreID2], [GenreID3], COUNT(LikeID) AS LIKECOUNT
	FROM  Book.Book AS B
	LEFT JOIN BOOK.[Like] AS L
		ON L.BookID = B.BookID
	WHERE L.UserID = @UserID
	GROUP BY B.[BookID], [Title], [AuthorID], [PublisherID], 
		[GenreID1], [GenreID2], [GenreID3]
	ORDER BY LIKECOUNT DESC
END;