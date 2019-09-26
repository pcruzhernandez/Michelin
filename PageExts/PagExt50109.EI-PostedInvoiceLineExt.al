pageextension 50109 "IE-PostedInvoiceLineExt" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field(Freight; Freight)
            {
                ApplicationArea = All;
            }

            field("Other Expenses"; "Other Expenses")
            {
                ApplicationArea = All;
            }

            field("International Freight"; "International Freight")
            {
                ApplicationArea = All;
            }

            field(Insurance; Insurance)
            {
                ApplicationArea = All;
            }
        }
    }
}