pageextension 50112 "EI-CustomerCardExt" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(Invoicing)
        {
            field("Fiscal Responsabilities"; "Fiscal Responsabilities")
            {
                ApplicationArea = All;
            }

            field("Fiscal Regime"; "Fiscal Regime")
            {
                ApplicationArea = All;
            }
        }
    }
}