pageextension 50100 "FAE-Company Information" extends "Company Information"
{
    layout
    {
        addafter("System Indicator")
        {
            group("Electronic Invoice")
            {
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
            }
        }
    }
}