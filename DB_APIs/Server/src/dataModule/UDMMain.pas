﻿unit UDMMain;

interface

uses
    System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
    Data.DB, FireDAC.Comp.Client, IniFiles, FireDAC.Stan.Param, FireDAC.DatS,
    FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
    TDMMain = class(TDataModule)
      FDConn: TFDConnection;
    public
      constructor Create(AOwner: TComponent); override;
      class function GetConnection: TFDConnection;
End;

var
  DMMain: TDMMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

//______________________________________________________________________________
Constructor TDMMain.Create(AOwner: TComponent);
Var
    iniFile: TIniFile;
    iniPath: string;
    Driver, Server, Database, UserName, Password: string;
Begin
    Inherited Create(AOwner);

    iniPath := ExtractFilePath(ParamStr(0)) + 'FDConnectionDefs.ini';
  
    If not FileExists(iniPath) then
      raise Exception.Create('Configuration file FDConnectionDefs.ini not found!');

    iniFile := TIniFile.Create(iniPath);
    Try
        Driver := iniFile.ReadString('ProjBookWorm', 'DriverID', '');
        Server := iniFile.ReadString('ProjBookWorm', 'Server', '');
        Database := iniFile.ReadString('ProjBookWorm', 'Database', '');
        UserName := iniFile.ReadString('ProjBookWorm', 'User_name', '');
        Password := iniFile.ReadString('ProjBookWorm', 'Password', '');

        FDConn.Params.Clear;
        FDConn.Params.Add('DriverID=' + Driver);
        FDConn.Params.Add('SERVER=' + Server);
        FDConn.Params.Add('DataBase=' + Database);
        FDConn.Params.Add('User_Name=' + UserName);
        FDConn.Params.Add('Password=' + Password);

        FDConn.Connected := True;

    Finally
        iniFile.Free;
    End;
End;
//______________________________________________________________________________
{Singelton DataModule}

Class Function TDMMain.GetConnection: TFDConnection;
Begin
    If (DMMain = Nil) then
      DMMain := TDMMain.Create(nil);

    If not DMMain.FDConn.Connected then
      DMMain.FDConn.Connected := True;

    Result := DMMain.FDConn;
End;
//______________________________________________________________________________

End.
