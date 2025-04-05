﻿Unit Model.Book.Rate;

Interface
Uses
    MVCFramework.Serializer.Commons,
    MVCFramework.ActiveRecord,
    MVCFramework.Nullables;
Type
    [MVCNameCase(ncLowerCase)]
    [MVCTable('Book.Rate')]
    TRate = class(TMVCActiveRecord)
    Private
        [MVCTableField('UserID', [foPrimaryKey])]
        FUserID: Int64;

        [MVCTableField('BookID', [foPrimaryKey])]
        FBookID: Int64;

        [MVCTableField('Rate')]
        FRate: Byte;

    Public
        Property UserID: Int64 read FUserID write FUserID;
        Property BookID: Int64 read FBookID write FBookID;
        Property Rate: Byte read FRate write FRate;
End;

Implementation

End.
