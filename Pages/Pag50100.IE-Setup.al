page 50100 "IE-Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "EI-Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Enviroment; Enviroment)
                {
                    ApplicationArea = All;
                }

                field("Taxpayer Obligation"; "Taxpayer Obligation")
                {
                    ApplicationArea = All;
                }

                field("Product Standard"; "Product Standard")
                {
                    ApplicationArea = All;
                }

                field(TEXT1; TEXT1)
                {
                    ApplicationArea = All;
                }

                field(TEXT2; TEXT2)
                {
                    ApplicationArea = All;
                }

                field(TEXT3; TEXT3)
                {
                    ApplicationArea = All;
                }

                field(TEXT4; TEXT4)
                {
                    ApplicationArea = All;
                }

                field(TEXT5; TEXT5)
                {
                    ApplicationArea = All;
                }

                field("UBL Version"; "UBL Version")
                {
                    ApplicationArea = All;
                }

                field("DIAN VERSION"; "DIAN VERSION")
                {
                    ApplicationArea = All;
                }

                field("Fiscal Regime"; "Fiscal Regime")
                {
                    ApplicationArea = All;
                }

                field("Export Observations"; "Export Observations")
                {
                    ApplicationArea = All;
                }

                field("Export Expense 1"; "Export Expense 1")
                {
                    ApplicationArea = All;
                }

                field("Export Expense 2"; "Export Expense 2")
                {
                    ApplicationArea = All;
                }
                field("Electronic Invoice Company ID"; "Electronic Invoice Company ID")
                {

                }
                field("Elec. Inv. Account ID"; "Elec. Inv. Account ID")
                {

                }
                field("Electronic Invoice User"; "Electronic Invoice User")
                {

                }
                field("Electronic Invoice Pass"; "Electronic Invoice Pass")
                {
                    ExtendedDatatype = Masked;
                }

                field("Electronic Invoice Endpoint"; "Electronic Invoice Endpoint")
                {

                }
                field("Electronic Invoice Path"; "Electronic Invoice Path")
                {

                }
                field("Use Proxy"; "Use Proxy")
                {

                }
                field(Proxy; Proxy)
                {

                }
                field(Port; Port)
                {

                }
                field("Send FAE Automatic"; "Send FAE Automatic")
                {

                }
            }
        }
    }
}