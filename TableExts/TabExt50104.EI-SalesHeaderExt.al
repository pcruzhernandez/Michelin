tableextension 50104 "EI-SalesHeaderExt" extends "Sales Header"
{
    fields
    {
        field(50100; "Shiptment Port"; Text[100]) { }

        field(50101; "Destination Port"; Text[100]) { }

        field(50102; "Gross Weight"; Text[50]) { }

        field(50103; "Shipping Information"; Text[100]) { }

        field(50104; "Net Weight"; Text[50]) { }

        field(50105; EIConcept; Text[50])
        {
            CaptionML = ENU = 'Concept', ESP = 'Concept';
        }
    }
}