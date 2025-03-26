﻿Unit Model.User.Security;

Interface

Uses
    MVCFramework.Serializer.Commons,
    MVCFramework.ActiveRecord,
    MVCFramework.Nullables,
    System.SysUtils;

Type
    [MVCNameCase(ncLowerCase)]
    [MVCTable('[User].[Security]')]
    TUser_Security = class(TMVCActiveRecord)
    Private
        [MVCTableField('UserID', [foPrimaryKey])]
        fUserID: Int64;

        [MVCTableField('PassHint')]
        fPassHint: NullableString;

        [MVCTableField('LastLogin')]
        fLastLogin: TDateTime;

        [MVCTableField('Status')]
        fStatus: Byte;

        [MVCTableField('LockOutEnd')]
        fLockOutEnd: NullableTDate;

        [MVCTableField('IsEmailVerified')]
        fIsEmailVerified: Boolean;

        [MVCTableField('IsPhoneVerified')]
        fIsPhoneVerified: Boolean;

        [MVCTableField('FailedLoginAttempts')]
        fFailedLoginAttempts: Byte;

        [MVCTableField('CreateDate')]
        fCreateDate: TDateTime;

        [MVCTableField('ClientEmailID')]
        fClientEmailID: NullableString;

        [MVCTableField('PasswordHash')]
        fPasswordHash: String;

        [MVCTableField('Salt')]
        fSalt: NullableString;

        [MVCTableField('VerificationCode')]
        fVerificationCode: NullableString;

    Public
        Property UserID: Int64 read fUserID write fUserID;
        Property PassHint: NullableString read fPassHint write fPassHint;
        Property LastLogin: TDateTime read fLastLogin write fLastLogin;
        Property Status: Byte read fStatus write fStatus;
        Property LockOutEnd: NullableTDate read fLockOutEnd write fLockOutEnd;
        Property IsEmailVerified: Boolean read fIsEmailVerified write fIsEmailVerified;
        Property IsPhoneVerified: Boolean read fIsPhoneVerified write fIsPhoneVerified;
        Property FailedLoginAttempts: Byte read fFailedLoginAttempts write fFailedLoginAttempts;
        Property CreateDate: TDateTime read fCreateDate write fCreateDate;
        Property ClientEmailID: NullableString read fClientEmailID write fClientEmailID;
        Property PasswordHash: String read fPasswordHash write fPasswordHash;
        Property Salt: NullableString read fSalt write fSalt;
        Property VerificationCode: NullableString read fVerificationCode write fVerificationCode;
End;

implementation

end.

