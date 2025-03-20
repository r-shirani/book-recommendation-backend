﻿Unit Controller.User;

Interface

Uses
    System.JSON,
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
          Const [MVCFromQueryString('userID', '')] userID: String);

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
          Const [MVCFromQueryString('clientEmailID', '')] CEmailID: String
        );


        [MVCPath('/EmailVerification')]
        [MVCHTTPMethods([httpPut])]
        Procedure EmailVerification(
          Const [MVCFromQueryString('userID', '0')] userID: String;
          Const [MVCFromQueryString('IsEmailVerify', '0')] IsEmailVerify: Boolean
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
  UDMMain, Model.User.Security;

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
Procedure TUserController.EmailVerification(const userID: String; const IsEmailVerify: Boolean);
Var
    FDQuery: TFDQuery;
    Response: System.JSON.TJSONObject;
Begin
    FDQuery := TFDQuery.Create(nil);
    Try
        FDQuery.Connection := TDMMain.GetConnection;
        FDQuery.SQL.Text := 'UPDATE [User].[Security] SET IsEmailVerified = :IsEmailVerify ' +
                            'WHERE UserID = :UserID';
        FDQuery.ParamByName('IsEmailVerify').AsBoolean := IsEmailVerify;
        FDQuery.ParamByName('UserID').AsString := UserID;

        Try
            FDQuery.ExecSQL;

            // ارسال پیام موفقیت
            Response := System.JSON.TJSONObject.Create;
            Response.AddPair('Status', 'Success');
            Response.AddPair('Message', 'Email verification status updated successfully.');

            // استفاده از Add با شیء System.JSON.TJSONObject
            Render(Response);
        Except
            On E: Exception Do
            Begin
                // در صورت بروز خطا، ارسال پیام خطا
                Response := System.JSON.TJSONObject.Create;
                Response.AddPair('Status', 'Error');
                Response.AddPair('Message', 'Error updating email verification status: ' + E.Message);

                // استفاده از Add با شیء System.JSON.TJSONObject
                Render(Response);
            End;
        End;
    Finally
        FDQuery.Free;
    End;
End;
//______________________________________________________________________________
Procedure TUserController.GetUserByID(Const userID: String);
Var
    FDQuery: TFDQuery;
Begin
    FDQuery := TFDQuery.Create(nil);
    Try
        FDQuery.Connection := TDMMain.GetConnection;
        FDQuery.SQL.Text := 'SELECT * FROM [User].[vwAllFieldUser] WHERE UserID = :userID';
        FDQuery.ParamByName('userID').AsString := userID;
        FDQuery.Open;

        Render(FDQuery.AsJSONArray);
    Finally
        FDQuery.Free;
    End;
End;
//______________________________________________________________________________
Procedure TUserController.SignupNormalUser(Const Name, Password, Email, CEmailID: String);
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
