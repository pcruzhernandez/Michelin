codeunit 50102 "FAE-Subscriber"
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    procedure fncIEValidaciones(var SalesHeader: Record "Sales Header")
    var
        l_cuWSSend: Codeunit 50100;
    begin
        l_cuWSSend.Validations(SalesHeader."No.");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    procedure fncIEAutomaticoFactura(SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: code[20])
    var
        EISetup: Record 50100;
        l_cuWSSend: Codeunit 50100;
        l_recSalesInvoice: Record 112;
        l_recCrMeno: Record 114;
    begin
        EISetup.GET();
        if EISetup."Send EI Automatic" then begin
            if SalesCrMemoHdrNo <> '' then begin
                l_recCrMeno.GET(SalesCrMemoHdrNo);
                l_cuWSSend.GenerateRecordLink(l_recCrMeno);
            end;
            if SalesInvHdrNo <> '' then begin
                l_recSalesInvoice.GET(SalesInvHdrNo);
                l_cuWSSend.GenerateRecordLink(l_recSalesInvoice);
            end;
        end;
    end;


}