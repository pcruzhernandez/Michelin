pageextension 50105 "IE-CrMemoHeaderExt" extends "Sales Credit Memo"
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
                }

                field("Destination Port"; "Destination Port")
                {
                    ApplicationArea = All;
                }

                field("Gross Weight"; "Gross Weight")
                {
                    ApplicationArea = All;
                }

                field("Shipping Information"; "Shipping Information")
                {
                    ApplicationArea = All;
                }

                field("Net Weight"; "Net Weight")
                {
                    ApplicationArea = All;
                }

                field(EIConcept; EIConcept)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        myInt: Integer;
}