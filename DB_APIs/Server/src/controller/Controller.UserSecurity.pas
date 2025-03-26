﻿Unit Controller.UserSecurity;

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
    Model.User.Security, Service.UserSecurity, WebModule.Main;

Type
    [MVCPath(BASE_API_V1 + '/userSecurity')]
    TUserSecurityController = class(TMVCController)
    Private
        FUserSecurityService: IUserSecurityService;

    Public
        Constructor Create; override;
        Destructor Destroy; override;

        [MVCPath('')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetUserSecurityByUserID(
          [MVCFromQueryString('userID', '')] Const userID: Int64);

        [MVCPath('')]
        [MVCHTTPMethod([httpPUT])]
        Procedure UpdateUserSecurity;

        [MVCPath('')]
        [MVCHTTPMethod([httpPOST])]
        Procedure CreateUserSecurity;
End;

Implementation

{ TUserSecurityController }

//______________________________________________________________________________
Constructor TUserSecurityController.Create;
Begin
    inherited;
    FUserSecurityService := TUserSecurityService.Create;
End;
//______________________________________________________________________________
destructor TUserSecurityController.Destroy;
Begin
    FUserSecurityService := NIL;
    inherited;
End;
//______________________________________________________________________________
Procedure TUserSecurityController.GetUserSecurityByUserID(const userID: Int64);
Var
    UserSecurity: TUser_Security;
Begin
    Try
        UserSecurity := FUserSecurityService.GetUserSecurityByUserID(userID);
        If Assigned(UserSecurity) then
          Render(UserSecurity)
        Else
          Render(HTTP_STATUS.NotFound, 'User_Security_Not_Found');
    Except
        Render(HTTP_STATUS.InternalServerError, 'Error_Getting_User_Security');
    End;
End;
//______________________________________________________________________________
Procedure TUserSecurityController.UpdateUserSecurity;
Var
    UserSecurity: TUser_Security;
Begin
    Try
        UserSecurity := Context.Request.BodyAs<TUser_Security>;
        FUserSecurityService.UpdateUserSecurity(UserSecurity);
        Render(HTTP_STATUS.OK, 'User_Security_Updated');
    Except
        Render(HTTP_STATUS.InternalServerError, 'Error_Updating_User_Security');
    End;
End;
//______________________________________________________________________________
Procedure TUserSecurityController.CreateUserSecurity;
Var
    UserSecurity: TUser_Security;
Begin
    Try
        UserSecurity := Context.Request.BodyAs<TUser_Security>;
        FUserSecurityService.CreateUserSecurity(UserSecurity);
        Render(HTTP_STATUS.Created, 'User_Security_Created');
    Except
        Render(HTTP_STATUS.InternalServerError, 'Error_Creating_User_Security');
    End;
End;
//______________________________________________________________________________

end.

