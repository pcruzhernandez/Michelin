table 50103 "EI-UnitOfMeasure"
{
    DataClassification = CustomerContent;
    CaptionML = ENU = 'EI- Unit Of Measure', ESP = 'FE- Unidades de Medida';

    fields
    {
        field(1; "UOM Code"; Code[10])
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
        key(PK; "UOM Code")
        {
            Clustered = true;
        }
    }
}