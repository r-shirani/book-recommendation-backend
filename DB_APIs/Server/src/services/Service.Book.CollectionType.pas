unit Service.Book.CollectionType;

interface

uses
  System.Generics.Collections, System.SysUtils, MVCFramework.ActiveRecord,
  Model.Book.CollectionType;

type
  ICollectionTypeService = interface
    ['{9A3D2B90-5A8E-4D9E-A593-05E9ED681D17}']
    function GetByID(const ID: Int64): TCollectionType;
    function GetAll: TObjectList<TCollectionType>;
    procedure Add(const Rec: TCollectionType);
    procedure Update(const Rec: TCollectionType);
    procedure Delete(const ID: Int64);
  end;

  TCollectionTypeService = class(TInterfacedObject, ICollectionTypeService)
  public
    function GetByID(const ID: Int64): TCollectionType;
    function GetAll: TObjectList<TCollectionType>;
    procedure Add(const Rec: TCollectionType);
    procedure Update(const Rec: TCollectionType);
    procedure Delete(const ID: Int64);
  end;

implementation

function TCollectionTypeService.GetByID(const ID: Int64): TCollectionType;
begin
  Result := TMVCActiveRecord.GetByPK<TCollectionType>(ID);
end;

function TCollectionTypeService.GetAll: TObjectList<TCollectionType>;
begin
  Result := TMVCActiveRecord.All<TCollectionType>;
end;

procedure TCollectionTypeService.Add(const Rec: TCollectionType);
begin
  Rec.Insert;
end;

procedure TCollectionTypeService.Update(const Rec: TCollectionType);
begin
  Rec.Update;
end;

procedure TCollectionTypeService.Delete(const ID: Int64);
var
  Rec: TCollectionType;
begin
  Rec := TMVCActiveRecord.GetByPK<TCollectionType>(ID);
  try
    Rec.Delete;
  finally
    Rec.Free;
  end;
end;

end.

