﻿Unit Service.User.Image;

Interface

Uses
  System.Classes,
  System.SysUtils,
  Model.User.Image,
  System.IOUtils,
  MVCFramework.ActiveRecord;

Type
    IUserImageService = interface
        ['{F19D5B1C-9D50-444B-AC77-9A43E3B35125}']
        Function GetProfileImage(const UserID: Int64): TImage;
        Procedure SaveProfileImage(var AImage: TImage; const FileStream: TStream; const OriginalFileName: string);
        Procedure DeleteProfileImage(const UserID: Int64);
    End;

    TUserImageService = class(TInterfacedObject, IUserImageService)
    Private
        class Function GenerateImagePath(const UserID: Int64; const Extension: string): string;
        class Procedure SetImageDimensions(AImage: TImage; const FileStream: TStream);

    Public
        Function GetProfileImage(const UserID: Int64): TImage;
        Procedure SaveProfileImage(var AImage: TImage; const FileStream: TStream; const OriginalFileName: string);
        Procedure DeleteProfileImage(const UserID: Int64);
    End;

Implementation

Uses
    Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Graphics;

Const
    BASE_PROFILE_IMAGE_URL = '/UserImages';

{ TUserImageService }

//______________________________________________________________________________
Class Function TUserImageService.GenerateImagePath(const UserID: Int64; const Extension: string): string;
Var
    Dir: string;
Begin
    Dir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'UserImages\';
    If (not DirectoryExists(Dir)) then ForceDirectories(Dir);

    Result := Dir + Format('%d%s', [UserID, Extension]);
End;
//______________________________________________________________________________
Function TUserImageService.GetProfileImage(const UserID: Int64): TImage;
Begin
    Try
        Result := TMVCActiveRecord.GetByPK<TImage>(UserID);
    Except
        Result := Nil;
    End;
End;
//______________________________________________________________________________
Procedure TUserImageService.SaveProfileImage(var AImage: TImage; const FileStream: TStream; const OriginalFileName: string);
Var
    Extension: string;
    FilePath: string;
    FS: TFileStream;
Begin
    If (Not Assigned(AImage)) then AImage := TImage.Create;

    Try
        AImage.UploadDate := Now;
        AImage.OriginalFileName := OriginalFileName;
        FileStream.Position := 0;
        AImage.FileSizeKB := FileStream.Size div 1024;

        SetImageDimensions(AImage, FileStream);

        Extension := ExtractFileExt(OriginalFileName).ToLower;
        FilePath := GenerateImagePath(AImage.UserID, Extension);

        AImage.ImageUrl := BASE_PROFILE_IMAGE_URL + '/' + Format('%d%s', [AImage.UserID, Extension]);

        FS := TFileStream.Create(FilePath, fmCreate);
        try
          FileStream.Position := 0;
          FS.CopyFrom(FileStream, FileStream.Size);
        finally
          FS.Free;
        End;

//        AImage.DeleteRQL<TImage>('UserID = ?' + AImage.UserID);
//        AImage.Insert;
    except
        on E: Exception do
        begin
            if FileExists(FilePath) then
              DeleteFile(FilePath);
            FreeAndNil(AImage);
            raise;
        End;
    End;
End;
//______________________________________________________________________________
Procedure TUserImageService.DeleteProfileImage(const UserID: Int64);
var
  Img: TImage;
  FilePath: string;
begin
  Img := GetProfileImage(UserID);
  if Assigned(Img) then
  begin
    FilePath := GenerateImagePath(UserID, ExtractFileExt(Img.ImageUrl.ValueOrDefault));
    if FileExists(FilePath) then
      DeleteFile(FilePath);
    Img.Delete;
    Img.Free;
  End;
End;
//______________________________________________________________________________
Class Procedure TUserImageService.SetImageDimensions(AImage: TImage; const FileStream: TStream);
Var
    Img: TGraphic;
    Ext: string;
Begin
    FileStream.Position := 0;
    Ext := ExtractFileExt(AImage.OriginalFileName.Value).ToLower;
    if Ext = '.jpg' then
      Img := TJPEGImage.Create
    else if Ext = '.png' then
      Img := TPngImage.Create
    else
      Exit;

    try
        Img.LoadFromStream(FileStream);
        AImage.Width := Img.Width;
        AImage.Height := Img.Height;

        if Ext = '.jpg' then
            AImage.ContentType := 'image/jpeg'
        else if Ext = '.png' then
            AImage.ContentType := 'image/png';
    finally
        Img.Free;
    End;
End;
//______________________________________________________________________________
End.

