unit uBigValues;

interface

   uses SysUtils, Math, Dialogs;

   type
         TBigInt = record
                     Items : array of Char;
                     ItemsCount : integer;
                   end;

   function BigInt2Str     ( A    : TBigInt ) : string;
   function Int2BigInt     ( Int  : integer ) : TBigInt;
   function AlignBigInt    ( A    : TBigInt; NeededDigitsCount : integer ) : TBigInt;
   function NextBigInt     ( A    : TBigInt ) : TBigInt; // A + 1
   function PrevBigInt     ( A    : TBigInt ) : TBigInt; // A - 1
   function MaxBigInts     ( A, B : TBigInt; var Index : integer ) : TBigInt; // Max (A , B )
   function MinBigInts     ( A, B : TBigInt; var Index : integer ) : TBigInt; // Min (A , B )
   function SumBigInts     ( A, B : TBigInt ) : TBigInt; // A + B
   function MinusBigInts   ( A, B : TBigInt ) : TBigInt; // A - B
   function MultBigInts    ( A, B : TBigInt ) : TBigInt; // A * B
   function PowerBigInts   ( A, B : TBigInt ) : TBigInt; // A ^ B
   function CompareBigInts ( A, B : TBigInt ) : boolean; // A = B

implementation

uses uMain;

{------------------------------------------------------------------------------}
function BigInt2Str( A : TBigInt ) : string;
  var i : integer;
      tmpResult : string;
      Minus : boolean;
begin
  tmpResult := '';
  for i := 0 to A.ItemsCount - 1 do
    tmpResult := tmpResult + A.Items[ i ];
  if tmpResult = ''
  then begin
         tmpResult := '0';
         Result := tmpResult;
         Exit;
       end;
  Minus := tmpResult[ 1 ] = '-';
  if Minus
  then Delete( tmpResult, 1, 1 );
  if tmpResult = ''
  then tmpResult := '0';
  while tmpResult[ 1 ] = '0' do
    begin
      Delete( tmpResult, 1, 1 );
      if tmpResult = ''
      then break;
    end;
  if Minus
  then tmpResult := '-' + tmpResult;
  if ( tmpResult = '-' ) or ( tmpResult = '' )
  then tmpResult := tmpResult + '0';
  Result := tmpResult;
end;
{------------------------------------------------------------------------------}
function Int2BigInt( Int  : integer ) : TBigInt;
  var strInt : string;
      tmpResult : TBigInt;
      i : integer;
begin
  strInt := IntToStr( Int );
  tmpResult.ItemsCount := Length( strInt );
  SetLength( tmpResult.Items, tmpResult.ItemsCount );
  for i := 0 to tmpResult.ItemsCount - 1 do
    tmpResult.Items[ i ] := strInt[ i + 1 ];
  Result := tmpResult;
end;
{------------------------------------------------------------------------------}
function AlignBigInt( A : TBigInt; NeededDigitsCount : integer ) : TBigInt;
  var i, tmp : integer;
begin
  tmp := A.ItemsCount;
  A.ItemsCount := NeededDigitsCount;
  SetLength( A.Items, A.ItemsCount );

  if NeededDigitsCount > 1
  then begin
         for i := tmp - 1 downto 0 do
           A.Items[ A.ItemsCount - ( tmp - 1 ) + i - 1 ] := A.Items[ i ];

         for i := 0 to A.ItemsCount - tmp - 1 do
           A.Items[ i ] := '0';
       end;

  Result := A;
end;
{------------------------------------------------------------------------------}
function NextBigInt( A : TBigInt ) : TBigInt; // A + 1
begin
  Result := SumBigInts( A, Int2BigInt( 1 ) )
end;
{------------------------------------------------------------------------------}
function PrevBigInt( A : TBigInt ) : TBigInt; // A - 1
begin
  Result := MinusBigInts( A, Int2BigInt( 1 ) )
end;
{------------------------------------------------------------------------------}
function MaxBigInts( A, B : TBigInt; var Index : integer ) : TBigInt; // Max (A , B )
  var tmpA, tmpB : TBigInt;
      i : integer;
