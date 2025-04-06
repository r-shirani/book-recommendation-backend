	CREATE OR ALTER PROCEDURE Book.spSearchBook
	(
		@Text AS NVARCHAR(100), 
		@PageNum AS INT, 
		@Count AS INT
	 )
	AS
	BEGIN
		SELECT * FROM Book.vwBook AS B
		WHERE B.Title LIKE N'%' + @Text + '%'
		ORDER BY B.Title
	END;
	GO


	exec  Book.spSearchBook N'ิวา' , 2 , 50


