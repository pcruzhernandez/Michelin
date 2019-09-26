pageextension 50104 "IE-InvoiceHeaderExt" extends "Sales Invoice"
{
    layout
    {
        addafter("Foreign Trade")
        {
            group("E-Invoice")
            {
                field("Shiptment Port"; "Shiptment Port")
                {
                    ApplicationArea = All;
                    Editable = DocTypeIs02;
                }

                field("Destination Port"; "Destination Port")
                {
                    ApplicationArea = All;
                    Editable = DocTypeIs02;
                }

                field("Gross Weight"; "Gross Weight")
                {
                    ApplicationArea = All;
                    Editable = DocTypeIs02;
                }

                field("Shipping Information"; "Shipping Information")
                {
                    ApplicationArea = All;
                    Editable = DocTypeIs02;
                }

                field("Net Weight"; "Net Weight")
                {
                    ApplicationArea = All;
                    Editable = DocTypeIs02;
                }

                field(EIConcept; EIConcept)
                {
                    ApplicationArea = All;
                    Editable = ConceptEditable;
                }
            }
        }
    }

    var
        DocTypeIs02: Boolean;
        ConceptEditable: Boolean;

        /*local procedure DocType()
        var
            myInt: Integer;
        begin
            if  Location = 02 then
                DocTypeIs02 = true
            else begin
                DocTypeIs02 = false;
                if (Location = 91) or (Location = 92) then
                    ConceptEditable = true
                else
                    ConceptEditable = false;
            end;
        end;
        */
}