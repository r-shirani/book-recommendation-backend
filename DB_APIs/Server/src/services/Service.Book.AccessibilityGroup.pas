unit Service.Book.AccessibilityGroup;

interface

uses
  System.Generics.Collections, System.SysUtils, MVCFramework.ActiveRecord,
  Model.Book.AccessibilityGroup;

type
  IAccessibilityGroupService = interface
    ['{D3DA0A6E-8C1F-4E3F-BCE8-2A7AD77A8F01}']
    function GetByID(const ID: Int64): TAccessibilityGroup;
    function GetAll: TObjectList<TAccessibilityGroup>;
    procedure Add(const Group: TAccessibilityGroup);
    procedure Update(const Group: TAccessibilityGroup);
    procedure Delete(const ID: Int64);
  end;

  TAccessibilityGroupService = class(TInterfacedObject, IAccessibilityGroupService)
  public
    function GetByID(const ID: Int64): TAccessibilityGroup;
    function GetAll: TObjectList<TAccessibilityGroup>;
    procedure Add(const Group: TAccessibilityGroup);
    procedure Update(const Group: TAccessibilityGroup);
    procedure Delete(const ID: Int64);
  end;

implementation

function TAccessibilityGroupService.GetByID(const ID: Int64): TAccessibilityGroup;
begin
  Result := TMVCActiveRecord.GetByPK<TAccessibilityGroup>(ID);
end;

function TAccessibilityGroupService.GetAll: TObjectList<TAccessibilityGroup>;
begin
  Result := TMVCActiveRecord.All<TAccessibilityGroup>;
end;

procedure TAccessibilityGroupService.Add(const Group: TAccessibilityGroup);
begin
  Group.Insert;
end;

procedure TAccessibilityGroupService.Update(const Group: TAccessibilityGroup);
begin
  Group.Update;
end;

procedure TAccessibilityGroupService.Delete(const ID: Int64);
var
  Group: TAccessibilityGroup;
begin
  Group := TMVCActiveRecord.GetByPK<TAccessibilityGroup>(ID);
  try
    Group.Delete;
  finally
    Group.Free;
  end;
end;

end.

