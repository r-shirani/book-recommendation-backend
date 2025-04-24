Unit Service.Book.Image;

Interface

Uses
    System.Generics.Collections,
    System.SysUtils,
    MVCFramework.ActiveRecord,
    Model.Book.Image,
    System.Classes, WebModule.Main;

Type
    IImageService = Interface ['{E5A3D1F2-4B7C-4D89-9F2A-3B6C8D9E1F4A}']
        Function GetImageByID(const ImageID: Int64): TImage;
        Function GetImagesByBookID(const BookID: Int64): TObjectList<TImage>;
        Function GetPrimaryImage(const BookID: Int64): TImage;
        Function GetImageByGUID(const GUID: TGUID): TImage;
        Procedure AddImage(var AImage: TImage; const FileStream: TStream; const OriginalFileName: string);
        Procedure UpdateImage(const AImage: TImage);
        Procedure DeleteImage(const ImageID: Int64);
        Procedure SetAsPrimary(const ImageID: Int64);
    End;

    TImageService = Class(TInterfacedObject, IImageService)
    Private
        Class Function GenerateImageUrl(const AImage: TImage): string;
        Class Procedure SetImageDimensions(AImage: TImage; const FileStream: TStream);

    Public
        Function GetImageByGUID(const GUID: TGUID): TImage;
        Function GetImageByID(const ImageID: Int64): TImage;
        Function GetImagesByBookID(const BookID: Int64): TObjectList<Model.Book.Image.TImage>;
        Function GetPrimaryImage(const BookID: Int64): TImage;
        Procedure AddImage(var AImage: TImage; const FileStream: TStream; const OriginalFileName: string);
        Procedure UpdateImage(const AImage: TImage);
        Procedure DeleteImage(const ImageID: Int64);
        Procedure SetAsPrimary(const ImageID: Int64);
    End;

Implementation

Uses
    System.NetEncoding,
    Vcl.Imaging.jpeg,
    Vcl.Imaging.pngimage,
    Vcl.Graphics;

{ TImageService }

//______________________________________________________________________________
Function TImageService.GetImageByGUID(const GUID: TGUID): TImage;
Begin
    Result := TMVCActiveRecord.GetOneByWhere<TImage>('ImageGuid = ?', [GUIDToString(GUID)]);
End;
//______________________________________________________________________________
Function TImageService.GetImageByID(const ImageID: Int64): TImage;
Begin
    Try
        Result := TMVCActiveRecord.GetByPK<TImage>(ImageID);
    Except
        Result := nil;
    End;
End;
//______________________________________________________________________________
Function TImageService.GetImagesByBookID(const BookID: Int64): TObjectList<TImage>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TImage>('BookID = ?', [BookID]);
    Except
        Result := nil;
    End;
End;
//______________________________________________________________________________
Function TImageService.GetPrimaryImage(const BookID: Int64): TImage;
Begin
    Try
        Result := TMVCActiveRecord.SelectOne<TImage>('WHERE BookID = ? AND IsPrimary = 1', [BookID]);
    Except
        on E: Exception do
        Begin
          // Log error
          Result := nil;
        End;
    End;
End;
//______________________________________________________________________________
Procedure TImageService.AddImage(Var AImage: TImage; const FileStream: TStream; const OriginalFileName: string);
Var
    LFileStream: TFileStream;
    LFilePath: string;
Begin
    If Not Assigned(AImage) Then
        AImage := TImage.Create;

    Try
        // Initialize image data
        AImage.ImageGuid := TGUID.NewGuid;
        AImage.UploadDate := Now;
        AImage.OriginalFileName := OriginalFileName;
        AImage.IsPrimary := False;

        // Process file
        FileStream.Position := 0;
        AImage.FileSizeKB := FileStream.Size div 1024;
        SetImageDimensions(AImage, FileStream);

        // Generate URL and save
        LFilePath := GenerateImageUrl(AImage);
        AImage.ImageUrl := BASE_ImageBook + AImage.ImageGuid.ToString;

        // Save physical file
        LFileStream := TFileStream.Create(LFilePath, fmCreate);
        Try
            FileStream.Position := 0;
            LFileStream.CopyFrom(FileStream, FileStream.Size);
        Finally
            LFileStream.Free;
        End;

        // Save to database
        AImage.Insert;
    Except
        On E: Exception Do
        Begin
            // Delete file if created
            If FileExists(LFilePath) Then
                DeleteFile(LFilePath);

            FreeAndNil(AImage);
            Raise;
        End;
    End;
