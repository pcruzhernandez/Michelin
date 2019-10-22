// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50115 "FAE-Posted Sales List" extends "Posted Sales Invoices"
{
    layout
    {
        addafter(Control1)
        {
            field("XML Transaction ID"; "XML Transaction ID")
            {

            }
            field("Electronic Invoice Status"; "Electronic Invoice Status")
            {

            }

        }
    }

    actions
    {
        addafter(Invoice)
        {
            group("Electronic Invoice")
            {
                Image = ElectronicVATExemption;
                Action("Send Electronic Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Send Electronic Invoice';
                    Image = TransmitElectronicDoc;
                    trigger OnAction();
                    var
                        l_recSalesInvoiceHeader: Record 112;
                        l_cuFAEWSSend: Codeunit 50100;

                    begin
                        CurrPage.SETSELECTIONFILTER(l_recSalesInvoiceHeader);
                        IF l_recSalesInvoiceHeader.FINDSET() THEN begin
                            REPEAT
                                IF (l_recSalesInvoiceHeader."Electronic Invoice Status" = l_recSalesInvoiceHeader."Electronic Invoice Status"::" ") OR
                                    ((l_recSalesInvoiceHeader."Electronic Invoice Status" = l_recSalesInvoiceHeader."Electronic Invoice Status"::"In process") AND (l_recSalesInvoiceHeader."XML Transaction ID" = '')) OR
                                    (l_recSalesInvoiceHeader."Electronic Invoice Status" = l_recSalesInvoiceHeader."Electronic Invoice Status"::Fail)
                                THEN
                                    l_cuFAEWSSend.GenerateRecordLink(l_recSalesInvoiceHeader);
                            UNTIL l_recSalesInvoiceHeader.NEXT() = 0;
                        END;
                    end;
                }
                Action("Validate Status")
                {
                    ApplicationArea = All;
                    Caption = 'Validate Status';
                    Image = ValidateEmailLoggingSetup;
                    trigger OnAction();
                    var
                        l_recSalesInvoiceHeader: Record 112;
                        l_cuFAEWSSend: codeunit 50100;
                        l_opWebServices: Option Upload,DocumentStatus,Download,AvaliableDocument,DownloadDocuments;
                        fileInStream: InStream;
                        l_dnetArray: DotNet NETArray;
                        l_documents: array[40, 2] of Text[20];

                    begin
                        CurrPage.SETSELECTIONFILTER(l_recSalesInvoiceHeader);
                        IF l_recSalesInvoiceHeader.FINDSET THEN BEGIN
                            REPEAT
                                IF (l_recSalesInvoiceHeader."Electronic Invoice Status" = l_recSalesInvoiceHeader."Electronic Invoice Status"::" ") OR
                                    ((l_recSalesInvoiceHeader."Electronic Invoice Status" = l_recSalesInvoiceHeader."Electronic Invoice Status"::"In process") AND (l_recSalesInvoiceHeader."XML Transaction ID" = '')) OR
                                    (l_recSalesInvoiceHeader."Electronic Invoice Status" = l_recSalesInvoiceHeader."Electronic Invoice Status"::Fail)
                                THEN
                                    l_cuFAEWSSend.SendMethod(l_opWebServices::DocumentStatus, '', FileInStream, l_dnetArray, "No.", l_documents, 112, 0);
                            UNTIL l_recSalesInvoiceHeader.NEXT = 0;
                        end;

                    end;
                }
            }
        }
    }
}