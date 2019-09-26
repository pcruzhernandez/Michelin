pageextension 50103 "EI-ShipmentMethodExt" extends "Shipment Methods"
{
    layout
    {
        addafter(Description)
        {
            field(Incoterm; Incoterm)
            {
                ApplicationArea = All;
            }
        }
    }

}