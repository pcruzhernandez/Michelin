tableextension 50101 "EI-PaymentMethodExt" extends "Payment Method"
{
    fields
    {
        field(50100; "Payment Means"; code[10])
        {
            TableRelation = "EI-PaymentMeans";
        }

        field(50101; Credit; Boolean) { }
    }
}