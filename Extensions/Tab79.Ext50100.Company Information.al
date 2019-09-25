tableextension 50100 "FAE-Company Information" extends 79
{
    fields
    {
        field(50100; "Electronic Invoice Company ID"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Elec. Inv. Account ID"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Electronic Invoice User"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Electronic Invoice Pass"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Use Proxy"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50105; Proxy; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50106; Port; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50107; "Electronic Invoice Endpoint"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50108; "Electronic Invoice Path"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(50109; "Send FAE Automatic"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
    }
}