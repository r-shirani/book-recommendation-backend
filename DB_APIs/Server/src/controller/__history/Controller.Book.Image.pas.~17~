Unit Controller.Book.Image;

Interface

Uses
    MVCFramework,
    MVCFramework.Commons,
    MVCFramework.Serializer.Commons,
    Service.Book.Image,
    Model.Book.Image, WebModule.Main;

Type
    [MVCPath(BASE_API_V1 + '/images')]
    TImageController = class(TMVCController)
    Private
        FImageService: IImageService;
    Public
        Procedure OnAfterAction(Context: TWebContext; Const AActionNAme: String); Override;
        Procedure OnBeforeAction(Context: TWebContext; Const AActionNAme: String; Var Handled: Boolean); Override;

        [MVCPath('/($ID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetImageByID(ID: Int64);

        [MVCPath('/book/($BookID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetImagesByBookID(BookID: Int64);

        [MVCPath('/primary/($BookID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetPrimaryImage(BookID: Int64);

        [MVCPath]
        [MVCHTTPMethod([httpPOST])]
        Procedure UploadImage;

        [MVCPath('/($ID)')]
        [MVCHTTPMethod([httpPUT])]
        Procedure UpdateImage(ID: Int64);

        [MVCPath('/($ID)')]
        [MVCHTTPMethod([httpDELETE])]
        Procedure DeleteImage(ID: Int64);

        [MVCPath('/($ID)/setprimary')]
        [MVCHTTPMethod([httpPOST])]
        Procedure SetAsPrimaryImage(ID: Int64);

        [MVCPath('/file/($GUID)')]
        [MVCHTTPMethod([httpGET])]
        Procedure GetImageFileByGUID(GUID: TGUID);
    End;

Implementation

Uses
    System.Classes,
    System.SysUtils, System.Generics.Collections;

{ TImageController }

Procedure TImageController.OnAfterAction(Context: TWebContext; Const AActionNAme: String);
Begin
    inherited;
    FImageService := Nil;
End;
//______________________________________________________________________________

Procedure TImageController.OnBeforeAction(Context: TWebContext; Const AActionNAme: String;
    Var Handled: Boolean);
Begin
    inherited;
    FImageService := TImageService.Create;
End;
//______________________________________________________________________________
Procedure TImageController.GetImageByID(ID: Int64);
Var
    LImage: TImage;
Begin
    LImage := FImageService.GetImageByID(ID);
    If Assigned(LImage) Then
        Render(LImage)
    Else
        Render(HTTP_STATUS.NotFound, 'Image not found');
End;
//______________________________________________________________________________
Procedure TImageController.GetImageFileByGUID(GUID: TGUID);
Var
    LImage: TImage;
    LImageStream: TStream;
    LFilePath, LFileExt, LContentType: String;
    LBookID: Int64;
    LResponseStream: TStringStream;
Begin
    LImage := FImageService.GetImageByGUID(GUID);
    Try
        If Not Assigned(LImage) Then
            Raise EMVCException.Create(HTTP_STATUS.NotFound, 'Image not found');

        LFilePath := ExtractFilePath(ParamStr(0)) + 'BookImages\' + GUID.ToString +
                     ExtractFileExt(LImage.OriginalFileName.ValueOrDefault);

        If Not FileExists(LFilePath) Then
            Raise EMVCException.Create(HTTP_STATUS.NotFound, 'Image file not found');

        LFileExt := LowerCase(ExtractFileExt(LFilePath));

        If (LFileExt = '.jpg') then LContentType := 'image/jpeg'
        Else If (LFileExt = '.jpeg') then LContentType := 'image/jpeg'
        Else If (LFileExt = '.png') then LContentType := 'image/png'
        Else If (LFileExt = '.gif') then LContentType := 'image/gif'
        Else If (LFileExt = '.bmp') then LContentType := 'image/bmp'
        Else If (LFileExt = '.webp') then LContentType := 'image/webp'
        Else LContentType := 'application/octet-stream';

        LImageStream := TFileStream.Create(LFilePath, fmOpenRead or fmShareDenyWrite);
        Try
            // تنظیم هدر Content-Disposition برای نمایش در مرورگر
            Context.Response.SetCustomHeader('Content-Disposition', 'inline; filename="' +
                                          ExtractFileName(LImage.OriginalFileName.ValueOrDefault) + '"');

            // ارسال استریم با پارامتر False برای عدم آزادسازی خودکار
            Render(LImageStream, False);

            // تنظیم نوع محتوا
            Context.Response.ContentType := LContentType;
        Finally
            // حالا می‌توانیم استریم را آزاد کنیم چون Render کارش را انجام داده
            LImageStream.Free;
        End;
    Finally
        LImage.Free;
    End;
End;

//______________________________________________________________________________
Procedure TImageController.GetImagesByBookID(BookID: Int64);
Var
    LImages: TObjectList<TImage>;
Begin
    LImages := FImageService.GetImagesByBookID(BookID);
    If Assigned(LImages) Then
        Render(LImages)
    Else
        Render(HTTP_STATUS.NotFound, 'No images found for this book');
End;
//______________________________________________________________________________
Procedure TImageController.GetPrimaryImage(BookID: Int64);
Var
    LImage: TImage;
Begin
    LImage := FImageService.GetPrimaryImage(BookID);
    Try
        If Not Assigned(LImage) Then
            Raise EMVCException.Create(HTTP_STATUS.NotFound, 'Primary image not found');

        Render(LImage);
    Finally
        LImage.Free;
    End;
End;
//______________________________________________________________________________
Procedure TImageController.UploadImage;
Var
    LImage: TImage;
    LFileStream: TStream;
    LFileName: String;
    LBookID: Int64;
Begin
    LFileStream := Context.Request.Files[0].Stream;
    LFileName := Context.Request.Files[0].FileName;
    LBookID := Context.Request.ParamsAsInteger['bookID'];

    LImage := TImage.Create;
    Try
        LImage.BookID := LBookID;
        FImageService.AddImage(LImage, LFileStream, LFileName);
        Render(HTTP_STATUS.Created, LImage);
    Except
        On E: Exception Do
        Begin
            Render(HTTP_STATUS.BadRequest, E.Message);
        End;
    End;
End;
//______________________________________________________________________________
Procedure TImageController.UpdateImage(ID: Int64);
Var
    LImage: TImage;
Begin
    // دریافت داده‌های به روزرسانی
    LImage := Context.Request.BodyAs<TImage>;
    Try
        LImage.ID := ID;
        FImageService.UpdateImage(LImage);
        Render(HTTP_STATUS.OK, LImage);
    Finally
        LImage.Free;
    End;
End;
//______________________________________________________________________________
Procedure TImageController.DeleteImage(ID: Int64);
Begin
    Try
        FImageService.DeleteImage(ID);
        Render(HTTP_STATUS.NoContent);
    Except
        On E: Exception Do
        Begin
            Render(HTTP_STATUS.BadRequest, E.Message);
        End;
    End;
End;
//______________________________________________________________________________

Procedure TImageController.SetAsPrimaryImage(ID: Int64);
Begin
    Try
        FImageService.SetAsPrimary(ID);
        Render(HTTP_STATUS.OK);
    Except
        On E: Exception Do
        Begin
            Render(HTTP_STATUS.BadRequest, E.Message);
        End;
    End;
End;
//______________________________________________________________________________

End.
