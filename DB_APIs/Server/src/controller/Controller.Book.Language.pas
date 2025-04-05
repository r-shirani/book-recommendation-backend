﻿Unit Controller.Book.Language;

Interface

Uses
    System.JSON,
    System.Variants,
    System.Generics.Collections,
    MVCFramework,
    MVCFramework.Commons,
    MVCFramework.ActiveRecord,
    Model.Book.Language,
    Service.Book.Language,
    WebModule.Main;

Type
    [MVCPath(BASE_API_V1 + '/language')]
    TLanguageController = class(TMVCController)
    Private
        FLanguageService: ILanguageService;

    Public
        Constructor Create; override;
        Destructor Destroy; override;

        [MVCPath('')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetAllLanguages;

        [MVCPath('/($id)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetLanguageByID(Const id: Int64);

        [MVCPath('/iso/($isoCode)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetLanguageByISOCode(Const isoCode: String);

        [MVCPath('')]
        [MVCHTTPMethod([httpPOST])]
        Procedure AddLanguage;

        [MVCPath('')]
        [MVCHTTPMethod([httpPUT])]
        Procedure UpdateLanguage;

        [MVCPath('/($id)')]
        [MVCHTTPMethod([httpDELETE])]
        Procedure DeleteLanguage(Const id: Int64);
    End;

Implementation

{ TLanguageController }

//______________________________________________________________________________
Constructor TLanguageController.Create;
Begin
    Inherited;
    FLanguageService := TLanguageService.Create;
End;
//______________________________________________________________________________
Destructor TLanguageController.Destroy;
Begin
    FLanguageService := nil;
    Inherited;
End;
//______________________________________________________________________________
Procedure TLanguageController.GetAllLanguages;
Var
    Languages: TObjectList<TLanguage>;
Begin
    Languages := FLanguageService.GetAllLanguages;
    Try
        If Languages.Count > 0 Then
            Render(Languages)
        Else
            Render(HTTP_STATUS.NoContent);
    Finally
        Languages.Free;
    End;
End;
//______________________________________________________________________________
Procedure TLanguageController.GetLanguageByID(Const id: Int64);
Var
    Language: TLanguage;
Begin
    Language := FLanguageService.GetLanguageByID(id);
    If Assigned(Language) Then
        Render(Language)
    Else
        Render(HTTP_STATUS.NotFound);
    Language.Free;
End;
//______________________________________________________________________________
Procedure TLanguageController.GetLanguageByISOCode(Const isoCode: String);
Var
    Language: TLanguage;
Begin
    Language := FLanguageService.GetLanguageByISOCode(isoCode);
    If Assigned(Language) Then
        Render(Language)
    Else
        Render(HTTP_STATUS.NotFound);
    Language.Free;
End;
//______________________________________________________________________________
Procedure TLanguageController.AddLanguage;
Var
    Language: TLanguage;
Begin
    Language := Context.Request.BodyAs<TLanguage>;
    Try
        FLanguageService.AddLanguage(Language);
        Render(HTTP_STATUS.Created, 'Language added successfully');
    Finally
        Language.Free;
    End;
End;
//______________________________________________________________________________
Procedure TLanguageController.UpdateLanguage;
Var
    Language: TLanguage;
Begin
    Language := Context.Request.BodyAs<TLanguage>;
    Try
        FLanguageService.UpdateLanguage(Language);
        Render(HTTP_STATUS.OK, 'Language updated successfully');
    Finally
        Language.Free;
    End;
End;
//______________________________________________________________________________
Procedure TLanguageController.DeleteLanguage(Const id: Int64);
Begin
    FLanguageService.DeleteLanguage(id);
    Render(HTTP_STATUS.OK, 'Language deleted successfully');
End;
//______________________________________________________________________________

End.
