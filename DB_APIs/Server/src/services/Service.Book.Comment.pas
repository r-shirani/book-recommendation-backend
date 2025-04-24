Unit Service.Book.Comment;

Interface

Uses
    System.Generics.Collections,
    System.SysUtils,
    MVCFramework.ActiveRecord,
    Model.Book.Comment,
    Model.Book;

Type
    ICommentService = Interface
        ['{B2C3D4E5-F6A7-4891-B3C4-D5E6F7A8B9C0}']
        Function GetCommentByID(CommentID: Int64): TComment;
        Function GetCommentsByBook(BookID: Int64; IncludeBlocked: Boolean = False): TObjectList<TComment>;
        Function GetCommentsByUser(UserID: Int64): TObjectList<TComment>;
        Function GetReplies(CommentID: Int64): TObjectList<TComment>;
        Function GetPopularComments(BookID: Int64; Limit: Integer = 5): TObjectList<TComment>;
        Procedure AddComment(Comment: TComment);
        Procedure UpdateComment(Comment: TComment);
        Procedure DeleteComment(CommentID: Int64);
        Procedure BlockComment(CommentID: Int64);
        Procedure ReportComment(CommentID: Int64; ReportID: Int64);
        Procedure LikeComment(CommentID: Int64);
        Procedure DislikeComment(CommentID: Int64);
        Procedure MarkAsSpoiler(CommentID: Int64);
    End;

    TCommentService = Class(TInterfacedObject, ICommentService)
    Public
        Function GetCommentByID(CommentID: Int64): TComment;
        Function GetCommentsByBook(BookID: Int64; IncludeBlocked: Boolean = False): TObjectList<TComment>;
        Function GetCommentsByUser(UserID: Int64): TObjectList<TComment>;
        Function GetReplies(CommentID: Int64): TObjectList<TComment>;
        Function GetPopularComments(BookID: Int64; Limit: Integer = 5): TObjectList<TComment>;
        Procedure AddComment(Comment: TComment);
        Procedure UpdateComment(Comment: TComment);
        Procedure DeleteComment(CommentID: Int64);
        Procedure BlockComment(CommentID: Int64);
        Procedure ReportComment(CommentID: Int64; ReportID: Int64);
        Procedure LikeComment(CommentID: Int64);
        Procedure DislikeComment(CommentID: Int64);
        Procedure MarkAsSpoiler(CommentID: Int64);
    End;

Implementation

{ TCommentService }

//______________________________________________________________________________
Function TCommentService.GetCommentByID(CommentID: Int64): TComment;
Begin
    Try
        Result := TMVCActiveRecord.GetByPK<TComment>(CommentID);
    Except
        On E: Exception Do
        Begin
            // Log error
            Result := nil;
        End;
    End;
End;
//______________________________________________________________________________
Function TCommentService.GetCommentsByBook(BookID: Int64; IncludeBlocked: Boolean = False): TObjectList<TComment>;
Var
    WhereClause: String;
Begin
    Try
        WhereClause := 'BookID = ? AND CommentRefID IS NULL';
        If not IncludeBlocked then
            WhereClause := WhereClause + ' AND (IsBlocked IS NULL OR IsBlocked = 0)';

        Result := TMVCActiveRecord.Where<TComment>(WhereClause, [BookID]);
    Except
        On E: Exception Do
        Begin
            // Log error
            Result := nil;
        End;
    End;
End;
//______________________________________________________________________________
Function TCommentService.GetCommentsByUser(UserID: Int64): TObjectList<TComment>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TComment>(
            'UserID = ? AND ((IsBlocked IS NULL) OR (IsBlocked = 0))',
            [UserID]
        );
    Except
        On E: Exception Do
        Begin
            // Log error
            Result := nil;
        End;
    End;
End;
//______________________________________________________________________________
Function TCommentService.GetReplies(CommentID: Int64): TObjectList<TComment>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TComment>(
            'CommentRefID = ? AND (IsBlocked IS NULL OR IsBlocked = 0)',
            [CommentID]
        );
    Except
        On E: Exception Do
        Begin
            // Log error
            Result := nil;
        End;
    End;
