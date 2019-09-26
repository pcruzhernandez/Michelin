codeunit 50102 "FAE-Subscriber"
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeFinalizePosting', '', true, true)]
    procedure fncFAEAutomaticoFactura(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        EISetup: Record 50100;
        l_cuWSSend: Codeunit 50100;
    begin
        EISetup.GET();
        if EISetup."Send FAE Automatic" then begin
            if SalesCrMemoHeader."No." <> '' then
                l_cuWSSend.GenerateRecordLink(SalesCrMemoHeader);
            if SalesInvoiceHeader."No." <> '' then
                l_cuWSSend.GenerateRecordLink(SalesInvoiceHeader);

        end;
    end;
}