unit Model.Book.AccessibilityGroup;

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  MVCFramework.Nullables;

type
  [MVCNameCase(ncLowerCase)]
  [MVCTable('Book.AccessibilityGroup')]
  TAccessibilityGroup = class(TMVCActiveRecord)
  private
    [MVCTableField('AccessibilityGroupID', [foPrimaryKey])]
    FAccessibilityGroupID: Int64;

    [MVCTableField('Title')]
    FTitle: NullableString;

    [MVCTableField('Discription')]
    FDiscription: NullableString;

    [MVCTableField('AccessibilityTypeID')]
    FAccessibilityTypeID: NullableInt32;

  public
    property AccessibilityGroupID: Int64 read FAccessibilityGroupID write FAccessibilityGroupID;
    property Title: NullableString read FTitle write FTitle;
    property Discription: NullableString read FDiscription write FDiscription;
    property AccessibilityTypeID: NullableInt32 read FAccessibilityTypeID write FAccessibilityTypeID;
  end;

implementation

end.

