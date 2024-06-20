unit DelphiFixes;

{ Created by Bhavan Baijnath, a Gr11 student who finds Delphi's incompetency incredible frustrating. }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Math;

function ToString(input: Variant): String;
function ToInt(input: Variant): Integer;
function ToFloat(input: Variant): Real;

implementation

function ToFloat(input: Variant): Real;
var
  i, iDecimalPos: Integer;
  cFractionSeparator: Char;
  sInput, sInputTemp: String;
  iFraction, iInteger, iDigitsAfterDecimal: Integer;

begin

  if VarType(input) in [varSingle, varDouble, varCurrency, varSmallint,
    varInteger, varInt64, varByte, varShortInt] then
    Result := input
  else if (VarType(input) = varString) or (VarType(input) = varUString) then
  begin

    sInputTemp := input;
    sInput := '';

    if not((Pos(',', sInputTemp) = 0) and (Pos('.', sInputTemp) = 0)) then
    begin

      for i := 1 to Length(sInputTemp) do
        // Removes any characters that could cause errors
        if ((sInputTemp[i] in ['0' .. '9']) or (sInputTemp[i] in [',', '.']))
          then
        begin
          sInput := sInput + sInputTemp[i];
        end;

      cFractionSeparator := '-';
      iDecimalPos := -1;

      iFraction := 0;
      iInteger := 0;

      // Finding the last decimal/comma which could be the separator
      for i := 1 to Length(sInput) do
        if sInput[i] in [',', '.'] then
        begin
          cFractionSeparator := sInput[i];
          iDecimalPos := i;
        end;

      iDigitsAfterDecimal := Length(sInput) - iDecimalPos;

      iFraction := ToInt(Copy(sInput, iDecimalPos + 1, iDigitsAfterDecimal));

      iInteger := ToInt(Copy(sInput, 1, iDecimalPos - 1));

      Result := iInteger + iFraction / Power(10, iDigitsAfterDecimal);
    end
    else
      Result := StrToInt(input)

  end;

end;

function ToInt(input: Variant): Integer;
begin

  if (VarType(input) = varString) or (VarType(input) = varUString) then
    Result := ToInt(ToFloat(input))
  else if VarType(input) in [varSmallint, varInteger, varInt64, varByte,
    varShortInt] then
    Result := input
  else if VarType(input) in [varSingle, varDouble, varCurrency] then
    if Frac(input) >= 0.5 then
      Result := Trunc(input) + 1
    else
      Result := Trunc(input);

end;

function ToString(input: Variant): String;
begin

  if (VarType(input) = varString) or (VarType(input) = varUString) then
    Result := input
  else if VarType(input) in [varSmallint, varInteger, varInt64, varByte,
    varShortInt] then
    Result := IntToStr(input)
  else if VarType(input) in [varSingle, varDouble, varCurrency] then
    Result := FloatToStr(input)
  else if VarType(input) = varBoolean then
    if input = True then
      Result := 'True'
    else
      Result := 'False';

end;

end.