begin
  tmpA := A;
  tmpB := B;
{
  if tmpA.ItemsCount <= 0
  then begin
         tmpA.ItemsCount := 1;
         SetLength( tmpA.Items, tmpA.ItemsCount );
         tmpA.Items[ 0 ] := '0';
       end;

  if tmpB.ItemsCount <= 0
  then begin
         tmpB.ItemsCount := 1;
         SetLength( tmpB.Items, tmpB.ItemsCount );
         tmpB.Items[ 0 ] := '0';
       end;

  if ( tmpA.ItemsCount = 1 ) and ( tmpA.Items[ 0 ] = '-' )
  then tmpA.Items[ 0 ] := '0';

  if ( tmpB.ItemsCount = 1 ) and ( tmpB.Items[ 0 ] = '-' )
  then tmpB.Items[ 0 ] := '0';

  if ( tmpA.Items[ 0 ] = '-' ) and ( tmpB.Items[ 0 ] <> '-' )
  then begin
         Index := 2;
         Result := tmpB;
         Exit;
       end;
  if ( tmpA.Items[ 0 ] <> '-' ) and ( tmpB.Items[ 0 ] = '-' )
  then begin
         Index := 1;
         Result := tmpA;
         Exit;
       end;
}
  tmpA := AlignBigInt( tmpA, Max( A.ItemsCount, B.ItemsCount ) );
  tmpB := AlignBigInt( tmpB, tmpA.ItemsCount );

  for i := 0 to tmpA.ItemsCount - 1 do
    if tmpA.Items[ i ] <> tmpB.Items[ i ]
    then begin
           if tmpA.Items[ i ] > tmpB.Items[ i ]
           then begin
                  Index := 1;
                  Result := A;
                  Exit;
                end
           else begin
                  Index := 2;
                  Result := B;
                  Exit;
                end
         end;
end;
{------------------------------------------------------------------------------}
function MinBigInts( A, B : TBigInt; var Index : integer ) : TBigInt; // Min (A , B )
  var tmpA, tmpB : TBigInt;
      i : integer;
begin
  tmpA := A;
  tmpB := B;
{
  if tmpA.ItemsCount <= 0
  then begin
         tmpA.ItemsCount := 1;
         SetLength( tmpA.Items, tmpA.ItemsCount );
         tmpA.Items[ 0 ] := '0';
       end;

  if tmpB.ItemsCount <= 0
  then begin
         tmpB.ItemsCount := 1;
         SetLength( tmpB.Items, tmpB.ItemsCount );
         tmpB.Items[ 0 ] := '0';
       end;

  if ( tmpA.ItemsCount = 1 ) and ( tmpA.Items[ 0 ] = '-' )
  then tmpA.Items[ 0 ] := '0';

  if ( tmpB.ItemsCount = 1 ) and ( tmpB.Items[ 0 ] = '-' )
  then tmpB.Items[ 0 ] := '0';

  if ( tmpA.Items[ 0 ] = '-' ) and ( tmpB.Items[ 0 ] <> '-' )
  then begin
         Index := 1;
         Result := tmpA;
         Exit;
       end;
  if ( tmpA.Items[ 0 ] <> '-' ) and ( tmpB.Items[ 0 ] = '-' )
  then begin
         Index := 2;
         Result := tmpB;
         Exit;
       end;
}
  tmpA := AlignBigInt( tmpA, Max( tmpA.ItemsCount, tmpB.ItemsCount ) );
  tmpB := AlignBigInt( tmpB, tmpA.ItemsCount );

  for i := 0 to tmpA.ItemsCount - 1 do
    if tmpA.Items[ i ] <> tmpB.Items[ i ]
    then begin
           if tmpA.Items[ i ] < tmpB.Items[ i ]
           then begin
                  Index := 1;
                  Result := tmpA;
                  Exit;
                end
           else begin
                  Index := 2;
                  Result := tmpB;
                  Exit;
                end
         end;
end;
{------------------------------------------------------------------------------}
function SumBigInts( A, B : TBigInt ) : TBigInt; // A + B
  var tmpA, tmpB, tmpResult : TBigInt;
      i, Ostatok, SumInt : integer;
      tmpStr : string;
