tableextension 50102 "FAE-Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50100; "XML Transaction ID"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Electronic Invoice Status"; Option)
        {
            OptionCaption = 'Accepted,Rejected,In process,Fail';
            OptionMembers = Accepted,Rejected,"In process",Fail;
            DataClassification = ToBeClassified;

        }

        field(50102; "Elec. Invoice Stat. Error"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Elec. Invoice Stat. Error 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }
}