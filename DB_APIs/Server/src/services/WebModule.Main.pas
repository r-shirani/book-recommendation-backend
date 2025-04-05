﻿Unit WebModule.Main;

Interface

Uses
    System.SysUtils,
    System.Classes,
    Web.HTTPApp,
    MVCFramework;

Type
    TBookWorm = Class(TWebModule)
        Procedure WebModuleCreate(Sender: TObject);
        Procedure WebModuleDestroy(Sender: TObject);

    Private
        FMVC: TMVCEngine;
End;

Var
    WebModuleClass: TComponentClass = TBookWorm;

Const
    BASE_Image = 'http://localhost/BookImage';
    BASE_API_V1 = '/api/v1';


implementation

{$R *.dfm}

uses
  Controller.User,
  Controller.UserSecurity,
  MVCFramework.Middleware.ActiveRecord,
  MVCFramework.SQLGenerators.MSSQL,
  System.IOUtils,
  MVCFramework.Commons,
  MVCFramework.Middleware.Compression,
  MVCFramework.Middleware.Session,
  MVCFramework.Middleware.Redirect,
  MVCFramework.Middleware.StaticFiles,
  MVCFramework.Middleware.Analytics,
  MVCFramework.Middleware.Trace,
  MVCFramework.Middleware.CORS,
  MVCFramework.Middleware.ETag,
  UDMMain,

  //Controller:
  Controller.Book.Author, Controller.Book.Comment, Controller.Book.Rate,
  Controller.Book.Hashtag, Controller.Book.Language, Controller.Book,
  Controller.Book.Image;


Procedure TBookWorm.WebModuleCreate(Sender: TObject);
begin
    TDMMain.GetConnection;
    FMVC := TMVCEngine.Create(Self,
    Procedure(Config: TMVCConfig)
    begin
      //default content-type
      Config[TMVCConfigKey.DefaultContentType] := dotEnv.Env('dmvc.default.content_type', TMVCConstants.DEFAULT_CONTENT_TYPE);
      //default content charset
      Config[TMVCConfigKey.DefaultContentCharset] := dotEnv.Env('dmvc.default.content_charset', TMVCConstants.DEFAULT_CONTENT_CHARSET);
      //unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := dotEnv.Env('dmvc.allow_unhandled_actions', 'false');
      //enables or not system controllers loading (available only from localhost requests)
      Config[TMVCConfigKey.LoadSystemControllers] := dotEnv.Env('dmvc.load_system_controllers', 'true');
      //default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := dotEnv.Env('dmvc.default.view_file_extension', 'html');
      //view path
      Config[TMVCConfigKey.ViewPath] := dotEnv.Env('dmvc.view_path', 'templates');
      //use cache for server side views (use "false" in debug and "true" in production for faster performances
      Config[TMVCConfigKey.ViewCache] := dotEnv.Env('dmvc.view_cache', 'false');
      //Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := dotEnv.Env('dmvc.max_entities_record_count', IntToStr(TMVCConstants.MAX_RECORD_COUNT));
      //Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := dotEnv.Env('dmvc.expose_server_signature', 'false');
      //Enable X-Powered-By Header in response
      Config[TMVCConfigKey.ExposeXPoweredBy] := dotEnv.Env('dmvc.expose_x_powered_by', 'true');
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] := dotEnv.Env('dmvc.max_request_size', IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE));
    end);

    // Controllers
    fMVC.AddController(TUserController);
    fMVC.AddController(TUserSecurityController);
    fMVC.AddController(TBookController);
    fMVC.AddController(TAuthorController);
    fMVC.AddController(TCommentController);
    fMVC.AddController(THashtagController);
    fMVC.AddController(TLanguageController);
    fMVC.AddController(TRateController);
    fMVC.AddController(TImageController);

    // Middleware
    fMVC.AddMiddleware(TMVCCompressionMiddleware.Create);
    fMVC.AddMiddleware(TMVCETagMiddleware.Create);
    fMVC.AddMiddleware(TMVCCORSMiddleware.Create);
    fMVC.AddMiddleware(TMVCActiveRecordMiddleware.Create('ProjBookWorm'));
End;
//______________________________________________________________________________
Procedure TBookWorm.WebModuleDestroy(Sender: TObject);
Begin
    fMVC.Free;
End;
//______________________________________________________________________________

End.

