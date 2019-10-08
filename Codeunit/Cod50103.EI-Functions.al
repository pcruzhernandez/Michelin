codeunit 50103 Functions
{
    procedure FormatNoText(var NoText: Array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        DecimalPosition: Decimal;
        DecimalText: Array[2] of Text[80];
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';
        GLSetup.GET;

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        IF No <> 0 THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
            DecimalPosition := GetAmtDecimalPosition;
            FormatNoText(DecimalText, No * DecimalPosition, '');
            AddToNoText(NoText, NoTextIndex, PrintExponent, DecimalText[1]);
        END;

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    var
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    local procedure GetAmtDecimalPosition(): Decimal
    var
        Currency: Record Currency;
    begin
        IF GenJnlLine."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(GenJnlLine."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
        EXIT(1 / Currency."Amount Rounding Precision");
    end;

    var
        Text026: TextConst ENU = 'ZERO';
        Text027: TextConst ENU = 'HUNDRED';
        Text028: TextConst ENU = 'AND';
        Text029: TextConst ENU = '%1 results in a written number that is too long.';
        Text032: TextConst ENU = 'ONE';
        Text033: TextConst ENU = 'TWO';
        Text034: TextConst ENU = 'THREE';
        Text035: TextConst ENU = 'FOUR';
        Text036: TextConst ENU = 'FIVE';
        Text037: TextConst ENU = 'SIX';
        Text038: TextConst ENU = 'SEVEN';
        Text039: TextConst ENU = 'EIGHT';
        Text040: TextConst ENU = 'NINE';
        Text041: TextConst ENU = 'TEN';
        Text042: TextConst ENU = 'ELEVEN';
        Text043: TextConst ENU = 'TWELVE';
        Text044: TextConst ENU = 'THIRTEEN';
        Text045: TextConst ENU = 'FOURTEEN';
        Text046: TextConst ENU = 'FIFTEEN';
        Text047: TextConst ENU = 'SIXTEEN';
        Text048: TextConst ENU = 'SEVENTEEN';
        Text049: TextConst ENU = 'EIGHTEEN';
        Text050: TextConst ENU = 'NINETEEN';
        Text051: TextConst ENU = 'TWENTY';
        Text052: TextConst ENU = 'THIRTY';
        Text053: TextConst ENU = 'FORTY';
        Text054: TextConst ENU = 'FIFTY';
        Text055: TextConst ENU = 'SIXTY';
        Text056: TextConst ENU = 'SEVENTY';
        Text057: TextConst ENU = 'EIGHTY';
        Text058: TextConst ENU = 'NINETY';
        Text059: TextConst ENU = 'THOUSAND';
        Text060: TextConst ENU = 'MILLION';
        Text061: TextConst ENU = 'BILLION';

        GLSetup: Record "General Ledger Setup";
        GenJnlLine: Record "Gen. Journal Line";
        OnesText: array[20] of Text[100];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
}