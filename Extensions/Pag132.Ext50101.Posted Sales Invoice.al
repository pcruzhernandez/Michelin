// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50101 "FAE-Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Foreign Trade")
        {
            group("Electronic Invoice ")
            {
                field("XML Transaction ID"; "XML Transaction ID")
                {

                }
                field("Electronic Invoice Status"; "Electronic Invoice Status")
                {

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
                Action("Download Documents")
                {
                    ApplicationArea = All;
                    Caption = 'Download Documents';
                    Image = ValidateEmailLoggingSetup;
                    trigger OnAction();
                    var
                        cu: codeunit 50100;
                        l_opWebServices: Option Upload,DocumentStatus,Download,AvaliableDocument,DownloadDocuments;
                        fileInStream: InStream;
                        l_dnetArray: DotNet NETArray;
                        l_documents: array[40, 2] of Text[20];
                    begin
                        cu.SendMethod(l_opWebServices::DownloadDocuments, '', FileInStream, l_dnetArray, "No.", l_documents, 112, 0);
                    end;
                }
            }
        }
    }
}