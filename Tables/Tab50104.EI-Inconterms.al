table 50104 "EI-Incoterms"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Inco Code"; Code[10])
        {
            CaptionML = ENU = 'Code', ESP = 'Código';
        }

        field(2; "Name"; Text[250])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';
        }
    }

    keys
    {
        key(PK; "Inco Code")
        {
            Clustered = true;
        }
    }
}