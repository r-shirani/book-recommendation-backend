﻿Unit Service.UserSecurity;

Interface

Uses
    System.SysUtils, System.Generics.Collections,
    MVCFramework.ActiveRecord,
    Model.User.Security;

Type
    IUserSecurityService = Interface
        Function GetUserSecurityByUserID(const UserID: Int64): TUser_Security;
        Procedure UpdateUserSecurity(const AUserSecurity: TUser_Security);
        Procedure CreateUserSecurity(const AUserSecurity: TUser_Security);
    End;

    TUserSecurityService = Class(TInterfacedObject, IUserSecurityService)
    Public
        function GetUserSecurityByUserID(const UserID: Int64): TUser_Security;
        procedure UpdateUserSecurity(const AUserSecurity: TUser_Security);
        procedure CreateUserSecurity(const AUserSecurity: TUser_Security);
End;

Implementation

{ TUserSecurityService }

//______________________________________________________________________________
Function TUserSecurityService.GetUserSecurityByUserID(const UserID: Int64): TUser_Security;
Begin
    Result := TMVCActiveRecord.GetByPK<TUser_Security>(UserID);
End;
//______________________________________________________________________________
Procedure TUserSecurityService.UpdateUserSecurity(const AUserSecurity: TUser_Security);
Var
    OldSecurity: TUser_Security;
Begin
    OldSecurity := GetUserSecurityByUserID(AUserSecurity.UserID);
    Try
        If not Assigned(OldSecurity) then
          raise Exception.Create('User Security Not Found');

        If not AUserSecurity.PassHint.IsNull then
          OldSecurity.PassHint := AUserSecurity.PassHint;

        If AUserSecurity.LastLogin <> 0 then
          OldSecurity.LastLogin := AUserSecurity.LastLogin;

        If AUserSecurity.Status <> 0 then
          OldSecurity.Status := AUserSecurity.Status;

        If not AUserSecurity.LockOutEnd.IsNull then
          OldSecurity.LockOutEnd := AUserSecurity.LockOutEnd;

        OldSecurity.IsEmailVerified := AUserSecurity.IsEmailVerified;
        OldSecurity.IsPhoneVerified := AUserSecurity.IsPhoneVerified;

        If AUserSecurity.FailedLoginAttempts <> 0 then
          OldSecurity.FailedLoginAttempts := AUserSecurity.FailedLoginAttempts;

        If not AUserSecurity.ClientEmailID.IsNull then
          OldSecurity.ClientEmailID := AUserSecurity.ClientEmailID;

        If AUserSecurity.PasswordHash <> '' then
          OldSecurity.PasswordHash := AUserSecurity.PasswordHash;

        If not AUserSecurity.Salt.IsNull then
          OldSecurity.Salt := AUserSecurity.Salt;

        If not AUserSecurity.VerificationCode.IsNull then
          OldSecurity.VerificationCode := AUserSecurity.VerificationCode;

        OldSecurity.Update;
    Finally
        OldSecurity.Free;
    End;
End;
//______________________________________________________________________________
Procedure TUserSecurityService.CreateUserSecurity(const AUserSecurity: TUser_Security);
Begin
    AUserSecurity.Insert;
End;
//______________________________________________________________________________

End.

