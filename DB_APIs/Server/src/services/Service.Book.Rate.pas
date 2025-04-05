﻿Unit Service.Book.Rate;

Interface

Uses
    System.Generics.Collections,
    System.SysUtils,
    MVCFramework.ActiveRecord,
    Model.Book.Rate;

Type
    IRateService = Interface
        ['{A3B4C5D6-E7F8-4921-8345-6D7E8F9A0B1C}']
        Function GetRate(UserID, BookID: Int64): TRate;
        Function GetBookRates(BookID: Int64): TObjectList<TRate>;
        Function GetUserRates(UserID: Int64): TObjectList<TRate>;
        Function GetAverageRating(BookID: Int64): Double;
        Procedure AddOrUpdateRate(UserID, BookID: Int64; RateValue: Byte);
        Procedure DeleteRate(UserID, BookID: Int64);
    End;

    TRateService = Class(TInterfacedObject, IRateService)
    Public
        Function GetRate(UserID, BookID: Int64): TRate;
        Function GetBookRates(BookID: Int64): TObjectList<TRate>;
        Function GetUserRates(UserID: Int64): TObjectList<TRate>;
        Function GetAverageRating(BookID: Int64): Double;
        Procedure AddOrUpdateRate(UserID, BookID: Int64; RateValue: Byte);
        Procedure DeleteRate(UserID, BookID: Int64);
    End;

Implementation

{ TRateService }

//______________________________________________________________________________
Function TRateService.GetRate(UserID, BookID: Int64): TRate;
Begin
    Try
        Result := TMVCActiveRecord.Where<TRate>(
            'UserID = ? AND BookID = ?',
            [UserID, BookID]
        ).First;
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function TRateService.GetBookRates(BookID: Int64): TObjectList<TRate>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TRate>(
            'BookID = ?',
            [BookID]
        );
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function TRateService.GetUserRates(UserID: Int64): TObjectList<TRate>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TRate>(
            'UserID = ?',
            [UserID]
        );
    Except
        On E: Exception Do
        Begin
            // Log the error if needed
            Result := NIL;
        End;
    End;
End;
//______________________________________________________________________________
Function TRateService.GetAverageRating(BookID: Int64): Double;
Var
    Rates: TObjectList<TRate>;
    Rate: TRate;
    Total: Integer;
    Count: Integer;
Begin
    Rates := GetBookRates(BookID);
    Try
        Total := 0;
        Count := 0;

        if Assigned(Rates) then
        begin
            for Rate in Rates do
            begin
                Inc(Total, Rate.Rate);
                Inc(Count);
            end;
        end;

        if Count > 0 then
            Result := Total / Count
        else
            Result := 0;
    Finally
        Rates.Free;
    End;
End;
//______________________________________________________________________________
Procedure TRateService.AddOrUpdateRate(UserID, BookID: Int64; RateValue: Byte);
Var
    ExistingRate: TRate;
Begin
    // Validate rate value (assuming 1-5 scale)
    if (RateValue < 1) or (RateValue > 5) then
        raise Exception.Create('Rate value must be between 1 and 5');

    ExistingRate := GetRate(UserID, BookID);
    Try
        if Assigned(ExistingRate) then
        begin
            // Update existing rate
            ExistingRate.Rate := RateValue;
            ExistingRate.Update;
        end
        else
        begin
            // Create new rate
            ExistingRate := TRate.Create;
            Try
                ExistingRate.UserID := UserID;
                ExistingRate.BookID := BookID;
                ExistingRate.Rate := RateValue;
                ExistingRate.Insert;
            Except
                ExistingRate.Free;
                raise;
            End;
        end;
    Finally
        if Assigned(ExistingRate) then
            ExistingRate.Free;
    End;
End;
//______________________________________________________________________________
Procedure TRateService.DeleteRate(UserID, BookID: Int64);
Var
    RateToDelete: TRate;
Begin
    RateToDelete := GetRate(UserID, BookID);
    Try
        if Assigned(RateToDelete) then
            RateToDelete.Delete;
    Finally
        RateToDelete.Free;
    End;
End;
//______________________________________________________________________________

End.
