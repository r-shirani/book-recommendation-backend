CREATE OR ALTER VIEW Book.vwBook
AS
	SELECT 
		B.[BookID], 
		B.[Title], 
		B.[GenreID1], G1.[Title] AS GenreName1, 
		B.[GenreID2], G2.[Title] AS GenreName2, 
		B.[GenreID3], G3.[Title] AS GenreName3, 
		B.[GenreExtra], 
		(SELECT AVG(Rate) FROM Book.Rate WHERE BookID = B.BookID) AS AvgRate
	FROM Book.Book AS B
	LEFT JOIN Book.Genre AS G1 ON B.GenreID1 = G1.GenreID
	LEFT JOIN Book.Genre AS G2 ON B.GenreID2 = G2.GenreID
	LEFT JOIN Book.Genre AS G3 ON B.GenreID3 = G3.GenreID
