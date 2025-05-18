Unit Controller.User;

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
    Model.User,
    Model.User.Security,
    Service.User,
    Service.UserSecurity,
    WebModule.Main;

Type
    [MVCPath(BASE_API_V1 + '/user')]
    TUserController = class(TMVCController)
    Private
        FUserSecurityService: IUserSecurityService;
        FUserService: IUserService;

    Public
        Constructor Create(); override;
        Destructor Destroy(); override;

        [MVCPath('')]
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
          Const [MVCFromQueryString('clientEmailID', '')] CEmailID: String;
          Const [MVCFromQueryString('VerificationCode', '')] VerifyCode: String
        );

        [MVCPath('/EmailVerification')]
        [MVCHTTPMethods([httpPut])]
        Procedure EmailVerification(
          Const [MVCFromQueryString('userID', '0')] userID: String;
          Const [MVCFromQueryString('IsEmailVerify', '0')] IsEmailVerify: Boolean
        );

        [MVCPath('/getUserAllFields')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetUserAllFields([MVCFromQueryString('userID', 0)] Const userID: Int64);

        [MVCPath('/getAllUser')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetAllUser();

        [MVCPath('')]
        [MVCHTTPMethod([httpPOST])]
        Procedure AddUser;

        [MVCPath('')]
        [MVCHTTPMethod([httpPUT])]
        Procedure UpdateUser;

        [MVCPath('')]
        [MVCHTTPMethod([httpDelete])]
        Procedure DeleteUser([MVCFromQueryString('userID', 0)] Const userID: Int64);
End;

Implementation

Uses
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
Constructor TUserController.Create();
Begin
    Inherited;
    FUserSecurityService := TUserSecurityService.Create();
    FUserService := TUserService.Create();
End;
//______________________________________________________________________________
Procedure TUserController.GetUserAllFields(Const userID: Int64);
Var
    user: Model.TUser;
Begin
    user := FUserService.GetUserByID(userID);
    If Assigned(user) then
        Render(user)
    Else
        Render(HTTP_STATUS.NotFound, 'User_Not_Found');
End;
//______________________________________________________________________________
Procedure TUserController.GetAllUser;
Var
    userList: TObjectList<Model.TUser>;
Begin
    userList := FUserService.GetAllUsers;
    If (userList.Count > 0) Then
        Render(userList)
    Else
        Render(HTTP_STATUS.NoContent, 'List_Is_Empty');

End;
//______________________________________________________________________________
Procedure TUserController.AddUser;
Var
    NewUser: TUser;
Begin
    NewUser := Context.Request.BodyAs<TUser>;
    Try
        Try
            FUserService.AddUser(NewUser);
            Render(HTTP_STATUS.Created, 'User_Added');
        Except
            On E: Exception do
            Begin
                Render(HTTP_STATUS.BadRequest, E.Message);
            End;
        End;
    Finally
        NewUser.Free;
    End;
End;
//______________________________________________________________________________
Procedure TUserController.UpdateUser();
Var
    UpdatedUser: TUser;
Begin
    UpdatedUser := Context.Request.BodyAs<TUser>;
    Try
        Try
            UpdatedUser := Context.Request.BodyAs<TUser>;
            FUserService.UpdateUser(UpdatedUser);
            Render(HTTP_STATUS.Ok, 'User_Updated');
        Except
            On E: Exception do
            Begin
                Render(HTTP_STATUS.BadRequest, E.Message);
            End;
        End;
    Finally
        UpdatedUser.Free;
    End;
End;
//______________________________________________________________________________
Procedure TUserController.DeleteUser(Const userID: Int64);
Var
    User: Model.TUser;
    UserSecurity: TUser_Security;
Begin
    Try
        User := FUserService.GetUserByID(userID);
        If (Not Assigned(User)) then
        Begin
            Render(HTTP_STATUS.NotFound, 'User_Not_Found');
            Exit;
        End;

        UserSecurity := FUserSecurityService.GetUserSecurityByUserID(userID);
        If Assigned(UserSecurity) then
          UserSecurity.Delete;

        User.Delete;

        Render(HTTP_STATUS.OK, 'User_Deleted');
    Except
        Render(HTTP_STATUS.InternalServerError, 'Error_Deleting_User');
    End;
end;
//______________________________________________________________________________
Destructor TUserController.Destroy();
Begin
    FUserService := NIL;
    Inherited;
End;
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
    If (userID = '0') then
    Begin
        Response := System.JSON.TJSONObject.Create;
        Response.AddPair('Status', 'Failed');
        Response.AddPair('Message', 'Dont find userID');

        Render(Response);
        Exit;
    End;

    FDQuery := TFDQuery.Create(nil);
    Try
        FDQuery.Connection := TDMMain.GetConnection;
        FDQuery.SQL.Text := 'UPDATE [User].[Security] SET IsEmailVerified = :IsEmailVerify ' +
                            'WHERE UserID = :UserID';
        FDQuery.ParamByName('IsEmailVerify').AsBoolean := IsEmailVerify;
        FDQuery.ParamByName('UserID').AsString := UserID;

        Try
            FDQuery.ExecSQL;

            Response := System.JSON.TJSONObject.Create;
            Response.AddPair('Status', 'Success');
            Response.AddPair('Message', 'Email verification status updated successfully.');

            Render(Response);
        Except
            On E: Exception Do
            Begin
                Response := System.JSON.TJSONObject.Create;
                Response.AddPair('Status', 'Failed');
                Response.AddPair('Message', 'Error updating email verification status: ' + E.Message);

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
            On E: Exception Do
            Begin
                Render(HTTP_STATUS.OK, E.Message );
                Exit;
            End;
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
