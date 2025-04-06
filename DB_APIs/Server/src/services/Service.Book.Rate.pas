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
        Procedure AddOrUpdateRate(Const ARate: TRate);
        Procedure DeleteRate(UserID, BookID: Int64);
    End;

    TRateService = Class(TInterfacedObject, IRateService)
    Public
        Function GetRate(UserID, BookID: Int64): TRate;
        Function GetBookRates(BookID: Int64): TObjectList<TRate>;
        Function GetUserRates(UserID: Int64): TObjectList<TRate>;
        Function GetAverageRating(BookID: Int64): Double;
        Procedure AddOrUpdateRate(Const ARate: TRate);
        Procedure DeleteRate(UserID, BookID: Int64);
    End;

Implementation

{ TRateService }

//______________________________________________________________________________
Function TRateService.GetRate(UserID, BookID: Int64): TRate;
Var
    Temp: TObjectList<TRate>;
Begin
    Temp := TMVCActiveRecord.Where<TRate>('UserID = ? AND BookID = ?', [UserID, BookID]);
    If (Temp.Count <> 0) then
        Result := Temp[0]
    Else
        Result := nil;
End;
//______________________________________________________________________________
Function TRateService.GetBookRates(BookID: Int64): TObjectList<TRate>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TRate>('BookID = ?', [BookID]);
    Except
        Result := nil;
    End;
End;
//______________________________________________________________________________
Function TRateService.GetUserRates(UserID: Int64): TObjectList<TRate>;
Begin
    Try
        Result := TMVCActiveRecord.Where<TRate>('UserID = ?',[UserID]);
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
Procedure TRateService.AddOrUpdateRate(Const ARate: TRate);
Var
    Temp: TObjectList<TRate>;
Begin
    Temp := TMVCActiveRecord.Where<TRate>('UserID = ? AND BookID = ?', [ARate.UserID, ARate.BookID]);

    if (ARate.Rate < 1) or (ARate.Rate > 5) then
        raise Exception.Create('Rate value must be between 1 and 5');

    Try
        If (Temp.Count <> 0) then
        begin
            ARate.Update;
        end
        else
        begin
            Try
                ARate.Insert;
            Except
                ARate.Free;
                raise;
            End;
        end;
    Finally
        if Assigned(Temp) then
            Temp.Free;
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
