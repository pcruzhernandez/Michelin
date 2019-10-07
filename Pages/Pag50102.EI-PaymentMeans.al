page 50102 "EI-PaymentMeans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "EI-PaymentMeans";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PM Code"; "PM Code")
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