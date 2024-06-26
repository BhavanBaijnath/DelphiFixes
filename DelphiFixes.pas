unit DelphiFixes;

{ Version: 1.0.3 - 26 June 2024
  Updates on GitHub: https://github.com/BhavanBaijnath/DelphiFixes

  Created by Bhavan Baijnath, a Gr11 student who finds Delphi's incompetency and complexity incredible frustrating.

  ToStr(), ToInt(), ToFloat():
  - These custom functions are designed to help speed up typecasting
  - Any type of variable can be inputted into these functions and (hopefully) the correct type will be outputted

  RemoveCharacter() & RemoveManyCharacters():
  - As the name suggests, they remove characters.
  - RemoveCharacter() inputs a single character and the string to be processed, aswell as a boolean for case sensitive
  - RemoveManyCharacters() is the same as RemoveCharacter() except a string of the characters to remove is inputted rather than a character

  LocalFilePath():
  - LocalFilePath() will output the complete file path for the file inputted (assuming the file is in the same folder or in a sub folder found in the projects folder)

  eg. Your project is stored in 'C:\Delphi Projects\':
  LocalFilePath('image.png') will return 'C:\Delphi Projects\image.png'
  LocalFilePath('Images\image.png') will return 'C:\Delphi Projects\Images\image.png'

  Notable things:
  - If a float is inputted into ToInt(), it will be correctly rounded off (Unlike the default Round() function)
  - ToFloat() will work with both commas and decimals and (hopefully) won't cause any errors
  (The other weird Windows formatting for decimals probably won't work though)
  - For RemoveManyCharacters() the list of characters must be inputted as a string

  Enjoy
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Math;

function ToStr(input: Variant): String;
function ToInt(input: Variant): Integer;
function ToFloat(input: Variant): Real;
procedure RemoveCharacter(cChar: char; var sString: String;
  bCaseSensitive: Boolean);
procedure RemoveManyCharacters(sChars: String; var sString: String;
  bCaseSensitive: Boolean);
function FilePath(sLocalPath: String): String;

implementation

function ToFloat(input: Variant): Real;
var
  i, iDecimalPos: Integer;
  cFractionSeparator: char;
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

    for i := 1 to Length(sInputTemp) do
      // Removes any characters that could cause errors
      if ((sInputTemp[i] in ['0' .. '9']) or (sInputTemp[i] in [',', '.'])) then
      begin
        sInput := sInput + sInputTemp[i];
      end;

    if not((Pos(',', sInputTemp) = 0) and (Pos('.', sInputTemp) = 0)) then
    begin

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
    begin

      sInput := input;
      RemoveCharacter(' ', sInput, False);

      Result := StrToInt(sInput)

    end;

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

function ToStr(input: Variant): String;
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

procedure RemoveCharacter(cChar: char; var sString: String;
  bCaseSensitive: Boolean);
var
  i: Integer;
  sResult, sStringCase: String;
begin

  if not bCaseSensitive then
  begin
    cChar := UpCase(cChar);
    sStringCase := UpperCase(sString);
  end
  else
    sStringCase := sString;

  sResult := '';

  for i := 1 to Length(sString) do
    if sStringCase[i] <> cChar then
      sResult := sResult + sString[i];

  sString := sResult;

end;

procedure RemoveManyCharacters(sChars: String; var sString: String;
  bCaseSensitive: Boolean);
var
  i: Integer;
  sResult: String;
begin

  sResult := sString;

  { for i := 1 to Length(sString) do
    if sString[i] in arrChars then
    sResult := sResult + sString[i]; }

  for i := 1 to Length(sChars) do
  begin
    RemoveCharacter(sChars[i], sResult, bCaseSensitive)
  end;

  sString := sResult;

end;

function FilePath(sLocalPath: String): String;

var
  i: Integer;

begin

  sLocalPath := Trim(sLocalPath);

  if sLocalPath[1] in ['\', '/'] then
    Delete(sLocalPath, 1, 1);

  for i := 1 to Length(sLocalPath) do
    if sLocalPath[i] = '/' then
      sLocalPath[i] := '\';

  Result := ExtractFilePath(Application.ExeName) + sLocalPath;

end;

end.
