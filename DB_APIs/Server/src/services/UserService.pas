unit UserService;

interface

uses
  Model.User,
  MVCFramework.Container,
  MVCFramework, MVCFramework.Commons,
  MVCFramework.SQLGenerators.MSSQL,
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  MVCFramework.Nullables,
  System.Generics.Collections;

Type
    IUserService = interface
        ['{9685513C-D9FD-4FD3-945D-CA204505CB62}']
        Function GetAll: TObjectList<Model.User.TUser>;
    End;

    TUserService = Class(TInterfacedObject, IUserService)
    protected
        Function GetAll: TObjectList<Model.User.TUser>;
    End;

Procedure RegisterServices(Container: IMVCServiceContainer);

Implementation

Uses
    System.SysUtils, Controller.User;

Procedure RegisterServices(Container: IMVCServiceContainer);
Begin
    Container.RegisterType(TUserService, IUserService, TRegistrationType.SingletonPerRequest);
    // Register other services here
End;

Function TUserService.GetAll: TObjectList<Model.User.TUser>;
Var
  lstUsers: TObjectList<Model.User.TUser>;
Begin
    lstUsers := TMVCActiveRecord.SelectRQL<Model.User.TUser>('', 100);
//    Result.AddRange([
//      Model.User.TUser.Create(1, 'Henry', 'Ford', EncodeDate(1863, 7, 30)),
//      Model.User.TUser.Create(2, 'Guglielmo', 'Marconi', EncodeDate(1874, 4, 25)),
//      Model.User.TUser.Create(3, 'Antonio', 'Meucci', EncodeDate(1808, 4, 13)),
//      Model.User.TUser.Create(4, 'Michael', 'Faraday', EncodeDate(1867, 9, 22))
//    ]);

   // Result := TObjectList<TUser>.Create;
End;

end.