End;
//______________________________________________________________________________
Procedure TImageService.UpdateImage(const AImage: TImage);
var
  OldImage: TImage;
Begin
    OldImage := TMVCActiveRecord.GetByPK<TImage>(AImage.ID);
    Try
        If not Assigned(OldImage) then
          raise Exception.Create('Image not found');

        If not AImage.ContentType.IsNull then OldImage.ContentType := AImage.ContentType;
        If not AImage.ImageUrl.IsNull then OldImage.ImageUrl := AImage.ImageUrl;
        If not AImage.IsPrimary.IsNull then OldImage.IsPrimary := AImage.IsPrimary;

        OldImage.Update;
    Finally
        OldImage.Free;
    End;
End;
//______________________________________________________________________________
Procedure TImageService.DeleteImage(const ImageID: Int64);
Var
    ImageToDelete: TImage;
    LFilePath: string;
Begin
    ImageToDelete := TMVCActiveRecord.GetByPK<TImage>(ImageID);
    Try
        If Not Assigned(ImageToDelete) Then
            Raise Exception.Create('Image not found');

        LFilePath := ExtractFilePath(ParamStr(0)) + 'BookImages\' +
                    ImageToDelete.ImageGuid.ToString +
                    ExtractFileExt(ImageToDelete.ImageUrl.ValueOrDefault);

        If FileExists(LFilePath) Then
            DeleteFile(LFilePath);

        ImageToDelete.Delete;
    Finally
        ImageToDelete.Free;
    End;
End;
//______________________________________________________________________________
Procedure TImageService.SetAsPrimary(const ImageID: Int64);
Var
    ImageToUpdate: TImage;
    CurrentPrimary: TImage;
Begin
    ImageToUpdate := TMVCActiveRecord.GetByPK<TImage>(ImageID);
    Try
        If not Assigned(ImageToUpdate) then
            raise Exception.Create('Image not found');

        CurrentPrimary := GetPrimaryImage(ImageToUpdate.BookID);
        Try
            // Unset current primary if exists
            If Assigned(CurrentPrimary) then
            Begin
                CurrentPrimary.IsPrimary := False;
                CurrentPrimary.Update;
            End;

            // Set new primary
            ImageToUpdate.IsPrimary := True;
            ImageToUpdate.Update;
        Finally
            CurrentPrimary.Free;
        End;
    Finally
        ImageToUpdate.Free;
    End;
End;
//______________________________________________________________________________
Class Function TImageService.GenerateImageUrl(const AImage: TImage): string;
Var
    LExtension: string;
    LBasePath: string;
Begin
    LBasePath := ExtractFilePath(ParamStr(0)) + 'BookImages';

    If Not DirectoryExists(LBasePath) Then
        ForceDirectories(LBasePath);

    If AImage.ContentType.HasValue Then
    Begin
        If AImage.ContentType.Value.Contains('jpeg') Then
            LExtension := '.jpg'
        Else If AImage.ContentType.Value.Contains('png') Then
            LExtension := '.png'
        Else If AImage.ContentType.Value.Contains('gif') Then
            LExtension := '.gif'
        Else
            LExtension := '.bin';
    End
    Else
    Begin
        LExtension := '.bin';
    End;

    Result := IncludeTrailingPathDelimiter(LBasePath) + AImage.ImageGuid.ToString + LExtension;
End;
//______________________________________________________________________________
Class Procedure TImageService.SetImageDimensions(AImage: TImage; const FileStream: TStream);
Var
    Image: TGraphic;
    LExtension: string;
Begin
    Image := nil;
    Try
        FileStream.Position := 0;

        LExtension := ExtractFileExt(AImage.OriginalFileName.Value).ToLower;

        // تشخیص نوع تصویر بر اساس پسوند
        If (LExtension = '.jpg') Or (LExtension = '.jpeg') Then
            Image := TJPEGImage.Create
        Else If LExtension = '.png' Then
            Image := TPngImage.Create;

        If Assigned(Image) Then
        Begin
            Try
                Image.LoadFromStream(FileStream);
                AImage.Width := Image.Width;
                AImage.Height := Image.Height;

                If (LExtension = '.jpg') Or (LExtension = '.jpeg') Then
                    AImage.ContentType := 'image/jpeg'
                Else If LExtension = '.png' Then
                    AImage.ContentType := 'image/png';
            Except
                On E: Exception Do
                Begin
                    FreeAndNil(Image);
                    Raise; // یا هندل خطا به روش دیگر
                End;
            End;
        End;
    Finally
        If Assigned(Image) Then
            Image.Free;
    End;
End;
//______________________________________________________________________________

End.
