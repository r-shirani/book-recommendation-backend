Unit Service.Book.Like;

Interface

Uses
    System.Generics.Collections,
    System.SysUtils,
    MVCFramework.ActiveRecord,
    Model.Book.BookLike;

Type
    ILikeService = Interface
        ['{B36C2586-CCEE-423C-918D-9DFD9A22336D}']
        Function GeTBookLike(UserID, BookID: Int64): TObjectList<TBookLike>;
        Function GetBookLikes(BookID: Int64): TObjectList<TBookLike>;
        Function GetUserLikes(UserID: Int64): TObjectList<TBookLike>;
        Procedure AddLike(UserID, BookID: Int64);
        Procedure DeleteLike(UserID, BookID: Int64);
    End;

    TBookLikeService = Class(TInterfacedObject, ILikeService)
    Public
        Function GeTBookLike(UserID, BookID: Int64): TObjectList<TBookLike>;
        Function GetBookLikes(BookID: Int64): TObjectList<TBookLike>;
        Function GetUserLikes(UserID: Int64): TObjectList<TBookLike>;
        Procedure AddLike(UserID, BookID: Int64);
        Procedure DeleteLike(UserID, BookID: Int64);
    End;

Implementation

{ TBookLikeService }

//______________________________________________________________________________
Function TBookLikeService.GeTBookLike(UserID, BookID: Int64): TObjectList<TBookLike>;
Var
    Temp: TObjectList<TBookLike>;
Begin
    Temp := TMVCActiveRecord.Where<TBookLike>('UserID = ? AND BookID = ?', [UserID, BookID]);
    If (Temp.Count > 0) Then
        Result := Temp
    Else
        Result := nil;
End;
//______________________________________________________________________________
Function TBookLikeService.GetBookLikes(BookID: Int64): TObjectList<TBookLike>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TBookLike>('BookID = ?', [BookID]);
    Except
        On E: Exception Do
        Begin
            // Log Error: E.Message
            Result := TObjectList<TBookLike>.Create(True);
        End;
    End;
End;
//______________________________________________________________________________
Function TBookLikeService.GetUserLikes(UserID: Int64): TObjectList<TBookLike>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TBookLike>('UserID = ?', [UserID]);
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Procedure TBookLikeService.AddLike(UserID, BookID: Int64);
Var
    ALike: TBookLike;
Begin
    ALike := TBookLike.Create;
    Try
        ALike.UserID := UserID;
        ALike.BookID := BookID;
        ALike.Insert;
    Finally
        ALike.Free;
    End;
End;
//______________________________________________________________________________
Procedure TBookLikeService.DeleteLike(UserID, BookID: Int64);
Var
    LikeToDelete: TObjectList<TBookLike>;
    I: Integer;
Begin
    LikeToDelete := GeTBookLike(UserID, BookID);
    Try
        If Assigned(LikeToDelete) Then
        Begin
            For I := 0 to LikeToDelete.Count - 1 do LikeToDelete[I].Delete;
        End;
    Finally
        LikeToDelete.Free;
    End;
End;
//______________________________________________________________________________

End.
