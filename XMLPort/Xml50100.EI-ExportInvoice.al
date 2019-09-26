xmlport 50100 "EI-ExportInvoice"
{
    Format = Xml;

    schema
    {
        textelement(Factura)
        {
            tableelement(ENC; "Sales Invoice Header")
            {
                textelement(ENC_1)
                {
                    XmlName = 'ENC';

                    trigger OnBeforePassVariable()
                    begin
                        if ENC."Doc. Type DIAN" in ['01', '02', '03', '04'] then
                            ENC_1 := 'INVOIC'
                        ELSE BEGIN
                            if ENC."Doc. Type DIAN" = '91' then
                                ENC_1 := 'NC'
                            else
                                ENC_1 := 'ND';
                        END;
                    end;
                }

                textelement(ENC_2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_2 := DelChr(CompanyInfo."VAT Registration No.", '=', '.-');
                    end;
                }

                textelement(ENC_3)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_3 := DelChr(Customer."VAT Registration No.", '=', '.-');
                    end;
                }

                textelement(ENC_4)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_4 := EISetup."UBL Version";
                    end;
                }

                textelement(ENC_5)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_5 := EISetup."DIAN VERSION";
                    end;
                }

                textelement(ENC_6)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_6 := ENC."No.";
                    end;
                }

                textelement(ENC_7)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_7 := format(ENC."Posting Date", 0, '<Year4><Month,2><Day,2>');
                    end;
                }

                textelement(ENC_8)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_8 := format(time);
                    end;
                }

                textelement(ENC_9)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_9 := ENC."Doc. Type DIAN";
                    end;
                }

                textelement(ENC_10)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_10 := Currency."Coin ISO 4217";
                    end;
                }

                textelement(ENC_15)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_15 := format(DocNumberOfLines(ENC."No."));
                    end;
                }

                textelement(ENC_16)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_16 := format(ENC."Due Date", 0, '<Year4><Month,2><Day,2>');
                    end;
                }

                textelement(ENC_20)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ENC_20 := format(EISetup.Enviroment);
                    end;
                }

                textelement(ENC_21)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if ENC."Doc. Type DIAN" = '02' then
                            ENC_21 := '04'
                        else
                            ENC_21 := '02';
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(Customer);
                    Customer.get(ENC."Sell-to Customer No.");

                    Clear(PostCodeCustomer);
                    PostCodeCustomer.Get(Customer."Post Code");

                    clear(CountryRegionCustomer);
                    CountryRegionCustomer.Get(Customer."Country/Region Code");

                    Clear(Currency);
                    Currency.get(ENC."Currency Code");
                end;

            }
            textelement(EMI)
            {
                textelement(EMI_1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_1 := CompanyInfo."Emisor Type";
                    end;
                }

                textelement(EMI_2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_2 := DelChr(CompanyInfo."VAT Registration No.", '=', '.-');
                    end;
                }

                textelement(EMI_3)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_3 := CompanyInfo."Document Type";
                    end;
                }

                textelement(EMI_4)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_4 := EISetup."Fiscal Regime";
                    end;
                }

                textelement(EMI_6)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_6 := CompanyInfo.Name;
                    end;
                }

                textelement(EMI_7)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_7 := CompanyInfo.Name;
                    end;
                }

                textelement(EMI_10)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_10 := CompanyInfo.Address;
                    end;
                }

                textelement(EMI_11)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_11 := PostCodeCompanyInfo."Department Code DANE";
                    end;
                }

                textelement(EMI_13)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_13 := PostCodeCompanyInfo."Municipality Code DANE";
                    end;
                }

                textelement(EMI_14)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_14 := CompanyInfo."Post Code";
                    end;
                }

                textelement(EMI_15)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_15 := CountryRegionCompanyInfo."Country/Region Code DIAN";
                    end;
                }

                textelement(EMI_19)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_19 := PostCodeCompanyInfo."Department Code DANE";
                    end;
                }

                textelement(EMI_21)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_21 := CountryRegionCompanyInfo."Country/Region Code DIAN";
                    end;
                }

                textelement(EMI_22)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_22 := CompanyInfo."Verification Code COL";
                    end;
                }

                textelement(EMI_23)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_23 := PostCodeCompanyInfo."Municipality Code DANE";
                    end;
                }

                textelement(EMI_24)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EMI_24 := CompanyInfo.Name;
                    end;
                }

                textelement(TAC)
                {
                    MaxOccurs = Once;

                    textelement(TAC_1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            TAC_1 := EISetup."Taxpayer Obligation";
                        end;
                    }
                }

                textelement(DFE)
                {

                    textelement(DFE_1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            DFE_1 := PostCodeCompanyInfo."Municipality Code DANE";
                        end;
                    }

                    textelement(DFE_2)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            DFE_2 := PostCodeCompanyInfo."Department Code DANE";
                        end;
                    }

                    textelement(DFE_3)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            DFE_3 := CountryRegionCompanyInfo."Country/Region Code DIAN";
                        end;
                    }

                    textelement(DFE_4)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            DFE_4 := CompanyInfo."Post Code";
                        end;
                    }

                    textelement(DFE_5)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            DFE_5 := CountryRegionCompanyInfo.Name;
                        end;
                    }

                    textelement(DFE_6)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            //Datos de las tablas de excel
                        end;
                    }

                    textelement(DFE_7)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            DFE_7 := PostCodeCompanyInfo."Municipality Code DANE";
                        end;
                    }

                    textelement(DFE_8)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            DFE_8 := CompanyInfo.Address;
                        end;
                    }
                }

                textelement(BFE)
                {
                    textelement(BFE_1)
                    {
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin
                            BFE_1 := CompanyInfo."Bank Account No.";
                        end;
                    }
                }

                textelement(GTE)
                {
                    textelement(GTE_1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            GTE_1 := '01';
                        end;
                    }

                    textelement(GTE_2)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            GTE_2 := 'IVA';
                        end;
                    }
                }
            }

            textelement(ADQ)
            {
                textelement(ADQ_1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if Customer."Partner Type" = Customer."Partner Type"::Company then
                            ADQ_1 := '1'
                        else begin
                            if Customer."Partner Type" = Customer."Partner Type"::Company then
                                ADQ_1 := '2';
                        end;
                    end;
                }

                textelement(ADQ_2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ADQ_2 := DelChr(Customer."VAT Registration No.", '=', ' .-');
                    end;
                }

                textelement(ADQ_3)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ADQ_3 := Customer."Document Type";
                    end;
                }

                textelement(ADQ_4)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ADQ_4 := Customer."Fiscal Regime";
                    end;
                }

                textelement(ADQ_5)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ADQ_5 := ENC."Sell-to Customer No.";
                    end;
                }

                textelement(ADQ_6)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ADQ_6 := ENC."Sell-to Customer Name";
                    end;
                }

                textelement(ADQ_7)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ADQ_7 := enc."Sell-to Customer Name";
                    end;
                }

                textelement(ADQ_8)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        //if Customer."Partner Type" = Customer."Partner Type"::Person then
                        //    ADQ_8 := Customer.Name + 
                    end;
                }

                textelement(ADQ_10)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ADQ_10 := ENC."Sell-to Address";
                    end;
                }

                textelement(ADQ_11)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ADQ_11 := PostCodeCustomer."Department Code DANE";
                    end;
                }

                textelement(ADQ_13)
                {

                }

                textelement(ADQ_14)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ADQ_14 := Customer."Post Code";
                    end;
                }

                textelement(ADQ_15)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ADQ_15 := CountryRegionCustomer."Country/Region Code DIAN";
                    end;
                }

                textelement(ADQ_22)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        ADQ_22 := Customer."Verification Code COL";
                    end;
                }

                textelement(TCR)
                {
                    textelement(TCR_1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            //TCR_1 := Customer."Taxayer Obligations";
                        end;
                    }
                }

                textelement(ILA)
                {
                    textelement(ILA_1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ILA_1 := customer.Name;
                        end;
                    }

                    textelement(ILA_2)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ILA_2 := DelChr(Customer."VAT Registration No.", '=', ' .-');
                        end;
                    }

                    textelement(ILA_3)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ILA_3 := Customer."Document Type";
                        end;
                    }

                    textelement(ILA_4)
                    {
                        MinOccurs = Zero;
                        trigger OnBeforePassVariable()
                        begin
                            ILA_4 := Customer."Verification Code COL";
                        end;
                    }
                }

                textelement(DFA)
                {
                    textelement(DFA_1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            DFA_1 := CountryRegionCustomer."Country/Region Code DIAN";
                        end;
                    }

                    textelement(DFA_2)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            DFA_2 := PostCodeCustomer."Department Code DANE";
                        end;
                    }

                    textelement(DFA_3)
                    {

                    }

                    textelement(DFA_4)
                    {

                    }
                }

                textelement(GTA)
                {
                    textelement(GTA_1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            GTA_1 := '01';
                        end;
                    }

                    textelement(GTA_2)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            GTA_2 := 'IVA';
                        end;
                    }
                }
            }

            textelement(TOT)
            {
                textelement(TOT_1)
                {

                }

                textelement(TOT_2)
                {

                }

                textelement(TOT_3)
                {

                }

                textelement(TOT_4)
                {

                }

                textelement(TOT_5)
                {

                }

                textelement(TOT_6)
                {

                }

                textelement(TOT_7)
                {

                }

                textelement(TOT_8)
                {

                }

                textelement(TOT_9)
                {

                }

                textelement(TOT_10)
                {

                }
            }

            textelement(TIM)
            {
                textelement(TIM_1)
                {

                }

                textelement(TIM_2)
                {

                }

                textelement(TIM_3)
                {
                    trigger OnBeforePassVariable()
                    begin
                        tim_3 := enc."Currency Code";
                    end;
                }

                textelement(IMP)
                {
                    textelement(IMP_1)
                    {

                    }

                    textelement(IMP_2)
                    {

                    }

                    textelement(IMP_3)
                    {

                    }

                    textelement(IMP_4)
                    {

                    }

                    textelement(IMP_5)
                    {

                    }

                    textelement(IMP_6)
                    {

                    }
                }
            }

            textelement(DRF)
            {
                textelement(DRF_1)
                {

                }

                textelement(DRF_2)
                {

                }

                textelement(DRF_3)
                {

                }

                textelement(DRF_4)
                {

                }

                textelement(DRF_5)
                {

                }

                textelement(DRF_6)
                {

                }
            }

            textelement(PCR)
            {
                textelement(PCR_1)
                {

                }
            }

            textelement(AQF)
            {
                textelement(AQF_1)
                {

                }

                textelement(AQF_2)
                {

                }

                textelement(AQF_3)
                {

                }

                textelement(AQF_4)
                {

                }

                textelement(AQF_5)
                {

                }

                textelement(ATA)
                {
                    textelement(ATA_1)
                    {

                    }
                }
            }

            textelement("NOT")
            {
                textelement(NOT_1)
                {

                }
            }

            textelement(IEN)
            {
                textelement(IEN_1)
                {

                }

                textelement(IEN_2)
                {

                }

                textelement(IEN_3)
                {

                }

                textelement(IEN_4)
                {

                }

                textelement(IEN_5)
                {

                }

                textelement(IEN_6)
                {

                }
            }

            textelement(MEP)
            {
                textelement(MEP_1)
                {

                }

                textelement(MEP_2)
                {

                }

                textelement(MEP_3)
                {

                }
            }

            tableelement("ITE"; "Sales Invoice Line")
            {
                LinkTable = ENC;
                LinkFields = "Document No." = field ("No.");

                textelement(ITE_1)
                {

                }

                textelement(ITE_2)
                {

                }

                textelement(ITE_3)
                {

                }

                textelement(ITE_4)
                {

                }

                textelement(ITE_5)
                {

                }

                textelement(ITE_6)
                {

                }

                textelement(ITE_7)
                {

                }

                textelement(ITE_8)
                {

                }

                textelement(ITE_9)
                {

                }

                textelement(ITE_10)
                {

                }

                textelement(ITE_11)
                {

                }

                textelement(ITE_12)
                {

                }

                textelement(ITE_13)
                {

                }

                textelement(ITE_14)
                {

                }

                textelement(ITE_15)
                {

                }

                textelement(IAE)
                {
                    textelement(IAE_1)
                    {

                    }

                    textelement(IAE_2)
                    {

                    }
                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    /*ield(Name; SourceExpression)
                    {

                    }*/
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {

                }
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        EISetup: Record "EI-Setup";
        Customer: Record Customer;
        Currency: Record Currency;
        PostCodeCompanyInfo: Record "Post Code";
        PostCodeCustomer: Record "Post Code";
        CountryRegionCompanyInfo: Record "Country/Region";
        CountryRegionCustomer: Record "Country/Region";
        TaxJurisdictions: Record "Tax Jurisdiction";
        TaxDetail: Record "Tax Detail";
        PaymentMethod: Record "Payment Method";
        UnitOfMeausre: Record "Unit of Measure";
        Item: Record Item;


    trigger OnPreXmlPort()
    begin
        Clear(CompanyInfo);
        CompanyInfo.get;

        Clear(PostCodeCompanyInfo);
        PostCodeCompanyInfo.get(CompanyInfo."Post Code");

        Clear(CountryRegionCompanyInfo);
        CountryRegionCompanyInfo.get(CompanyInfo."Country/Region Code");

        Clear(EISetup);
        EISetup.get;
    end;

    local procedure DocNumberOfLines(pDocNo: Code[20]) rtNoOfLines: Integer;
    var
        invoiceLines: Record "Sales Invoice Line";
    begin
        Clear(invoiceLines);
        invoiceLines.SetRange("Document No.", pDocNo);
        rtNoOfLines := invoiceLines.Count;
    end;
}