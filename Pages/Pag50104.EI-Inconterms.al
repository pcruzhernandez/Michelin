page 50104 "EI-Incoterms"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "EI-Incoterms";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Inco Code"; "Inco Code")
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