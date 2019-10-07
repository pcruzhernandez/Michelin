page 50101 "IE-StandardProduct"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "EI-StandardProduct";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; "Code")
                {
                    ApplicationArea = All;
                }

                field(Name; Name)
                {
                    ApplicationArea = All;
                }

                field("Agency ID"; "Agency ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}