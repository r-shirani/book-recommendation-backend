﻿Unit Controller.User;

Interface

Uses
    MVCFramework,
    MVCFramework.Commons,
    MVCFramework.SQLGenerators.MSSQL,
    MVCFramework.ActiveRecord,
    MVCFramework.Nullables,
    FireDAC.Phys.MSSQL,
    System.Variants,
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
        Procedure GetUsers();

        [MVCPath('/getUser')]
        [MVCHTTPMethods([httpGET])]
        Procedure GetUserByID(
          Const [MVCFromQueryString('userID', '')] userID: Integer);

        [MVCPath('/login')]
        [MVCHTTPMethods([httpGET])]
        Procedure LoginUser(
          Const [MVCFromQueryString('userName', '')] userName: String;
          Const [MVCFromQueryString('email', '')] email: String
        );

        [MVCPath('/remove')]
        [MVCHTTPMethods([httpDELETE])]
        Procedure RemoveUser(
          Const [MVCFromQueryString('userID', '')] userID: String;
          Const [MVCFromQueryString('userName', '')] userName: String;
          Const [MVCFromQueryString('email', '')] email: String
        );

        [MVCPath('/signupNormalUser')]
        [MVCHTTPMethods([httpPost])]
        Procedure SignupNormalUser(
          Const [MVCFromQueryString('name', '')] Name: String;
          Const [MVCFromQueryString('password', '')] Password: String;
          Const [MVCFromQueryString('email', '')] email: String;
          Const [MVCFromQueryString('clientEmailID', '')] CEmailID: String;
          Const [MVCFromQueryString('VerificationCode', '')] VerifyCode: String
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
Procedure TUserController.GetUsers();
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
Procedure TUserController.GetUserByID(Const userID: Integer);
Begin
    Render(ObjectDict().Add('data', TMVCActiveRecord.GetByPK<Model.User.TUser>(userID)));
End;
//______________________________________________________________________________
Procedure TUserController.SignupNormalUser(Const Name, Password, Email, CEmailID,
  VerifyCode: String);
Var
    FDStoredProc: TFDStoredProc;
Begin
    If (Name.IsEmpty) OR (Password.IsEmpty) OR (Email.IsEmpty) then
    Begin
        Raise EMVCException.Create(400, 'Name, Password, Email must have value!');
        Exit;
    End;

    FDStoredProc := TFDStoredProc.Create(nil);
    Try
        FDStoredProc.Connection := TDMMain.GetConnection;
        FDStoredProc.StoredProcName := '[User].[spSignupUser]';
        FDStoredProc.Prepare;

        FDStoredProc.ParamByName('@name').AsString := Name;
        FDStoredProc.ParamByName('@pass').AsString := Password;
        FDStoredProc.ParamByName('@email').AsString := Email;

        If CEmailID.IsEmpty then
            FDStoredProc.ParamByName('@clientEmailID').Value := Null
        Else
            FDStoredProc.ParamByName('@clientEmailID').AsString := CEmailID;


        If VerifyCode.IsEmpty then
            FDStoredProc.ParamByName('@VerificationCode').Value := Null
        Else
            FDStoredProc.ParamByName('@VerificationCode').AsString := VerifyCode;

        Try           
            FDStoredProc.Open;
        Except
            Raise EMVCException.Create(400, 'Wrong Params');
            Exit;
        End;
        
        Render(FDStoredProc.AsJSONArray);
    Finally
        FDStoredProc.Free;
    End;
End;
//______________________________________________________________________________
Procedure TUserController.LoginUser(Const userName, email: String);
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
Procedure TUserController.RemoveUser(const userID, userName, email: String);
Var
    FDStoredProc: TFDStoredProc;
Begin
    FDStoredProc := TFDStoredProc.Create(nil);
    Try
        FDStoredProc.Connection := TDMMain.GetConnection;
        FDStoredProc.StoredProcName := '[User].spRemoveUser';
        FDStoredProc.Prepare;

        If userID.IsEmpty then FDStoredProc.ParamByName('@userID').Value := Null
        Else FDStoredProc.ParamByName('@userID').AsString := userID;

        If userName.IsEmpty then FDStoredProc.ParamByName('@userName').Value := Null
        Else FDStoredProc.ParamByName('@userName').AsString := userName;

        If email.IsEmpty then FDStoredProc.ParamByName('@email').Value := Null
        Else FDStoredProc.ParamByName('@email').AsString := email;

        Try
            FDStoredProc.Open;
        Except
            Raise EMVCException.Create(400, 'DB Error');
            Exit;
        End;

        Render(FDStoredProc.AsJSONArray);
    Finally
        FDStoredProc.Free;
    End;
End;
//______________________________________________________________________________

End.
