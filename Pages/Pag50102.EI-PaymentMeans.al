page 50102 "EI-PaymentMeans"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "EI-PaymentMeans";

    layout
    {
        area(Content)
        {
            group(GroupName)
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