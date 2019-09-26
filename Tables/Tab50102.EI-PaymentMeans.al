table 50102 "EI-PaymentMeans"
{
    DataClassification = CustomerContent;
    CaptionML = ENU = 'EI- Payment Menas', ESP = 'FE- Métodos de Pago';

    fields
    {
        field(1; "PM Code"; Code[10])
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
        key(PK; "PM Code")
        {
            Clustered = true;
        }
    }
}