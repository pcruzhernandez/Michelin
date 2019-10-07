table 50100 "EI-Setup"
{
    DataClassification = CustomerContent;
    CaptionML = ENU = 'EI - Setup', ESP = 'FE - Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {

        }

        field(2; Enviroment; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Production,Test;
            OptionCaptionML = ENU = 'Production,Test', ESP = 'Producción,Test';
            Description = 'Definition of the environment for which the XML will be sent.';
            //ToolTip = 'Definition of the environment for which the XML will be sent.';
        }

        field(3; "Taxpayer Obligation"; Text[250])
        {
            DataClassification = CustomerContent;
        }

        field(4; "Product Standard"; Code[20])
        {
            TableRelation = "EI-StandardProduct";
        }

        field(5; TEXT1; Text[250])
        {

        }

        field(6; TEXT2; Text[250])
        {

        }

        field(7; TEXT3; Text[250])
        {

        }

        field(8; TEXT4; Text[250])
        {

        }

        field(9; TEXT5; Text[250])
        {

        }

        field(10; "UBL Version"; Text[10])
        {

        }

        field(11; "DIAN VERSION"; Text[10])
        {

        }

        field(12; "Fiscal Regime"; Text[10])
        {

        }

        field(13; "Export Observations"; Text[250])
        {

        }

        field(14; "Export Expense 1"; Text[50])
        {

        }

        field(15; "Export Expense 2"; Text[50])
        {

        }
        field(16; "Electronic Invoice Company ID"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Elec. Inv. Account ID"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Electronic Invoice User"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Electronic Invoice Pass"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Use Proxy"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; Proxy; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Port; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Electronic Invoice Endpoint"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Electronic Invoice Path"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(25; "Send EI Automatic"; Boolean)
        {
            DataClassification = ToBeClassified;

        }

        field(26; TEXT6; Text[250])
        {

        }

        field(27; TEXT7; Text[250])
        {

        }

        field(28; "Export Expense 3"; Text[50])
        {

        }

        field(29; "Export Expense 4"; Text[50])
        {

        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}