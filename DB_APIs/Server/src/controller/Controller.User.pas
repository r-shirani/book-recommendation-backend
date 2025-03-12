Unit Controller.User;

Interface

Uses
    MVCFramework,
    MVCFramework.Commons,
    MVCFramework.SQLGenerators.MSSQL,
    MVCFramework.ActiveRecord,
    MVCFramework.Nullables,
    FireDAC.Phys.MSSQL,
    System.Generics.Collections,
    Model.User;

Const
  BASE_API_V1 = '/api/v1';

Type
    [MVCPath(BASE_API_V1 + '/user')]
    TUserController = class(TMVCController)
    Public
        [MVCPath]
        [MVCHTTPMethods([httpGET])]
        Procedure GetUsers(const [MVCFromQueryString('rql','')] RQL: String);

        [MVCPath('/getUser/($ID)')]
        [MVCHTTPMethods([httpGET])]
        Procedure GetUsersByID(const ID: Integer);

        [MVCPath('/login')]
        [MVCHTTPMethods([httpGET])]
        Procedure GetUsersBInLogin(
          Const [MVCFromQueryString('userName', 'U')] userName: String;
          Const [MVCFromQueryString('email', 'E')] Email: String
        );

        [MVCPath('/signupNormalUser')]
        [MVCHTTPMethods([httpPost])]
        Procedure PutSignupNormalUser(
          Const [MVCFromQueryString('name', 'D')] Name: String;
          Const [MVCFromQueryString('password', 'P')] Password: String;
          Const [MVCFromQueryString('email', 'E')] Email: String;
          Const [MVCFromQueryString('clientEmailID', 'C')] CEmailID: String
        );
End;

Implementation

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  MVCFramework.Logger,
  MVCFramework.Serializer.Commons,
  MVCFramework.DataSet.Utils,
  JsonDataObjects,
  IniFiles,
  UDMMain;

//______________________________________________________________________________
Procedure TUserController.GetUsers(const RQL: string);
Var
    FDQuery: TFDQuery;
Begin
    FDQuery := TFDQuery.Create(nil);
    Try
        FDQuery.Connection := TDMMain.GetConnection;
        FDQuery.SQL.Text := 'SELECT * FROM [User].[vwAllFieldUser]';
        FDQuery.Open;

        Render(FDQuery.AsJSONArray);
    Finally
        FDQuery.Free;
    End;
End;
//______________________________________________________________________________
Procedure TUserController.GetUsersByID(const ID: Integer);
Begin
    Render(ObjectDict().Add('data', TMVCActiveRecord.GetByPK<Model.User.TUser>(ID)));
End;
//______________________________________________________________________________
Procedure TUserController.PutSignupNormalUser(const Name, Password, Email, CEmailID: String);
Var
    FDQuery: TFDQuery;
Begin
    FDQuery := TFDQuery.Create(nil);
    Try
        FDQuery.Connection := TDMMain.GetConnection;
        FDQuery.SQL.Text := 'EXEC [User].[spSignupUser] :name, :pass, :email, :clientEmailID';
        FDQuery.ParamByName('name').AsString := Name;
        FDQuery.ParamByName('pass').AsString := Password;
        FDQuery.ParamByName('email').AsString := Email;
        FDQuery.ParamByName('clientEmailID').AsString := CEmailID;
        FDQuery.Open;

        Render(FDQuery.AsJSONArray);
    Finally
        FDQuery.Free;
    End;
End;
//______________________________________________________________________________
Procedure TUserController.GetUsersBInLogin(Const userName, email: String);
Var
    FDQuery: TFDQuery;
Begin
    FDQuery := TFDQuery.Create(nil);
    Try
        FDQuery.Connection := TDMMain.GetConnection;
        FDQuery.SQL.Text := 'SELECT * FROM [User].[funLogin](:userName, :email)';
        FDQuery.ParamByName('userName').AsString := userName;
        FDQuery.ParamByName('email').AsString := email;
        FDQuery.Open;

        Render(FDQuery.AsJSONArray);
    Finally
        FDQuery.Free;
    End;
End;
//______________________________________________________________________________

End.