End;
//______________________________________________________________________________
Function TCommentService.GetPopularComments(BookID: Int64; Limit: Integer = 5): TObjectList<TComment>;
Begin
    Try
        Result := TMVCActiveRecord.Select<TComment>(
            'SELECT * FROM Book.Comment ' +
            'WHERE BookID = ? AND (IsBlocked IS NULL OR IsBlocked = 0) ' +
            'ORDER BY (COALESCE(LikeCount,0) - (COALESCE(DisLikeCount,0)) DESC ' +
            'LIMIT ?', [BookID, Limit]);
    Except
        On E: Exception Do
        Begin
            // Log error
            Result := nil;
        End;
    End;
End;
//______________________________________________________________________________
Procedure TCommentService.AddComment(Comment: TComment);
Begin
    If Comment.Text.IsNull or (Comment.Text.Value.Trim = '') then
        raise Exception.Create('Comment text cannot be empty');

    If Comment.UserID <= 0 then
        raise Exception.Create('Invalid UserID');

    If Comment.BookID <= 0 then
        raise Exception.Create('Invalid BookID');

    Comment.CreatedAt := Now;
    Comment.IsEdited := False;
    Comment.IsBlocked := False;
    Comment.IsSpoiled := False;
    Comment.LikeCount := 0;
    Comment.DisLikeCount := 0;
    Comment.ReportCount := 0;

    Comment.Insert;
End;
//______________________________________________________________________________
Procedure TCommentService.UpdateComment(Comment: TComment);
Var
    OldComment: TComment;
Begin
    OldComment := GetCommentByID(Comment.CommentID);
    If not Assigned(OldComment) then
        raise Exception.Create('Comment not found');

    Try
        If not Comment.Text.IsNull then
        begin
            If Comment.Text.Value.Trim = '' then
                raise Exception.Create('Comment text cannot be empty');
            OldComment.Text := Comment.Text;
            OldComment.IsEdited := True;
        End;

        If not Comment.IsSpoiled.IsNull then
            OldComment.IsSpoiled := Comment.IsSpoiled;

        OldComment.Update;
    Finally
        OldComment.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentService.DeleteComment(CommentID: Int64);
Var
    Comment: TComment;
Begin
    Comment := GetCommentByID(CommentID);
    If not Assigned(Comment) then
        raise Exception.Create('Comment not found');

    Try
        TMVCActiveRecord.DeleteRQL(TComment, 'CommentRefID=' + CommentID.ToString);
        Comment.Delete;
    Finally
        Comment.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentService.BlockComment(CommentID: Int64);
Var
    Comment: TComment;
Begin
    Comment := GetCommentByID(CommentID);
    If not Assigned(Comment) then
        raise Exception.Create('Comment not found');

    Try
        Comment.IsBlocked := True;
        Comment.Update;
    Finally
        Comment.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentService.ReportComment(CommentID: Int64; ReportID: Int64);
Var
    Comment: TComment;
Begin
    Comment := GetCommentByID(CommentID);
    If not Assigned(Comment) then
        raise Exception.Create('Comment not found');

    Try
        If Comment.ReportCount.IsNull then
            Comment.ReportCount := 1
        else
            Comment.ReportCount := Comment.ReportCount.Value + 1;

        Comment.ReportID := ReportID;
        Comment.Update;
    Finally
        Comment.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentService.LikeComment(CommentID: Int64);
Var
    Comment: TComment;
Begin
    Comment := GetCommentByID(CommentID);
    If not Assigned(Comment) then
        raise Exception.Create('Comment not found');

    Try
        If Comment.LikeCount.IsNull then
            Comment.LikeCount := 1
        else
            Comment.LikeCount := Comment.LikeCount.Value + 1;

        Comment.Update;
    Finally
        Comment.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentService.DislikeComment(CommentID: Int64);
Var
    Comment: TComment;
Begin
    Comment := GetCommentByID(CommentID);
    If not Assigned(Comment) then
        raise Exception.Create('Comment not found');

    Try
        If Comment.DisLikeCount.IsNull then
            Comment.DisLikeCount := 1
        else
            Comment.DisLikeCount := Comment.DisLikeCount.Value + 1;

        Comment.Update;
    Finally
        Comment.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentService.MarkAsSpoiler(CommentID: Int64);
Var
    Comment: TComment;
Begin
    Comment := GetCommentByID(CommentID);
    If not Assigned(Comment) then
        raise Exception.Create('Comment not found');

    Try
        Comment.IsSpoiled := True;
        Comment.Update;
    Finally
        Comment.Free;
    End;
End;
//______________________________________________________________________________

End.
