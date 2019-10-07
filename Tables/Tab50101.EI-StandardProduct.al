table 50101 "EI-StandardProduct"
{
    DataClassification = CustomerContent;
    CaptionML = ENU = 'EI - Standard Product', ESP = 'FE - Producto Estandar';

    fields
    {
        field(1; "Code"; Code[10])
        {

        }

        field(2; Name; Text[250])
        {

        }

        field(3; "Agency ID"; Text[10])
        {

        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}