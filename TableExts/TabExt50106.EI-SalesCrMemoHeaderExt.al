tableextension 50106 "EI-SalesCrMemoHeaderExt" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50100; "DIAN Status"; code[20]) { }

        field(50101; "Shiptment Port"; Text[100]) { }

        field(50102; "Destination Port"; Text[100]) { }

        field(50103; "Gross Weight"; Text[50]) { }

        field(50104; "Shipping Information"; Text[100]) { }

        field(50105; "Net Weight"; Text[50]) { }

        field(50106; EIConcept; Text[50])
        {
            CaptionML = ENU = 'Concept', ESP = 'Concept';
        }
        field(50107; "XML Transaction ID"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50108; "Electronic Invoice Status"; Option)
        {
            OptionCaption = ' ,Accepted,Rejected,In process,Fail';
            OptionMembers = " ",Accepted,Rejected,"In process",Fail;

        }

        field(50109; "Elec. Invoice Stat. Error"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "Elec. Invoice Stat. Error 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }
}