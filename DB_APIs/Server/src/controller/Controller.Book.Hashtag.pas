Unit Controller.Book.Hashtag;

Interface

Uses
    System.JSON,
    System.Variants,
    System.Generics.Collections,
    MVCFramework,
    MVCFramework.Commons,
    MVCFramework.ActiveRecord,
    Model.Book.Hashtag,
    Service.Book.Hashtag,
    WebModule.Main;

Type
    [MVCPath(BASE_API_V1 + '/hashtag')]
    THashtagController = class(TMVCController)
    Private
        FHashtagService: IHashtagService;

    Public
        Constructor Create; override;
        Destructor Destroy; override;

        [MVCPath('/collection/($collectionID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetHashtagsByCollection(Const collectionID: Int64);

        [MVCPath('/search')]
        [MVCHTTPMethod([httpGET])]
        Procedure SearchHashtags(Const [MVCFromQueryString('title', '')] title: String);

        [MVCPath('/popular')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetPopularHashtags;

        [MVCPath('')]
        [MVCHTTPMethod([httpPOST])]
        Procedure AddHashtag;

        [MVCPath('')]
        [MVCHTTPMethod([httpPUT])]
        Procedure UpdateHashtag;

        [MVCPath('/($id)')]
        [MVCHTTPMethod([httpDELETE])]
        Procedure DeleteHashtag(Const id: Int64);
    End;

Implementation

{ THashtagController }

//______________________________________________________________________________
Constructor THashtagController.Create;
Begin
    Inherited;
    FHashtagService := THashtagService.Create;
End;
//______________________________________________________________________________
Destructor THashtagController.Destroy;
Begin
    FHashtagService := nil;
    Inherited;
End;
//______________________________________________________________________________
Procedure THashtagController.GetHashtagsByCollection(Const collectionID: Int64);
Var
    Hashtags: TObjectList<THashtag>;
Begin
    Hashtags := FHashtagService.GetHashtagsByCollectionID(collectionID);
    If Assigned(Hashtags) Then
        Render(Hashtags)
    Else
        Render(HTTP_STATUS.NoContent);
End;
//______________________________________________________________________________
Procedure THashtagController.SearchHashtags(Const title: String);
Var
    Hashtags: TObjectList<THashtag>;
Begin
    Hashtags := FHashtagService.GetHashtagsByTitle(title);
    If Assigned(Hashtags) Then
        Render(Hashtags)
    Else
        Render(HTTP_STATUS.NoContent)
End;
//______________________________________________________________________________
Procedure THashtagController.GetPopularHashtags;
Var
    Hashtags: TObjectList<THashtag>;
Begin
    Hashtags := FHashtagService.GetPopularHashtags;
    If Assigned(Hashtags) Then
        Render(Hashtags)
    Else
        Render(HTTP_STATUS.NoContent);
End;
//______________________________________________________________________________
Procedure THashtagController.AddHashtag;
Var
    Hashtag: THashtag;
Begin
    Hashtag := Context.Request.BodyAs<THashtag>;
    Try
        FHashtagService.AddHashtag(Hashtag);
        Render(HTTP_STATUS.Created, 'Hashtag added successfully');
    Finally
        Hashtag.Free;
    End;
End;
//______________________________________________________________________________
Procedure THashtagController.UpdateHashtag;
Var
    Hashtag: THashtag;
Begin
    Hashtag := Context.Request.BodyAs<THashtag>;
    Try
        FHashtagService.UpdateHashtag(Hashtag);
        Render(HTTP_STATUS.OK, 'Hashtag updated successfully');
    Finally
        Hashtag.Free;
    End;
End;
//______________________________________________________________________________
Procedure THashtagController.DeleteHashtag(Const id: Int64);
Begin
    FHashtagService.DeleteHashtag(id);
    Render(HTTP_STATUS.OK, 'Hashtag deleted successfully');
End;
//______________________________________________________________________________

End.
