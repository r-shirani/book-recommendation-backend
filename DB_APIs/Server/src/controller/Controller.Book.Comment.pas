﻿Unit Controller.Book.Comment;

Interface

Uses
    System.JSON,
    System.Variants,
    System.Generics.Collections,
    MVCFramework,
    MVCFramework.Commons,
    MVCFramework.ActiveRecord,
    Model.Book.Comment,
    Service.Book.Comment,
    WebModule.Main;

Type
    [MVCPath(BASE_API_V1 + '/comment')]
    TCommentController = class(TMVCController)
    Private
        FCommentService: ICommentService;

    Public
        Constructor Create; override;
        Destructor Destroy; override;

        [MVCPath('/book/($bookID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetCommentsByBook(Const bookID: Int64);

        [MVCPath('/user/($userID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetCommentsByUser(Const userID: Int64);

        [MVCPath('/$id/replies')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetReplies(Const id: Int64);

        [MVCPath('/popular/($bookID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetPopularComments(Const bookID: Int64);

        [MVCPath('')]
        [MVCHTTPMethod([httpPOST])]
        Procedure AddComment;

        [MVCPath('')]
        [MVCHTTPMethod([httpPUT])]
        Procedure UpdateComment;

        [MVCPath('/($id)')]
        [MVCHTTPMethod([httpDELETE])]
        Procedure DeleteComment(Const id: Int64);

        [MVCPath('/($id)/block')]
        [MVCHTTPMethod([httpPUT])]
        Procedure BlockComment(Const id: Int64);

        [MVCPath('/($id)/report')]
        [MVCHTTPMethod([httpPUT])]
        Procedure ReportComment(Const [MVCFromQueryString('reportID', 0)] reportID: Int64);

        [MVCPath('/($id)/like')]
        [MVCHTTPMethod([httpPUT])]
        Procedure LikeComment(Const id: Int64);

        [MVCPath('/($id)/dislike')]
        [MVCHTTPMethod([httpPUT])]
        Procedure DislikeComment(Const id: Int64);

        [MVCPath('/($id)/spoiler')]
        [MVCHTTPMethod([httpPUT])]
        Procedure MarkAsSpoiler(Const id: Int64);
    End;

Implementation

{ TCommentController }

//______________________________________________________________________________
Constructor TCommentController.Create;
Begin
    Inherited;
    FCommentService := TCommentService.Create;
End;
//______________________________________________________________________________
Destructor TCommentController.Destroy;
Begin
    FCommentService := nil;
    Inherited;
End;
//______________________________________________________________________________
Procedure TCommentController.GetCommentsByBook(Const bookID: Int64);
Var
    Comments: TObjectList<TComment>;
Begin
    Comments := FCommentService.GetCommentsByBook(bookID);
    Try
        If Comments.Count > 0 Then
            Render(Comments)
        Else
            Render(HTTP_STATUS.NoContent);
    Finally
        Comments.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentController.GetCommentsByUser(Const userID: Int64);
Var
    Comments: TObjectList<TComment>;
Begin
    Comments := FCommentService.GetCommentsByUser(userID);
    Try
        If Comments.Count > 0 Then
            Render(Comments)
        Else
            Render(HTTP_STATUS.NoContent);
    Finally
        Comments.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentController.GetReplies(Const id: Int64);
Var
    Replies: TObjectList<TComment>;
Begin
    Replies := FCommentService.GetReplies(id);
    Try
        If Replies.Count > 0 Then
            Render(Replies)
        Else
            Render(HTTP_STATUS.NoContent);
    Finally
        Replies.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentController.GetPopularComments(Const bookID: Int64);
Var
    Comments: TObjectList<TComment>;
Begin
    Comments := FCommentService.GetPopularComments(bookID);
    Try
        If Comments.Count > 0 Then
            Render(Comments)
        Else
            Render(HTTP_STATUS.NoContent);
    Finally
        Comments.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentController.AddComment;
Var
    Comment: TComment;
Begin
    Comment := Context.Request.BodyAs<TComment>;
    Try
        FCommentService.AddComment(Comment);
        Render(HTTP_STATUS.Created, 'Comment added successfully');
    Finally
        Comment.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentController.UpdateComment;
Var
    Comment: TComment;
Begin
    Comment := Context.Request.BodyAs<TComment>;
    Try
        FCommentService.UpdateComment(Comment);
        Render(HTTP_STATUS.OK, 'Comment updated successfully');
    Finally
        Comment.Free;
    End;
End;
//______________________________________________________________________________
Procedure TCommentController.DeleteComment(Const id: Int64);
Begin
    FCommentService.DeleteComment(id);
    Render(HTTP_STATUS.OK, 'Comment deleted successfully');
End;
//______________________________________________________________________________
Procedure TCommentController.BlockComment(Const id: Int64);
Begin
    FCommentService.BlockComment(id);
    Render(HTTP_STATUS.OK, 'Comment blocked successfully');
End;
//______________________________________________________________________________
Procedure TCommentController.ReportComment(Const reportID: Int64);
Begin
    FCommentService.ReportComment(Context.Request.ParamsAsInteger['id'], reportID);
    Render(HTTP_STATUS.OK, 'Comment reported successfully');
End;
//______________________________________________________________________________
Procedure TCommentController.LikeComment(Const id: Int64);
Begin
    FCommentService.LikeComment(id);
    Render(HTTP_STATUS.OK, 'Comment liked successfully');
End;
//______________________________________________________________________________
Procedure TCommentController.DislikeComment(Const id: Int64);
Begin
    FCommentService.DislikeComment(id);
    Render(HTTP_STATUS.OK, 'Comment disliked successfully');
End;
//______________________________________________________________________________
Procedure TCommentController.MarkAsSpoiler(Const id: Int64);
Begin
    FCommentService.MarkAsSpoiler(id);
    Render(HTTP_STATUS.OK, 'Comment marked as spoiler');
End;
//______________________________________________________________________________

End.
