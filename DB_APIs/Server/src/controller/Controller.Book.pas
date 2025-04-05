﻿Unit Controller.Book;

Interface

Uses
    System.JSON,
    System.Variants,
    System.Generics.Collections,
    MVCFramework,
    MVCFramework.Commons,
    MVCFramework.ActiveRecord,
    Model.Book,
    Service.Book,
    WebModule.Main;

Type
    [MVCPath(BASE_API_V1 + '/book')]
    TBookController = class(TMVCController)
    Private
        FBookService: IBookService;

    Public
        Constructor Create; override;
        Destructor Destroy; override;

        [MVCPath('/getAllBooks')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetAllBooks;

        [MVCPath('/($id)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetBookByID(Const id: Int64);

        [MVCPath('')]
        [MVCHTTPMethod([httpPOST])]
        Procedure AddBook;

        [MVCPath('')]
        [MVCHTTPMethod([httpPUT])]
        Procedure UpdateBook;

        [MVCPath('/($id)')]
        [MVCHTTPMethod([httpDELETE])]
        Procedure DeleteBook(Const id: Int64);
    End;

Implementation

{ TBookController }

//______________________________________________________________________________
Constructor TBookController.Create;
Begin
    Inherited;
    FBookService := TBookService.Create;
End;
//______________________________________________________________________________
Destructor TBookController.Destroy;
Begin
    FBookService := nil;
    Inherited;
End;
//______________________________________________________________________________
Procedure TBookController.GetAllBooks;
Var
    Books: TObjectList<TBook>;
Begin
    Books := FBookService.GetAllBooks;
    If Books.Count > 0 Then
        Render(Books)
    Else
        Render(HTTP_STATUS.NoContent);
End;
//______________________________________________________________________________
Procedure TBookController.GetBookByID(Const id: Int64);
Var
    Book: TBook;
Begin
    Book := FBookService.GetBookByID(id);
    If Assigned(Book) Then
        Render(Book)
    Else
        Render(HTTP_STATUS.NotFound);
End;
//______________________________________________________________________________
Procedure TBookController.AddBook;
Var
    Book: TBook;
Begin
    Book := Context.Request.BodyAs<TBook>;
    FBookService.AddBook(Book);
    Render(HTTP_STATUS.Created, 'Book added successfully');
End;
//______________________________________________________________________________
Procedure TBookController.UpdateBook;
Var
    Book: TBook;
Begin
    Book := Context.Request.BodyAs<TBook>;
    FBookService.UpdateBook(Book);
    Render(HTTP_STATUS.OK, 'Book updated successfully');
End;
//______________________________________________________________________________
Procedure TBookController.DeleteBook(Const id: Int64);
Begin
    FBookService.DeleteBook(id);
    Render(HTTP_STATUS.OK, 'Book deleted successfully');
End;
//______________________________________________________________________________


End.
