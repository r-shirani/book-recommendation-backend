Unit Service.Book.Language;

Interface

Uses
    System.Generics.Collections,
    System.SysUtils,
    MVCFramework.ActiveRecord,
    Model.Book.Language;

Type
    ILanguageService = Interface
        ['{5E8F1A2B-9C34-4D7F-B621-7D3E4F5A6B1C}']
        Function GetLanguageByID(Const LanguageID: Integer): TLanguage;
        Function GetAllLanguages: TObjectList<TLanguage>;
        Function GetLanguageByISOCode(Const ISOCode: String): TLanguage;
        Procedure AddLanguage(Const ALanguage: TLanguage);
        Procedure UpdateLanguage(Const ALanguage: TLanguage);
        Procedure DeleteLanguage(Const LanguageID: Integer);
    End;

    TLanguageService = Class(TInterfacedObject, ILanguageService)
    Public
        Function GetLanguageByID(Const LanguageID: Integer): TLanguage;
        Function GetAllLanguages: TObjectList<TLanguage>;
        Function GetLanguageByISOCode(Const ISOCode: String): TLanguage;
        Procedure AddLanguage(Const ALanguage: TLanguage);
        Procedure UpdateLanguage(Const ALanguage: TLanguage);
        Procedure DeleteLanguage(Const LanguageID: Integer);
    End;

Implementation

{ TLanguageService }

//______________________________________________________________________________
Function TLanguageService.GetLanguageByID(Const LanguageID: Integer): TLanguage;
Begin
    Try
        Result := TMVCActiveRecord.GetByPK<TLanguage>(LanguageID);
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function TLanguageService.GetAllLanguages: TObjectList<TLanguage>;
Begin
    Try
        Result := TMVCActiveRecord.All<TLanguage>;
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function TLanguageService.GetLanguageByISOCode(Const ISOCode: String): TLanguage;
Begin
    Try
        Result := TMVCActiveRecord.Where<TLanguage>('ISOCode = ?', [ISOCode]).First;
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Procedure TLanguageService.AddLanguage(Const ALanguage: TLanguage);
Begin
    If ALanguage.Title.Trim = '' Then
        Raise Exception.Create('Language title cannot be empty');

    If (Not ALanguage.ISOCode.IsNull) And (ALanguage.ISOCode.Value.Trim.Length <> 2) Then
        Raise Exception.Create('ISO Code must be 2 characters');

    ALanguage.Insert;
End;
//______________________________________________________________________________
Procedure TLanguageService.UpdateLanguage(Const ALanguage: TLanguage);
Var
    OldLanguage: TLanguage;
Begin
    OldLanguage := TMVCActiveRecord.GetByPK<TLanguage>(ALanguage.LanguageID);
    Try
        If Not Assigned(OldLanguage) Then
            Raise Exception.Create('Language Not Found');

        // Update only fields that have new values
        If ALanguage.Title <> '' Then OldLanguage.Title := ALanguage.Title;
        If Not ALanguage.ISOCode.IsNull Then
        Begin
            If ALanguage.ISOCode.Value.Trim.Length <> 2 Then
                Raise Exception.Create('ISO Code must be 2 characters');
            OldLanguage.ISOCode := ALanguage.ISOCode;
        End;

        // Save changes
        OldLanguage.Update;
    Finally
        OldLanguage.Free;
    End;
End;
//______________________________________________________________________________
Procedure TLanguageService.DeleteLanguage(Const LanguageID: Integer);
Var
    LanguageToDelete: TLanguage;
Begin
    LanguageToDelete := TMVCActiveRecord.GetByPK<TLanguage>(LanguageID);
    Try
        If Not Assigned(LanguageToDelete) Then
            Raise Exception.Create('Language Not Found');

        LanguageToDelete.Delete;
    Finally
        LanguageToDelete.Free;
    End;
End;
//______________________________________________________________________________

End.
