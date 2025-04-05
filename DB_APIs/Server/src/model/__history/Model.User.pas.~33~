Unit Model.User;

Interface

Uses
    MVCFramework.Serializer.Commons,
    MVCFramework.ActiveRecord,
    MVCFramework.Nullables;

Type
    [MVCNameCase(ncLowerCase)]
    [MVCTable('[User].[User]')]
    TUser = Class(TMVCActiveRecord)
    Private
        [MVCTableField('UserID', [foPrimaryKey])]
        fUserID: Int64;

        [MVCTableField('UserName')]
        fUserName: String;

        [MVCTableField('FirstName')]
        fFirstName: String;

        [MVCTableField('LastName')]
        fLastName: NullableString;

        [MVCTableField('PhoneNumber')]
        fPhoneNumber: NullableString;

        [MVCTableField('Email')]
        fEmail: NullableString;

        [MVCTableField('Bio')]
        fBio: NullableString;

        [MVCTableField('Gender')]
        fGender: NullableInt16;

        [MVCTableField('DateOfBrith')]
        fDateOfBirth: TDate;

        [MVCTableField('WebSite')]
        fWebsite: NullableString;

        [MVCTableField('UserTypeID')]
        fUserTypeID: NullableInt16;


    Public
        Property UserID: Int64 read fUserID write fUserID;
        Property UserName: String read fUserName write fUserName;
        Property FirstName: String read fFirstName write fFirstName;
        Property LastName: NullableString read fLastName write fLastName;
        Property PhoneNumber: NullableString read fPhoneNumber write fPhoneNumber;
        Property Email: NullableString read fEmail write fEmail;
        Property Bio: NullableString read fBio write fBio;
        Property Gender: NullableInt16 read fGender write fGender;
        Property DateOfBirth: TDate read fDateOfBirth write fDateOfBirth;
        Property Website: NullableString read fWebsite write fWebsite;
        Property UserTypeID: NullableInt16  read fUserTypeID write fUserTypeID;
End;

Implementation

End.