begin
  tmpA := A;
  tmpB := B;
  if tmpA.ItemsCount > tmpB.ItemsCount
  then tmpB := AlignBigInt( tmpB, tmpA.ItemsCount ) // Дополняем B впереди незначащими нулями
  else if tmpB.ItemsCount > tmpA.ItemsCount
       then tmpA := AlignBigInt( tmpA, tmpB.ItemsCount ); // Дополняем A впереди незначащими нулями
  // Теперь число разрядов A и B одинаково
  tmpResult := AlignBigInt( Int2BigInt( 0 ), Max( tmpA.ItemsCount, tmpB.ItemsCount ) );
  Ostatok := 0;
  for i := tmpResult.ItemsCount - 1 downto 0 do
    begin
      SumInt := StrToInt( tmpA.Items[ i ] ) + StrToInt( tmpB.Items[ i ] ) + Ostatok;
      Ostatok := 0;
      tmpStr := IntToStr( SumInt );
      if Length( tmpStr ) = 2
      then begin
             Ostatok := StrToInt( tmpStr[ 1 ] );
             Delete( tmpStr, 1, 1 );
             SumInt := StrToInt( tmpStr );
           end;
      tmpResult.Items[ i ] := IntToStr( SumInt )[ 1 ];
    end;
  if Ostatok > 0
  then begin
         Inc( tmpResult.ItemsCount );
         SetLength( tmpResult.Items, tmpResult.ItemsCount );
         for i := tmpResult.ItemsCount - 1 downto 1 do
           tmpResult.Items[ i ] := tmpResult.Items[ i - 1 ];
         tmpResult.Items[ 0 ] := IntToStr( Ostatok )[ 1 ];
       end;

  Result := tmpResult;
end;
{------------------------------------------------------------------------------}
function MinusBigInts ( A, B : TBigInt ) : TBigInt; // A - B
  var tmpA, tmpB, tmpResult : TBigInt;
      i, Zaem, RaznostInt, IndexMin, IndexMax : integer;
      tmpStr : string;
      NeedChangeSign : boolean;
begin
  if A.Items = B.Items
  then begin
         Result := Int2BigInt( 0 );
         Exit;
       end;

  tmpA := MaxBigInts( A, B, integer(IndexMax) );
  tmpB := MinBigInts( A, B, integer(IndexMin) );

  NeedChangeSign := IndexMax = 2;

  if tmpA.ItemsCount > tmpB.ItemsCount
  then tmpB := AlignBigInt( tmpB, tmpA.ItemsCount ) // Дополняем B впереди незначащими нулями
  else if tmpB.ItemsCount > tmpA.ItemsCount
       then tmpA := AlignBigInt( tmpA, tmpB.ItemsCount ); // Дополняем A впереди незначащими нулями
  // Теперь число разрядов A и B одинаково
  tmpResult := AlignBigInt( Int2BigInt( 0 ), Max( tmpA.ItemsCount, tmpB.ItemsCount ) );
  Zaem := 0;
  for i := tmpResult.ItemsCount - 1 downto 0 do
    begin
      RaznostInt := StrToInt( tmpA.Items[ i ] ) - StrToInt( tmpB.Items[ i ] ) - Zaem;
      if RaznostInt < 0
      then begin
             RaznostInt := RaznostInt + 10;
             Zaem := 1;
           end
      else Zaem := 0;
      tmpStr := IntToStr( RaznostInt );
      if Length( tmpStr ) = 2
      then begin
             Zaem := StrToInt( tmpStr[ 1 ] );
             Delete( tmpStr, 1, 1 );
             RaznostInt := StrToInt( tmpStr );
           end;
      tmpResult.Items[ i ] := IntToStr( RaznostInt )[ 1 ];
    end;
  if NeedChangeSign
  then begin
         Inc( tmpResult.ItemsCount );
         SetLength( tmpResult.Items, tmpResult.ItemsCount );
         for i := tmpResult.ItemsCount - 1 downto 1 do
           tmpResult.Items[ i ] := tmpResult.Items[ i - 1 ];
         tmpResult.Items[ 0 ] := '-';
       end;

  Result := tmpResult;
end;
{------------------------------------------------------------------------------}
function MultBigInts( A, B : TBigInt ) : TBigInt; // A * B
  var tmpA, tmpB, tmpResult, tmpSumma : TBigInt;
      NeedChangeSign : boolean;
      i, j, SummsCount, Perenos, tmpMult : integer;
      tmpMultStr : string;
      SummsArray : array of TBigInt;
