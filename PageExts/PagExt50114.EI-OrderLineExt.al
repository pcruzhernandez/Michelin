pageextension 50114 "IE-OrderLineExt" extends "Sales Order Subform"
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