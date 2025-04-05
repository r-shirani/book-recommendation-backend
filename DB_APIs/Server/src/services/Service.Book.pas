﻿Unit Service.Book;

Interface

Uses
    System.Generics.Collections,
    System.SysUtils,
    MVCFramework.ActiveRecord,
    Model.Book,
    Model.Book.Comment,
    Model.Book.Rate;

Type
    IBookService = interface
        ['{D4B5D8E0-5B44-4D1B-823F-6C9B3F6A8F6A}']
        Function GetBookByID(const BookID: Int64): TBook;
        Function GetAllBooks: TObjectList<TBook>;
        Procedure AddBook(const ABook: TBook);
        Procedure UpdateBook(const ABook: TBook);
        Procedure DeleteBook(const BookID: Int64);
    End;

    TBookService = class(TInterfacedObject, IBookService)
    Public
        Function GetBookByID(const BookID: Int64): TBook;
        Function GetAllBooks: TObjectList<TBook>;
        Procedure AddBook(const ABook: TBook);
        Procedure UpdateBook(const ABook: TBook);
        Procedure DeleteBook(const BookID: Int64);
    Private
        Procedure DeleteRelatedComments(const BookID: Int64);
        Procedure DeleteRelatedRates(const BookID: Int64);
    End;

Implementation

{ TBookService }

//______________________________________________________________________________
Function TBookService.GetBookByID(const BookID: Int64): TBook;
Begin
    Try
        Result := TMVCActiveRecord.GetByPK<TBook>(BookID);
    Except
        Result := nil;
    End;
End;
//______________________________________________________________________________
Function TBookService.GetAllBooks: TObjectList<TBook>;
Begin
    Try
        Result := TMVCActiveRecord.All<TBook>;
    Except
        Result := nil;
    End;
End;
//______________________________________________________________________________
Procedure TBookService.AddBook(const ABook: TBook);
Begin
    ABook.Insert;
End;
//______________________________________________________________________________
Procedure TBookService.UpdateBook(const ABook: TBook);
Var
    OldBook: TBook;
Begin
    OldBook := TMVCActiveRecord.GetByPK<TBook>(ABook.BookID);
    Try
        If not Assigned(OldBook) then
          raise Exception.Create('Book Not Found');
        If ABook.Title <> '' then OldBook.Title := ABook.Title;
        If not ABook.AuthorID.IsNull then OldBook.AuthorID := ABook.AuthorID;
        If not ABook.PublisherID.IsNull then OldBook.PublisherID := ABook.PublisherID;
        If not ABook.GenreID1.IsNull then OldBook.GenreID1 := ABook.GenreID1;
        If not ABook.GenreID2.IsNull then OldBook.GenreID2 := ABook.GenreID2;
        If not ABook.GenreID3.IsNull then OldBook.GenreID3 := ABook.GenreID3;
        If not ABook.GenreExtra.IsNull then OldBook.GenreExtra := ABook.GenreExtra;
        If not ABook.Description.IsNull then OldBook.Description := ABook.Description;
        If not ABook.PublishedYear.IsNull then OldBook.PublishedYear := ABook.PublishedYear;
        If not ABook.LanguageID.IsNull then OldBook.LanguageID := ABook.LanguageID;
        If not ABook.PageCount.IsNull then OldBook.PageCount := ABook.PageCount;
        If not ABook.ISBN.IsNull then OldBook.ISBN := ABook.ISBN;
        OldBook.UpdatedAt := Now;
        OldBook.Update;
    Finally
        OldBook.Free;
    End;
End;
//______________________________________________________________________________
Procedure TBookService.DeleteBook(const BookID: Int64);
Var
    Book: TBook;
Begin
    Book := TMVCActiveRecord.GetByPK<TBook>(BookID);
    Try
        If not Assigned(Book) then
            raise Exception.Create('Book Not Found');

        // First delete related comments and rates
        DeleteRelatedComments(BookID);
        DeleteRelatedRates(BookID);

        // Then delete the book itself
        Book.Delete;
    Finally
        Book.Free;
    End;
End;
//______________________________________________________________________________
Procedure TBookService.DeleteRelatedComments(const BookID: Int64);
Begin
    // Delete all comments related to this book
    TMVCActiveRecord.DeleteRQL(TComment, 'BookID=' + BookID.ToString);
End;
//______________________________________________________________________________
Procedure TBookService.DeleteRelatedRates(const BookID: Int64);
Begin
    // Delete all rates related to this book
    TMVCActiveRecord.DeleteRQL(TComment, 'BookID=' + BookID.ToString);
End;
//______________________________________________________________________________

End.
