unit Model.Book.AccessibilityType;

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  MVCFramework.Nullables;

type
  [MVCNameCase(ncLowerCase)]
  [MVCTable('Book.AccessibilityType')]
  TAccessibilityType = class(TMVCActiveRecord)
  private
    [MVCTableField('AccessibilityTypeID', [foPrimaryKey])]
    FAccessibilityTypeID: Int32;

    [MVCTableField('Title')]
    FTitle: NullableString;

    [MVCTableField('CanRead')]
    FCanRead: Boolean;

    [MVCTableField('CanInsert')]
    FCanInsert: Boolean;

    [MVCTableField('CanDelete')]
    FCanDelete: Boolean;

    [MVCTableField('CanChangeHeader')]
    FCanChangeHeader: Boolean;

  public
    property AccessibilityTypeID: Int32 read FAccessibilityTypeID write FAccessibilityTypeID;
    property Title: NullableString read FTitle write FTitle;
    property CanRead: Boolean read FCanRead write FCanRead;
    property CanInsert: Boolean read FCanInsert write FCanInsert;
    property CanDelete: Boolean read FCanDelete write FCanDelete;
    property CanChangeHeader: Boolean read FCanChangeHeader write FCanChangeHeader;
  end;

implementation

end.

