page 50103 "EI-UnitOfMeasure"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "EI-UnitOfMeasure";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("UOM Code"; "UOM Code")
                {
                    ApplicationArea = All;
                }

                field(Name; Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}