Unit Service.Book.Hashtag;

Interface

Uses
    System.Generics.Collections,
    System.SysUtils,
    MVCFramework.ActiveRecord,
    Model.Book.Hashtag;

Type
    IHashtagService = Interface
        ['{8C9D7E6F-5A4B-3C2D-1E0F-9A8B7C6D5E4F}']
        Function GetHashtagByID(Const HashtagCollectionID: Int64): THashtag;
        Function GetAllHashtags: TObjectList<THashtag>;
        Function GetHashtagsByCollectionID(Const CollectionID: Int64): TObjectList<THashtag>;
        Function GetHashtagsByTitle(Const Title: String): TObjectList<THashtag>;
        Function GetPopularHashtags(Limit: Integer = 10): TObjectList<THashtag>;
        Procedure AddHashtag(Const AHashtag: THashtag);
        Procedure UpdateHashtag(Const AHashtag: THashtag);
        Procedure DeleteHashtag(Const HashtagCollectionID: Int64);
    End;

    THashtagService = Class(TInterfacedObject, IHashtagService)
    Public
        Function GetHashtagByID(Const HashtagCollectionID: Int64): THashtag;
        Function GetAllHashtags: TObjectList<THashtag>;
        Function GetHashtagsByCollectionID(Const CollectionID: Int64): TObjectList<THashtag>;
        Function GetHashtagsByTitle(Const Title: String): TObjectList<THashtag>;
        Function GetPopularHashtags(Limit: Integer = 10): TObjectList<THashtag>;
        Procedure AddHashtag(Const AHashtag: THashtag);
        Procedure UpdateHashtag(Const AHashtag: THashtag);
        Procedure DeleteHashtag(Const HashtagCollectionID: Int64);
    End;

Implementation

{ THashtagService }

//______________________________________________________________________________
Function THashtagService.GetHashtagByID(Const HashtagCollectionID: Int64): THashtag;
Begin
    Try
        Result := TMVCActiveRecord.GetByPK<THashtag>(HashtagCollectionID);
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function THashtagService.GetAllHashtags: TObjectList<THashtag>;
Begin
    Try
        Result := TMVCActiveRecord.All<THashtag>;
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function THashtagService.GetHashtagsByCollectionID(Const CollectionID: Int64): TObjectList<THashtag>;
Begin
    Try
        Result := TMVCActiveRecord.Where<THashtag>('CollectionID = ?', [CollectionID]);
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function THashtagService.GetHashtagsByTitle(Const Title: String): TObjectList<THashtag>;
Begin
    Try
        Result := TMVCActiveRecord.Where<THashtag>(
            'Title LIKE ?',
            ['%' + Title.Trim + '%']
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
Function THashtagService.GetPopularHashtags(Limit: Integer = 10): TObjectList<THashtag>;
Begin
    Try
        // Assuming there's a usage count or similar metric in another table
        // This is a placeholder - implementation depends on your database structure
        Result := TMVCActiveRecord.Select<THashtag>(
            'SELECT h.* FROM Book.Hashtag h ' +
            'JOIN Book.HashtagUsage u ON h.HashtagCollectionID = u.HashtagCollectionID ' +
            'GROUP BY h.HashtagCollectionID ' +
            'ORDER BY COUNT(u.UsageID) DESC ' +
            'LIMIT ?', [Limit]);
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Procedure THashtagService.AddHashtag(Const AHashtag: THashtag);
Begin
    If AHashtag.Title.IsNull Or (AHashtag.Title.Value.Trim = '') Then
        Raise Exception.Create('Hashtag title cannot be empty');

    // Remove # if included (optional)
    If AHashtag.Title.Value.StartsWith('#') Then
        AHashtag.Title := AHashtag.Title.Value.Substring(1).Trim;

    AHashtag.Insert;
End;
//______________________________________________________________________________
Procedure THashtagService.UpdateHashtag(Const AHashtag: THashtag);
Var
    OldHashtag: THashtag;
Begin
    OldHashtag := TMVCActiveRecord.GetByPK<THashtag>(AHashtag.HashtagCollectionID);
    Try
        If Not Assigned(OldHashtag) Then
            Raise Exception.Create('Hashtag Not Found');

        // Update only fields that have new values
        If Not AHashtag.Title.IsNull Then
        Begin
            If AHashtag.Title.Value.Trim = '' Then
                Raise Exception.Create('Hashtag title cannot be empty');

            // Remove # if included (optional)
            If AHashtag.Title.Value.StartsWith('#') Then
                OldHashtag.Title := AHashtag.Title.Value.Substring(1).Trim
            Else
                OldHashtag.Title := AHashtag.Title;
        End;

        If Not AHashtag.CollectionID.IsNull Then
            OldHashtag.CollectionID := AHashtag.CollectionID;

        // Save changes
        OldHashtag.Update;
    Finally
        OldHashtag.Free;
    End;
End;
//______________________________________________________________________________
Procedure THashtagService.DeleteHashtag(Const HashtagCollectionID: Int64);
Var
    HashtagToDelete: THashtag;
Begin
    HashtagToDelete := TMVCActiveRecord.GetByPK<THashtag>(HashtagCollectionID);
    Try
        If Not Assigned(HashtagToDelete) Then
            Raise Exception.Create('Hashtag Not Found');

        HashtagToDelete.Delete;
    Finally
        HashtagToDelete.Free;
    End;
End;
//______________________________________________________________________________

End.
