﻿Unit Controller.Book.Rate;

Interface

Uses
    System.JSON,
    System.Variants,
    System.Generics.Collections,
    MVCFramework,
    MVCFramework.Commons,
    MVCFramework.ActiveRecord,
    Model.Book.Rate,
    Service.Book.Rate,
    WebModule.Main;

Type
    [MVCPath(BASE_API_V1 + '/rate')]
    TRateController = class(TMVCController)
    Private
        FRateService: IRateService;

    Public
        Constructor Create; override;
        Destructor Destroy; override;

        [MVCPath('/book/($bookID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetBookRates(Const bookID: Int64);

        [MVCPath('/user/($userID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetUserRates(Const userID: Int64);

        [MVCPath('/average/($bookID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetAverageRating(Const bookID: Int64);

        [MVCPath('')]
        [MVCHTTPMethod([httpPOST])]
        Procedure AddOrUpdateRate;

        [MVCPath('/user/($userID)/book/($bookID)')]
        [MVCHTTPMethod([httpDELETE])]
        Procedure DeleteRate(Const userID, bookID: Int64);
    End;

Implementation

{ TRateController }

//______________________________________________________________________________
Constructor TRateController.Create;
Begin
    Inherited;
    FRateService := TRateService.Create;
End;
//______________________________________________________________________________
Destructor TRateController.Destroy;
Begin
    FRateService := nil;
    Inherited;
End;
//______________________________________________________________________________
Procedure TRateController.GetBookRates(Const bookID: Int64);
Var
    Rates: TObjectList<TRate>;
Begin
    Rates := FRateService.GetBookRates(bookID);
    Try
        If Rates.Count > 0 Then
            Render(Rates)
        Else
            Render(HTTP_STATUS.NoContent);
    Finally
        Rates.Free;
    End;
End;
//______________________________________________________________________________
Procedure TRateController.GetUserRates(Const userID: Int64);
Var
    Rates: TObjectList<TRate>;
Begin
    Rates := FRateService.GetUserRates(userID);
    Try
        If Rates.Count > 0 Then
            Render(Rates)
        Else
            Render(HTTP_STATUS.NoContent);
    Finally
        Rates.Free;
    End;
End;
//______________________________________________________________________________
Procedure TRateController.GetAverageRating(Const bookID: Int64);
Var
    AvgRating: Double;
    Response: TJSONObject;
Begin
    AvgRating := FRateService.GetAverageRating(bookID);
    Response := TJSONObject.Create;
    Try
        Response.AddPair('bookID', TJSONNumber.Create(bookID));
        Response.AddPair('averageRating', TJSONNumber.Create(AvgRating));
        Render(Response);
    Finally
        Response.Free;
    End;
End;
//______________________________________________________________________________
Procedure TRateController.AddOrUpdateRate;
Var
    Rate: TRate;
Begin
    Rate := Context.Request.BodyAs<TRate>;
    Try
        FRateService.AddOrUpdateRate(Rate.UserID, Rate.BookID, Rate.Rate);
        Render(HTTP_STATUS.OK, 'Rating updated successfully');
    Finally
        Rate.Free;
    End;
End;
//______________________________________________________________________________
Procedure TRateController.DeleteRate(Const userID, bookID: Int64);
Begin
    FRateService.DeleteRate(userID, bookID);
    Render(HTTP_STATUS.OK, 'Rating deleted successfully');
End;
//______________________________________________________________________________

End.
