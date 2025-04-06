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
        [MVCTableField('userid', [foPrimaryKey])]
        FUserID: Int64;

        [MVCTableField('bookid', [foPrimaryKey])]
        FBookID: Int64;

        [MVCTableField('rate')]
        FRate: Byte;

    Public
        Property userid: Int64 read FUserID write FUserID;
        Property bookid: Int64 read FBookID write FBookID;
        Property rate: Byte read FRate write FRate;
End;

Implementation

End.
