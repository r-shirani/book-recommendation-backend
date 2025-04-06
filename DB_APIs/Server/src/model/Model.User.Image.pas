﻿Unit Model.User.Image;

Interface

Uses
    MVCFramework.ActiveRecord,
    MVCFramework.Serializer.Commons,
    MVCFramework.Nullables,
    System.SysUtils;

type
    [MVCNameCase(ncLowerCase)]
    [MVCTable('[User].[UserProfileImage]')]
    TImage = class(TMVCActiveRecord)
    Private
        [MVCTableField('ImageGuid', [foPrimaryKey])]
        fImageGuid: TGUID;

        [MVCTableField('UserID')]
        fUserID: Int64;

        [MVCTableField('ImageUrl')]
        fImageUrl: NullableString;

        [MVCTableField('UploadDate')]
        fUploadDate: TDateTime;

        [MVCTableField('FileSizeKB')]
        fFileSizeKB: Integer;

        [MVCTableField('Width')]
        fWidth: Integer;

        [MVCTableField('Height')]
        fHeight: Integer;

        [MVCTableField('ContentType')]
        fContentType: NullableString;

        [MVCTableField('OriginalFileName')]
        fOriginalFileName: NullableString;

    Public
        property ImageGuid: TGUID read fImageGuid write fImageGuid;
        property UserID: Int64 read fUserID write fUserID;
        property ImageUrl: NullableString read fImageUrl write fImageUrl;
        property UploadDate: TDateTime read fUploadDate write fUploadDate;
        property FileSizeKB: Integer read fFileSizeKB write fFileSizeKB;
        property Width: Integer read fWidth write fWidth;
        property Height: Integer read fHeight write fHeight;
        property ContentType: NullableString read fContentType write fContentType;
        property OriginalFileName: NullableString read fOriginalFileName write fOriginalFileName;
End;

implementation

end.

