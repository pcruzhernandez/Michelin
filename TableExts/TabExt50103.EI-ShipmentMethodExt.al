tableextension 50103 "EI-ShiptmentMethodExt" extends "Shipment Method"
{
    fields
    {
        field(50100; Incoterm; Code[10])
        {
            TableRelation = "EI-Incoterms";
        }
    }
}