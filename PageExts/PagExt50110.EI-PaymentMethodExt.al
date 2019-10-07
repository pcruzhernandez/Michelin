pageextension 50110 "IE-PaymentMethod" extends "Payment Methods"
{
    layout
    {
        addafter("Bal. Account Type")
        {
            field("Payment Means"; "Payment Means")
            {
                ApplicationArea = All;
            }
            field(Credit; Credit)
            {
                ApplicationArea = All;
            }
        }
    }
}