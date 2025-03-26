﻿Unit Service.User;

Interface

Uses
    System.Generics.Collections,
    System.SysUtils,
    MVCFramework.ActiveRecord,
    Model.User;

Type
    IUserService = Interface
        ['{8A1E86C2-EC7F-470D-B9AE-1E87C6E5A621}']
        Function GetUserByID(Const UserID: Int64): TUser;
        Function GetAllUsers: TObjectList<TUser>;
        Procedure AddUser(Const AUser: TUser);
        Procedure UpdateUser(Const AUser: TUser);
    End;

    TUserService = Class(TInterfacedObject, IUserService)
    Public
        Function GetUserByID(Const UserID: Int64): TUser;
        Function GetAllUsers: TObjectList<TUser>;
        Procedure AddUser(Const AUser: TUser);
        Procedure UpdateUser(Const AUser: TUser);
    End;

Implementation

{ TUserService }

//______________________________________________________________________________
Function TUserService.GetUserByID(Const UserID: Int64): TUser;
Begin
    Try
        Result := TMVCActiveRecord.GetByPK<TUser>(UserID);
    Except
        Result := NIL;
    End;
End;
//______________________________________________________________________________
Function TUserService.GetAllUsers: TObjectList<TUser>;
Begin
    Try
        Result := TMVCActiveRecord.All<TUser>;
    Except
        Result := NIL;
    End;
End;
//______________________________________________________________________________
Procedure TUserService.AddUser(Const AUser: TUser);
Begin
    AUser.Insert;
End;
//______________________________________________________________________________
Procedure TUserService.UpdateUser(Const AUser: TUser);
Var
    OldUser: TUser;
Begin
    OldUser := TMVCActiveRecord.GetByPK<TUser>(AUser.UserID);
    Try
        If Not Assigned(OldUser) Then
            Raise Exception.Create('User Not Found');

        // فقط فیلدهایی که مقدار جدید دارند، مقداردهی شوند:
        If AUser.UserName <> '' Then OldUser.UserName := AUser.UserName;
        If AUser.FirstName <> '' Then OldUser.FirstName := AUser.FirstName;
        If Not AUser.LastName.IsNull Then OldUser.LastName := AUser.LastName;
        If Not AUser.PhoneNumber.IsNull Then OldUser.PhoneNumber := AUser.PhoneNumber;
        If Not AUser.Email.IsNull Then OldUser.Email := AUser.Email;
        If Not AUser.Bio.IsNull Then OldUser.Bio := AUser.Bio;
        If Not AUser.Gender.IsNull Then OldUser.Gender := AUser.Gender;
        If AUser.DateOfBirth <> 0 Then OldUser.DateOfBirth := AUser.DateOfBirth;
        If Not AUser.Website.IsNull Then OldUser.Website := AUser.Website;
        If Not AUser.UserTypeID.IsNull Then OldUser.UserTypeID := AUser.UserTypeID;

        // ذخیره تغییرات
        OldUser.Update;
    Finally
        OldUser.Free;
    End;
End;
//______________________________________________________________________________

End.

