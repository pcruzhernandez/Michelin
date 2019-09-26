tableextension 50107 "SalesLineExt" extends "Sales Line"
{
    fields
    {
        field(50100; Freight; Boolean) { }

        field(50101; "Other Expenses"; Boolean) { }

        field(50102; "International Freight"; Boolean) { }

        field(50103; Insurance; Boolean) { }
    }
}