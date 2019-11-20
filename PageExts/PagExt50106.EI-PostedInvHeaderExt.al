pageextension 50106 "IE-PostedInvHeaderExt" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Foreign Trade")
        {
            group("E-Invoice")
            {
                field("XML Transaction ID"; "XML Transaction ID")
                {
                    Enabled = true;
                    Editable = true;
                }

                field("Elec. Invoice Stat. Error"; "Elec. Invoice Stat. Error")
                {

                }

                field("Elec. Invoice Stat. Error 2"; "Elec. Invoice Stat. Error 2")
                {

                }

                field("Electronic Invoice Status"; "Electronic Invoice Status")
                {

                }
                field("DIAN Status"; "DIAN Status")
                {
                    ApplicationArea = All;
                }

                field("Shiptment Port"; "Shiptment Port")
                {
                    ApplicationArea = All;
                }

                field("Destination Port"; "Destination Port")
                {
                    ApplicationArea = All;
                }

                field("Gross Weight"; "Gross Weight")
                {
                    ApplicationArea = All;
                }

                field("Shipping Information"; "Shipping Information")
                {
                    ApplicationArea = All;
                }

                field("Net Weight"; "Net Weight")
                {
                    ApplicationArea = All;
                }

                field(EIConcept; EIConcept)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        addafter("&Navigate")
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
                        cu: Codeunit 50100;
                    begin
                        IF ("Electronic Invoice Status" = "Electronic Invoice Status"::" ") OR
                                    (("Electronic Invoice Status" = "Electronic Invoice Status"::"In process") AND ("XML Transaction ID" = '')) OR
                                    ("Electronic Invoice Status" = "Electronic Invoice Status"::Fail)
                                THEN
                            cu.GenerateRecordLink(Rec);
                    end;
                }
                Action("Validate Status")
                {
                    ApplicationArea = All;
                    Caption = 'Validate Status';
                    Image = ValidateEmailLoggingSetup;
                    trigger OnAction();
                    var
                        cu: codeunit 50100;
                        l_opWebServices: Option Upload,DocumentStatus,Download,AvaliableDocument,DownloadDocuments;
                        fileInStream: InStream;
                        l_dnetArray: DotNet NETArray;
                        l_documents: array[40, 2] of Text[20];
                    begin

                        cu.SendMethod(l_opWebServices::DocumentStatus, '', FileInStream, l_dnetArray, "No.", l_documents, 112, 0);
                    end;
                }
                // Action("Download Documents")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Download Documents';
                //     Image = ValidateEmailLoggingSetup;
                //     trigger OnAction();
                //     var
                //         cu: codeunit 50100;
                //         l_opWebServices: Option Upload,DocumentStatus,Download,AvaliableDocument,DownloadDocuments;
                //         fileInStream: InStream;
                //         l_dnetArray: DotNet NETArray;
                //         l_documents: array[40, 2] of Text[20];
                //     begin
                //         cu.SendMethod(l_opWebServices::DownloadDocuments, '', FileInStream, l_dnetArray, "No.", l_documents, 112, 0);
                //     end;
                // }
                Action("Create XML")
                {
                    ApplicationArea = All;
                    Caption = 'Create XML';
                    Image = ValidateEmailLoggingSetup;
                    trigger OnAction();
                    var
                        var_Xml: XmlPort 50100;
                        var_PostedInvoice: record "Sales Invoice Header";
                        var_cheque: report 1401;
                        var_array: array[2] of Text[80];
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        FileOutStream: OutStream;
                        tempBlob: Record TempBlob;
                        FileInStream: InStream;
                        filename: Text[100];
                    begin
                        tempBlob.blob.CreateOutStream(FileOutStream);

                        SalesInvoiceHeader.SETFILTER("No.", rec."No.");
                        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Doc. Type DIAN", '01');
                        IF SalesInvoiceHeader.FINDFIRST THEN
                            XMLPORT.EXPORT(XMLPORT::"EI-ExportLocalInvoice", FileOutStream, SalesInvoiceHeader);
                        //Factura EXP
                        SalesInvoiceHeader.SETFILTER("No.", rec."No.");
                        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Doc. Type DIAN", '02');
                        IF SalesInvoiceHeader.FINDFIRST THEN
                            XMLPORT.EXPORT(XMLPORT::"EI-ExportExportationInvoice", FileOutStream, SalesInvoiceHeader);
                        // Factura NAC
                        SalesInvoiceHeader.SETFILTER("No.", rec."No.");
                        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Doc. Type DIAN", '03');
                        IF SalesInvoiceHeader.FINDFIRST THEN
                            XMLPORT.EXPORT(XMLPORT::"EI-ExportLocalInvoice", FileOutStream, SalesInvoiceHeader);
                        //Factura EXP
                        SalesInvoiceHeader.SETFILTER("No.", rec."No.");
                        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Doc. Type DIAN", '04');
                        IF SalesInvoiceHeader.FINDFIRST THEN
                            XMLPORT.EXPORT(XMLPORT::"EI-ExportLocalInvoice", FileOutStream, SalesInvoiceHeader);
                        //NOTA DEBITO
                        SalesInvoiceHeader.SETFILTER("No.", rec."No.");
                        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Doc. Type DIAN", '92');
                        IF SalesInvoiceHeader.FINDFIRST THEN
                            XMLPORT.EXPORT(XMLPORT::"EI-ExportLocalInvoice", FileOutStream, SalesInvoiceHeader);

                        tempBlob.Blob.CreateInStream(FileInStream);
                        filename := SalesInvoiceHeader."No." + '.xml';
                        DownloadFromStream(FileInStream, '', '', '', filename);
                    end;
                }
            }
        }
    }
}