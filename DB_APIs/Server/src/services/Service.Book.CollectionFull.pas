Unit Service.Book.CollectionFull;

Interface

Uses
    System.SysUtils,
    System.Generics.Collections,
    MVCFramework.ActiveRecord,
    Model.Book.Collection,
    Model.Book.CollectionDetail;

Type
    ICollectionFullService = interface
    ['{A1B2C3D4-E5F6-7890-1234-56789ABCDEF0}']
        Function GetAllUserCollection(UserID: Int64): TObjectList<TCollection>;
        Function  GetFullByID(const CollectionID: Int64): TCollectionFull;
        Procedure AddFull(const ACollection: TCollection; const Details: TObjectList<TCollectionDetail>);
        Procedure UpdateFull(const ACollection: TCollection; const Details: TObjectList<TCollectionDetail>);
        Procedure DeleteFull(const CollectionID: Int64);
    End;

    TCollectionFullService = class(TInterfacedObject, ICollectionFullService)
    Public
        Function GetAllUserCollection(UserID: Int64): TObjectList<TCollection>;
        Function  GetFullByID(const CollectionID: Int64): TCollectionFull;
        Procedure AddFull(const ACollection: TCollection; const Details: TObjectList<TCollectionDetail>);
        Procedure UpdateFull(const ACollection: TCollection; const Details: TObjectList<TCollectionDetail>);
        Procedure DeleteFull(const CollectionID: Int64);
    End;

Implementation

{ TCollectionFullService }

//______________________________________________________________________________
Function TCollectionFullService.GetAllUserCollection(UserID: Int64): TObjectList<TCollection>;
Begin
    Result := TMVCActiveRecord.Where<TCollection>('UserID = ?', [UserID]);
End;
//______________________________________________________________________________
Function TCollectionFullService.GetFullByID(const CollectionID: Int64): TCollectionFull;
Begin
    Try
        Result := TMVCActiveRecord.GetByPK<TCollectionFull>(CollectionID);
        Result := TMVCActiveRecord.GetOneByWhere<TCollectionFull>('CollectionID = ?', [CollectionID]);
    Except
        Result := Nil;
    End;
End;
//______________________________________________________________________________
Procedure TCollectionFullService.AddFull(const ACollection: TCollection; const Details: TObjectList<TCollectionDetail>);
Var
    NewCollectionID: Int64;
    Detail: TCollectionDetail;
Begin
    ACollection.Insert;
    NewCollectionID := ACollection.CollectionID;

    For Detail in Details do
    Begin
      Detail.CollectionID := NewCollectionID;
      Detail.Insert;
    End;
End;
//______________________________________________________________________________
Procedure TCollectionFullService.UpdateFull(const ACollection: TCollection; const Details: TObjectList<TCollectionDetail>);
Var
    Existing, Item: TCollectionDetail;
    ExistingList: TObjectList<TCollectionDetail>;
Begin
    ACollection.Update;

    Existing.DeleteRQL<TCollectionDetail>('CollectionID = ' + ACollection.CollectionID.ToString);

    For Item in Details do
    Begin
        Item.CollectionID := ACollection.CollectionID;
        Item.Insert;
    End;
End;
//______________________________________________________________________________
Procedure TCollectionFullService.DeleteFull(const CollectionID: Int64);
var
  DetailList: TObjectList<TCollectionDetail>;
  Col: TCollection;
Begin
  // حذف همه جزئیات
  DetailList := TMVCActiveRecord.Where<TCollectionDetail>('CollectionID = ?', [CollectionID]);
  try
    for var D in DetailList do
      D.Delete;
  finally
    DetailList.Free;
  End;

  // حذف کالکشن
  Col := TMVCActiveRecord.GetByPK<TCollection>(CollectionID);
  try
    Col.Delete;
  finally
    Col.Free;
  End;
End;

End.

