table 50101 "EI-StandardProduct"
{
    DataClassification = CustomerContent;
    CaptionML = ENU = 'EI - Standard Product', ESP = 'FE - Producto Estandar';

    fields
    {
        field(1; Number; integer)
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
            TableRelation = Item;
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

        field(16; "Export Expense 3"; Text[50])
        {

        }

        field(17; "Export Expense 4"; Text[50])
        {

        }
    }

    keys
    {
        key(PK; Number)
        {
            Clustered = true;
        }
    }
}