﻿Unit Controller.Book.Author;

Interface

Uses
    System.JSON,
    System.Variants,
    System.Generics.Collections,
    MVCFramework,
    MVCFramework.Commons,
    MVCFramework.ActiveRecord,
    Model.Book.Author,
    Service.Book.Author,
    WebModule.Main;

Type
    [MVCPath(BASE_API_V1 + '/author')]
    TAuthorController = class(TMVCController)
    Private
        FAuthorService: IAuthorService;

    Public
        Constructor Create; override;
        Destructor Destroy; override;

        [MVCPath('')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetAllAuthors;

        [MVCPath('/($id)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetAuthorByID(Const id: Int64);

        [MVCPath('/search')]
        [MVCHTTPMethod([httpGET])]
        Procedure SearchAuthors(Const [MVCFromQueryString('name', '')] name: String);

        [MVCPath('/country/($countryID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetAuthorsByCountry(Const countryID: Int64);

        [MVCPath('')]
        [MVCHTTPMethod([httpPOST])]
        Procedure AddAuthor;

        [MVCPath('')]
        [MVCHTTPMethod([httpPUT])]
        Procedure UpdateAuthor;

        [MVCPath('/($id)')]
        [MVCHTTPMethod([httpDELETE])]
        Procedure DeleteAuthor(Const id: Int64);

        [MVCPath('/($id)/stats')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetAuthorStats(Const id: Int64);
    End;

Implementation

{ TAuthorController }

//______________________________________________________________________________
Constructor TAuthorController.Create;
Begin
    Inherited;
    FAuthorService := TAuthorService.Create;
End;
//______________________________________________________________________________
Destructor TAuthorController.Destroy;
Begin
    FAuthorService := nil;
    Inherited;
End;
//______________________________________________________________________________
Procedure TAuthorController.GetAllAuthors;
Var
    Authors: TObjectList<TAuthor>;
Begin
    Authors := FAuthorService.GetAllAuthors;
    Try
        If Authors.Count > 0 Then
            Render(Authors)
        Else
            Render(HTTP_STATUS.NoContent);
    Finally
        Authors.Free;
    End;
End;
//______________________________________________________________________________
Procedure TAuthorController.GetAuthorByID(Const id: Int64);
Var
    Author: TAuthor;
Begin
    Author := FAuthorService.GetAuthorByID(id);
    If Assigned(Author) Then
        Render(Author)
    Else
        Render(HTTP_STATUS.NotFound);
    Author.Free;
End;
//______________________________________________________________________________
Procedure TAuthorController.SearchAuthors(Const name: String);
Var
    Authors: TObjectList<TAuthor>;
Begin
    Authors := FAuthorService.GetAuthorsByName(name);
    Try
        If Authors.Count > 0 Then
            Render(Authors)
        Else
            Render(HTTP_STATUS.NoContent);
    Finally
        Authors.Free;
    End;
End;
//______________________________________________________________________________
Procedure TAuthorController.GetAuthorsByCountry(Const countryID: Int64);
Var
    Authors: TObjectList<TAuthor>;
Begin
    Authors := FAuthorService.GetAuthorsByCountry(countryID);
    Try
        If Authors.Count > 0 Then
            Render(Authors)
        Else
            Render(HTTP_STATUS.NoContent);
    Finally
        Authors.Free;
    End;
End;
//______________________________________________________________________________
Procedure TAuthorController.AddAuthor;
Var
    Author: TAuthor;
Begin
    Author := Context.Request.BodyAs<TAuthor>;
    Try
        FAuthorService.AddAuthor(Author);
        Render(HTTP_STATUS.Created, 'Author added successfully');
    Finally
        Author.Free;
    End;
End;
//______________________________________________________________________________
Procedure TAuthorController.UpdateAuthor;
Var
    Author: TAuthor;
Begin
    Author := Context.Request.BodyAs<TAuthor>;
    Try
        FAuthorService.UpdateAuthor(Author);
        Render(HTTP_STATUS.OK, 'Author updated successfully');
    Finally
        Author.Free;
    End;
End;
//______________________________________________________________________________
Procedure TAuthorController.DeleteAuthor(Const id: Int64);
Begin
    FAuthorService.DeleteAuthor(id);
    Render(HTTP_STATUS.OK, 'Author deleted successfully');
End;
//______________________________________________________________________________
Procedure TAuthorController.GetAuthorStats(Const id: Int64);
Var
    Author: TAuthor;
Begin
    Author := FAuthorService.GetAuthorByID(id);
    If Assigned(Author) Then
    Begin
        FAuthorService.UpdateAuthorStats(id);
        Render(Author)
    End
    Else
        Render(HTTP_STATUS.NotFound);
    Author.Free;
End;
//______________________________________________________________________________

End.
