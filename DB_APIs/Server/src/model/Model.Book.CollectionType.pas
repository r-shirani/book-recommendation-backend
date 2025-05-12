unit Model.Book.CollectionType;

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  MVCFramework.Nullables;

type
  [MVCNameCase(ncLowerCase)]
  [MVCTable('Book.CollectionType')]
  TCollectionType = class(TMVCActiveRecord)
  private
    [MVCTableField('CollectionTypeID', [foPrimaryKey])]
    FCollectionTypeID: Integer;

    [MVCTableField('Title')]
    FTitle: NullableString;

    [MVCTableField('Discription')]
    FDiscription: NullableString;

  public
    property CollectionTypeID: Integer read FCollectionTypeID write FCollectionTypeID;
    property Title: NullableString read FTitle write FTitle;
    property Discription: NullableString read FDiscription write FDiscription;
  end;

implementation

end.