begin
  NeedChangeSign := ( ( A.Items[ 0 ] = '-' ) and ( B.Items[ 0 ] <> '-' ) ) or
                    ( ( B.Items[ 0 ] = '-' ) and ( A.Items[ 0 ] <> '-' ) );

  tmpA := A;
  tmpB := B;

  if tmpA.Items[ 0 ] = '-'
  then begin
         for i := 1 to tmpA.ItemsCount - 1 do
           tmpA.Items[ i - 1 ] := tmpA.Items[ i ];
         Dec( tmpA.ItemsCount );
         SetLength( tmpA.Items, tmpA.ItemsCount );
       end;

  if tmpB.Items[ 0 ] = '-'
  then begin
         for i := 1 to tmpA.ItemsCount - 1 do
           tmpB.Items[ i - 1 ] := tmpB.Items[ i ];
         Dec( tmpB.ItemsCount );
         SetLength( tmpB.Items, tmpB.ItemsCount );
       end;

  tmpResult := AlignBigInt( Int2BigInt( 0 ), Max( tmpA.ItemsCount, tmpB.ItemsCount ) );

  // tmpA - множимое
  // tmpB - множитель

  // Составляем массив сумм (без сдвига)

  SummsCount := 0;

  for i := tmpB.ItemsCount - 1 downto 0 do
    begin
      tmpSumma.ItemsCount := tmpA.ItemsCount;
      SetLength( tmpSumma.Items, tmpSumma.ItemsCount );
      Perenos := 0;
      for j := tmpA.ItemsCount - 1 downto 0 do
        begin
          tmpMult := StrToInt( tmpA.Items[ j ] ) * StrToInt( tmpB.Items[ i ] ) + Perenos;
          tmpMultStr := IntToStr( tmpMult );
          tmpSumma.Items[ j ] := tmpMultStr[ Length( tmpMultStr ) ];
          if Length( tmpMultStr ) > 1
          then begin
                 Delete( tmpMultStr, Length( tmpMultStr ), 1 );
                 Perenos := StrToInt( tmpMultStr );
               end
          else Perenos := 0;
        end;
      if Perenos > 0
      then begin
             Inc( tmpSumma.ItemsCount, Length( IntToStr( Perenos ) ) );
             SetLength( tmpSumma.Items, tmpSumma.ItemsCount );
             for j := tmpSumma.ItemsCount - 1 downto Length( IntToStr( Perenos ) ) do
               tmpSumma.Items[ j ] := tmpSumma.Items[ j - Length( IntToStr( Perenos ) ) ];
             for j := 0 to Length( IntToStr( Perenos ) ) - 1 do
               tmpSumma.Items[ j ] := IntToStr( Perenos )[ j + 1 ];
           end;

      Inc( SummsCount );
      SetLength( SummsArray, SummsCount );
      SummsArray[ SummsCount - 1 ] := tmpSumma;
    end;

  // Сдвигаем массивы сумм в зависимости от этажа (кол-во этажей - длина числа tmpB)

  if tmpB.ItemsCount > 1
  then begin
         for i := 0 to SummsCount - 1 do
           begin
             Inc( SummsArray[ i ].ItemsCount, i );
             SetLength( SummsArray[ i ].Items, SummsArray[ i ].ItemsCount );
             for j := SummsArray[ i ].ItemsCount - 1 downto SummsArray[ i ].ItemsCount - i do
               SummsArray[ i ].Items[ j ] := '0';
           end;

         tmpResult := SummsArray[ 0 ];
         for i := 1 to SummsCount - 1 do
           begin
             tmpResult := SumBigInts( tmpResult, SummsArray[ i ] )
           end;
       end
  else tmpResult := SummsArray[ 0 ];


  if NeedChangeSign
  then begin
         Inc( tmpResult.ItemsCount );
         SetLength( tmpResult.Items, tmpResult.ItemsCount );
         for i := tmpResult.ItemsCount - 1 downto 1 do
           tmpResult.Items[ i ] := tmpResult.Items[ i - 1 ];
         tmpResult.Items[ 0 ] := '-';
       end;

  Result := tmpResult;
end;
{------------------------------------------------------------------------------}
function PowerBigInts ( A, B : TBigInt ) : TBigInt;
  var {PowerCounter,} tmpResult : TBigInt;
      PowerCounter : integer;
begin
  PowerCounter := StrToInt( BigInt2Str( B ) );//B;//NextBigInt( B );
  tmpResult := A;
  Repeat
//    showMessage( 'PowerCounter = ' + BigInt2Str(PowerCounter) );
    tmpResult := MultBigInts( tmpResult, A );
//    PowerCounter := PrevBigInt( PowerCounter );

    Dec( PowerCounter );

{    if PowerCounter.ItemsCount = 1
    then if PowerCounter.Items[ 0 ] = '1'
         then break;}

     if PowerCounter = 1
     then break;    
  Until FALSE;
  Result := tmpResult;
end;
{------------------------------------------------------------------------------}
function CompareBigInts ( A, B : TBigInt ) : boolean; // A = B
  var i : integer;
begin
  if A.ItemsCount <> B.ItemsCount
  then begin
         result := FALSE;
         exit;
       end;
  result := TRUE;
  for i := 0 to A.ItemsCount - 1 do
    if A.Items[ i ] <> B.Items[ i ]
    then begin
           result := FALSE;
           exit;
         end;
end;
{------------------------------------------------------------------------------}

end.
