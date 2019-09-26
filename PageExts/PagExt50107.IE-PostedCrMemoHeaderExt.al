pageextension 50107 "IE-PostedCrMemoHeaderExt" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Bill-to")
        {
            group("E-Invoice")
            {
                field("DIAN Status"; "DIAN Status")
                {
                    ApplicationArea = All;
                }

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
}