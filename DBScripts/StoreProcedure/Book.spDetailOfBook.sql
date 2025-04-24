CREATE OR ALTER PROCEDURE Book.spDetailOfBook(@BOOKID AS BIGINT)
AS 
	SELECT 
		B.[BookID], B.[Title], 
		B.[AuthorID], CONCAT(A.FirstName, ' ', A.Lastname) AS AuthorName,  
		B.[PublisherID], P.Title AS PublisherName,  
		B.[GenreID1], G1.Title AS GenreName1, 
		B.[GenreID2], G2.Title AS GenreName2, 
		B.[GenreID3], G3.Title AS GenreName3,  
		B.[GenreExtra], B.[Description], B.[PublishedYear], 
		B.[LanguageID], L.Title AS LanguageName,
		B.[PageCount], B.[ISBN], B.[CreatedAt], B.[UpdatedAt]
	FROM BOOK.Book AS B
	LEFT JOIN BOOK.Genre AS G1
		ON B.GenreID1 = G1.GenreID
	LEFT JOIN BOOK.Genre AS G2
		ON B.GenreID2 = G2.GenreID
	LEFT JOIN BOOK.Genre AS G3
		ON B.GenreID3 = G3.GenreID
	LEFT JOIN BOOK.Author AS A
		ON B.AuthorID = A.AuthorID
	LEFT JOIN BOOK.Publisher AS P
		ON B.PublisherID = P.PublisherID
	LEFT JOIN BOOK.Language AS L
		ON B.LanguageID = L.LanguageID

	WHERE (B.BookID  =@BOOKID)

	