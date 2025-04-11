Unit Service.Book.Genre;

Interface

Uses
    System.Generics.Collections,
    System.SysUtils,
    MVCFramework.ActiveRecord,
    Model.Book.Genre;

Type
    IGenreService = Interface
        ['{3A7B8D9E-0F12-4A3C-9E1D-2F6C5E8A1B4D}']
        Function GetGenreByID(Const GenreID: SmallInt): TGenre;
        Function GetAllGenres: TObjectList<TGenre>;
        Procedure AddGenre(Const AGenre: TGenre);
        Procedure UpdateGenre(Const AGenre: TGenre);
        Procedure DeleteGenre(Const GenreID: SmallInt);
    End;

    TGenreService = Class(TInterfacedObject, IGenreService)
    Public
        Function GetGenreByID(Const GenreID: SmallInt): TGenre;
        Function GetAllGenres: TObjectList<TGenre>;
        Procedure AddGenre(Const AGenre: TGenre);
        Procedure UpdateGenre(Const AGenre: TGenre);
        Procedure DeleteGenre(Const GenreID: SmallInt);
    End;

Implementation

{ TGenreService }

//______________________________________________________________________________
Function TGenreService.GetGenreByID(Const GenreID: SmallInt): TGenre;
Begin
    Try
        Result := TMVCActiveRecord.GetByPK<TGenre>(GenreID);
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function TGenreService.GetAllGenres: TObjectList<TGenre>;
Begin
    Try
        Result := TMVCActiveRecord.All<TGenre>;
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Procedure TGenreService.AddGenre(Const AGenre: TGenre);
Begin
    If AGenre.Title.Trim = '' Then
        Raise Exception.Create('Genre title cannot be empty');

    AGenre.Insert;
End;
//______________________________________________________________________________
Procedure TGenreService.UpdateGenre(Const AGenre: TGenre);
Var
    OldGenre: TGenre;
Begin
    OldGenre := TMVCActiveRecord.GetByPK<TGenre>(AGenre.GenreID);
    Try
        If Not Assigned(OldGenre) Then
            Raise Exception.Create('Genre Not Found');

        // Update only fields that have new values
        If AGenre.Title <> '' Then OldGenre.Title := AGenre.Title;
        If AGenre.SuitableAge > 0 Then OldGenre.SuitableAge := AGenre.SuitableAge;
        If Not AGenre.SDescription.IsNull Then OldGenre.SDescription := AGenre.SDescription;

        // Save changes
        OldGenre.Update;
    Finally
        OldGenre.Free;
    End;
End;
//______________________________________________________________________________
Procedure TGenreService.DeleteGenre(Const GenreID: SmallInt);
Var
    GenreToDelete: TGenre;
Begin
    GenreToDelete := TMVCActiveRecord.GetByPK<TGenre>(GenreID);
    Try
        If Not Assigned(GenreToDelete) Then
            Raise Exception.Create('Genre Not Found');

        GenreToDelete.Delete;
    Finally
        GenreToDelete.Free;
    End;
End;
//______________________________________________________________________________

End.
