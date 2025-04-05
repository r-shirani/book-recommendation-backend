﻿Unit Service.Book.Author;

Interface

Uses
    System.Generics.Collections,
    System.SysUtils,
    System.DateUtils,
    MVCFramework.ActiveRecord,
    Model.Book.Author,
    Model.Book;

Type
    IAuthorService = Interface
        ['{9181B91B-4556-40BA-81C6-D2A7BB5D1306}']
        Function GetAuthorByID(Const AuthorID: Integer): TAuthor;
        Function GetAllAuthors: TObjectList<TAuthor>;
        Function GetAuthorsByName(Const Name: String): TObjectList<TAuthor>;
        Function GetAuthorsByCountry(Const CountryID: Integer): TObjectList<TAuthor>;
        Procedure AddAuthor(Const AAuthor: TAuthor);
        Procedure UpdateAuthor(Const AAuthor: TAuthor);
        Procedure DeleteAuthor(Const AuthorID: Integer);
        Procedure UpdateAuthorStats(Const AuthorID: Integer);
    End;

    TAuthorService = Class(TInterfacedObject, IAuthorService)
    Public
        Function GetAuthorByID(Const AuthorID: Integer): TAuthor;
        Function GetAllAuthors: TObjectList<TAuthor>;
        Function GetAuthorsByName(Const Name: String): TObjectList<TAuthor>;
        Function GetAuthorsByCountry(Const CountryID: Integer): TObjectList<TAuthor>;
        Procedure AddAuthor(Const AAuthor: TAuthor);
        Procedure UpdateAuthor(Const AAuthor: TAuthor);
        Procedure DeleteAuthor(Const AuthorID: Integer);
        Procedure UpdateAuthorStats(Const AuthorID: Integer);
    End;

Implementation

{ TAuthorService }

//______________________________________________________________________________
Function TAuthorService.GetAuthorByID(Const AuthorID: Integer): TAuthor;
Begin
    Try
        Result := TMVCActiveRecord.GetByPK<TAuthor>(AuthorID);
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function TAuthorService.GetAllAuthors: TObjectList<TAuthor>;
Begin
    Try
        Result := TMVCActiveRecord.All<TAuthor>;
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function TAuthorService.GetAuthorsByName(Const Name: String): TObjectList<TAuthor>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TAuthor>(
            'FirstName LIKE ? OR LastName LIKE ? OR Pseudonym LIKE ?',
            ['%' + Name + '%', '%' + Name + '%', '%' + Name + '%']
        );
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function TAuthorService.GetAuthorsByCountry(Const CountryID: Integer): TObjectList<TAuthor>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TAuthor>('CountryID = ?', [CountryID]);
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Procedure TAuthorService.AddAuthor(Const AAuthor: TAuthor);
Begin
    If AAuthor.FirstName.Trim = '' Then
        Raise Exception.Create('First name cannot be empty');

    If AAuthor.LastName.Trim = '' Then
        Raise Exception.Create('Last name cannot be empty');

    // Validate dates
    If Not AAuthor.BirthDate.IsNull Then
    Begin
        If (AAuthor.BirthDate.Value > Now) Then
            Raise Exception.Create('Birth date cannot be in the future');

        If Not AAuthor.DeathDate.IsNull And (AAuthor.DeathDate.Value < AAuthor.BirthDate.Value) Then // استفاده از .Value
            Raise Exception.Create('Death date cannot be before birth date');
    End;

    // Auto-set IsAlive if not specified
    If AAuthor.IsAlive.IsNull Then
        AAuthor.IsAlive := AAuthor.DeathDate.IsNull;

    AAuthor.Insert;
End;
//______________________________________________________________________________
Procedure TAuthorService.UpdateAuthor(Const AAuthor: TAuthor);
Var
    OldAuthor: TAuthor;
Begin
    OldAuthor := TMVCActiveRecord.GetByPK<TAuthor>(AAuthor.AuthorID);
    Try
        If Not Assigned(OldAuthor) Then
            Raise Exception.Create('Author Not Found');

        // Update basic info
        If AAuthor.FirstName <> '' Then OldAuthor.FirstName := AAuthor.FirstName;
        If Not AAuthor.MiddleName.IsNull Then OldAuthor.MiddleName := AAuthor.MiddleName;
        If AAuthor.LastName <> '' Then OldAuthor.LastName := AAuthor.LastName;
        If Not AAuthor.Pseudonym.IsNull Then OldAuthor.Pseudonym := AAuthor.Pseudonym;

        // Update personal details
        If Not AAuthor.BirthDate.IsNull Then
        Begin
            If (AAuthor.BirthDate.Value > Now) Then
                Raise Exception.Create('Birth date cannot be in the future');
            OldAuthor.BirthDate := AAuthor.BirthDate;
        End;

        If Not AAuthor.DeathDate.IsNull Then
        Begin
            If (Not OldAuthor.BirthDate.IsNull) And (AAuthor.DeathDate.Value < OldAuthor.BirthDate.Value) Then
                Raise Exception.Create('Death date cannot be before birth date');
            OldAuthor.DeathDate := AAuthor.DeathDate;
            OldAuthor.IsAlive := False;
        End
        Else If AAuthor.IsAlive = False Then
        Begin
            OldAuthor.IsAlive := False;
        End;

        // Update other fields
        If Not AAuthor.Gender.IsNull Then OldAuthor.Gender := AAuthor.Gender;
        If Not AAuthor.CountryID.IsNull Then OldAuthor.CountryID := AAuthor.CountryID;
        If Not AAuthor.Biography.IsNull Then OldAuthor.Biography := AAuthor.Biography;
        If Not AAuthor.Website.IsNull Then OldAuthor.Website := AAuthor.Website;

        // Save changes
        OldAuthor.Update;
    Finally
        OldAuthor.Free;
    End;
End;
//______________________________________________________________________________
Procedure TAuthorService.DeleteAuthor(Const AuthorID: Integer);
Var
    AuthorToDelete: TAuthor;
Begin
    AuthorToDelete := TMVCActiveRecord.GetByPK<TAuthor>(AuthorID);
    Try
        If Not Assigned(AuthorToDelete) Then
            Raise Exception.Create('Author Not Found');

        AuthorToDelete.Delete;
    Finally
        AuthorToDelete.Free;
    End;
End;
//______________________________________________________________________________
Procedure TAuthorService.UpdateAuthorStats(Const AuthorID: Integer);
Var
    Author: TAuthor;
    BookCount: Integer;
Begin
    Author := TMVCActiveRecord.GetByPK<TAuthor>(AuthorID);
    If Not Assigned(Author) Then
        Raise Exception.Create('Author Not Found');

    Try
        // Get book count for this author (assuming there's a Book table with AuthorID field)
        BookCount := TMVCActiveRecord.Count<TBook>('AuthorID = ' + AuthorID.ToString);

        Author.NumberOfBooks := BookCount;
        Author.Update;
    Finally
        Author.Free;
    End;
End;
//______________________________________________________________________________

End.
