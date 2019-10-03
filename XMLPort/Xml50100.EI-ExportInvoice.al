xmlport 50100 "EI-ExportInvoice"
{
    Format = Xml;
    Direction = Export;
    Encoding = UTF8;
    schema
    {

        textelement(FACTURA)
        {
            tableelement(ENC; "Sales Invoice Header")
            {
                textelement(ENC_1)
                {
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
                        ENC_7 := format(ENC."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>');
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
                        ENC_16 := format(ENC."Due Date", 0, '<Year4>-<Month,2>-<Day,2>');
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
                    Customer.get(ENC."Bill-to Customer No.");

                    Clear(PostCodeCustomer);
                    PostCodeCustomer.Get(Customer."Post Code", customer.City);

                    Clear(PostCodeShipTo);
                    PostCodeShipTo.Get(ENC."Ship-to Post Code", enc."Ship-to City");

                    clear(CountryRegionCustomer);
                    CountryRegionCustomer.Get(Customer."Country/Region Code");

                    Clear(Currency);
                    Currency.get(ENC."Currency Code");

                    Clear(PaymentMethod);
                    PaymentMethod.Get(ENC."Payment Method Code");

                    clear(NoSerieLine);
                    NoSerieLine.setrange("Series Code", ENC."No. Series");
                    NoSerieLine.SetFilter("Starting No.", '<=%1', ENC."No.");
                    NoSerieLine.SetFilter("Ending No.", '>=%1', ENC."No.");
                    NoSerieLine.FindFirst();
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
                            Clear(DianSetup);
                            DianSetup.setrange("Table Code", '108');
                            DianSetup.setrange("DIAN Code", PostCodeCompanyInfo."Department Code DANE");
                            if DianSetup.FindFirst() then
                                DFE_6 := DianSetup.Description;
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
                        ADQ_7 := ENC."Sell-to Customer Name";
                    end;
                }

                textelement(ADQ_8)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        if Customer."Partner Type" = Customer."Partner Type"::Person then
                            ADQ_8 := Customer.Name + customer."Last Name" + Customer."Mothers Last Name";
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
                    trigger OnBeforePassVariable()
                    begin
                        Clear(DianSetup);
                        DianSetup.SetRange("Table Code", '9997');
                        DianSetup.SetRange("DIAN Code", PostCodeCustomer."Municipality Code DANE");
                        if DianSetup.FindFirst() then
                            ADQ_13 := DianSetup.Description;
                    end;
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
                            TCR_1 := Customer."Fiscal Responsabilities";
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
                        trigger OnBeforePassVariable()
                        begin
                            DFA_3 := Customer."Post Code";
                        end;
                    }

                    textelement(DFA_4)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            DFA_4 := PostCodeCustomer."Municipality Code DANE";
                        end;
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
                    trigger OnBeforePassVariable()
                    begin
                        TOT_1 := delchr(format(TotalAmountExclVAT(ENC."No.")), '=', '.');
                    end;
                }

                textelement(TOT_2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TOT_2 := Currency."Coin ISO 4217";
                    end;
                }

                textelement(TOT_3)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TOT_3 := delchr(format(TotalBaseVAT(ENC."No.")), '=', '.');
                    end;
                }

                textelement(TOT_4)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TOT_4 := Currency."Coin ISO 4217";
                    end;
                }

                textelement(TOT_5)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TOT_5 := delchr(format(TotalAmountInclVAT(ENC."No.")), '=', '.');
                    end;
                }

                textelement(TOT_6)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TOT_6 := Currency."Coin ISO 4217";
                    end;
                }

                textelement(TOT_7)
                {

                }

                textelement(TOT_8)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TOT_8 := Currency."Coin ISO 4217";
                    end;
                }

                textelement(TOT_9)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TOT_9 := delchr(format(TotalDiscountAmount(ENC."No.")), '=', '.');
                    end;
                }

                textelement(TOT_10)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TOT_10 := Currency."Coin ISO 4217";
                    end;
                }
            }

            tableelement(TIM; "VAT Entry")
            {
                textelement(TIM_1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if TIM."VAT DIAN Code" in ['01', '02', '03', '04'] then
                            TIM_1 := 'false'
                        else
                            TIM_1 := 'TRUE';
                    end;
                }

                textelement(TIM_2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TIM_2 := delchr(format(TIM.Amount), '=', '.');
                    end;
                }

                textelement(TIM_3)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TIM_3 := ENC."Currency Code";
                    end;
                }

                textelement(IMP)
                {
                    textelement(IMP_1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            IMP_1 := TIM."VAT DIAN Code";
                        end;
                    }

                    textelement(IMP_2)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            IMP_2 := delchr(format(TIM.Base), '=', '.');
                        end;
                    }

                    textelement(IMP_3)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            IMP_3 := ENC."Currency Code";
                        end;
                    }

                    textelement(IMP_4)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            IMP_4 := delchr(format(TIM.Amount), '=', '.');
                        end;
                    }

                    textelement(IMP_5)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            IMP_5 := ENC."Currency Code";
                        end;
                    }

                    textelement(IMP_6)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            IMP_6 := delchr(format(TIM."Tax Above Maximum COL"), '=', '.');
                        end;
                    }
                }

                trigger OnPreXmlItem()
                begin
                    TIM.SetRange("Document No.", ENC."No.");
                end;
            }

            textelement(DRF)
            {
                textelement(DRF_1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DRF_1 := NoSerieLine."Resolution No.";
                    end;
                }

                textelement(DRF_2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DRF_2 := format(NoSerieLine."Starting Date");
                    end;
                }

                textelement(DRF_3)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DRF_3 := format(NoSerieLine."Resolution Ending Date");
                    end;
                }

                textelement(DRF_4)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DRF_4 := CopyStr(ENC."No. Series", 1, 2);
                    end;
                }

                textelement(DRF_5)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DRF_5 := NoSerieLine."Starting No.";
                    end;
                }

                textelement(DRF_6)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DRF_6 := CopyStr(NoSerieLine."Starting No.", 3);
                    end;
                }
            }

            textelement(PCR)
            {
                textelement(PCR_1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PCR_1 := EISetup."Taxpayer Obligation";
                    end;
                }
            }

            textelement(AQF)
            {
                textelement(AQF_1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AQF_1 := DelChr(Customer."VAT Registration No.", '=', ' .-');
                    end;
                }

                textelement(AQF_2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AQF_2 := Customer."Document Type";
                    end;
                }

                textelement(AQF_3)
                {
                    trigger OnBeforePassVariable()
                    var
                        taxArea: Record "Tax Area";
                    begin
                        Clear(taxArea);
                        taxArea.Get(ENC."Tax Area Code");
                        if taxArea."Regime Type" = taxArea."Regime Type"::"Simplified Regime" then
                            AQF_3 := '0'
                        else
                            AQF_3 := '2';
                    end;
                }

                textelement(AQF_4)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AQF_4 := customer.Name;
                    end;
                }

                textelement(AQF_13)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AQF_13 := Customer."Country/Region Code";
                    end;
                }

                textelement(ATA)
                {
                    textelement(ATA_1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            ATA_1 := Customer."Fiscal Responsabilities";
                        end;
                    }
                }
            }

            tableelement("NOT"; Integer)
            {
                textelement(NOT_1)
                {
                    trigger OnBeforePassVariable()
                    var
                        varInStream: InStream;
                        reportCheque: Report Check;
                        textAmount: array[2] of Text[80];
                    begin
                        case "NOT".number of
                            1:
                                begin
                                    NOT_1 := ADQ_2 + '-' + ADQ_22;
                                end;

                            2:
                                begin
                                    NOT_1 := ENC."Location Code";
                                end;

                            3:
                                begin
                                    NOT_1 := CompanyInfo.City;
                                end;

                            4:
                                begin
                                    if MEP_2 = '1' then
                                        NOT_1 := 'X'
                                    else
                                        NOT_1 := '';
                                end;

                            5:
                                begin
                                    if MEP_2 = '2' then
                                        NOT_1 := 'X'
                                    else
                                        NOT_1 := '';
                                end;

                            6:
                                begin
                                    NOT_1 := ENC."Payment Terms Code";
                                end;

                            7:
                                begin
                                    ENC.calcfields("Work Description");
                                    ENC."Work Description".CreateInStream(varInStream);
                                    varInStream.ReadText(NOT_1);
                                end;

                            8:
                                begin
                                    ENC.CalcFields("Amount Including VAT");
                                    reportCheque.InitTextVariable();
                                    reportCheque.FormatNoText(textAmount, TotalAmountInclVAT(ENC."No."), ENC."Currency Code");
                                    NOT_1 := DelChr(textAmount[1] + textAmount[2], '=', '*');
                                end;

                            9:
                                begin
                                    NOT_1 := EISetup.TEXT1;
                                end;

                            10:
                                begin
                                    NOT_1 := EISetup.TEXT2;
                                end;

                            11:
                                begin
                                    NOT_1 := EISetup.TEXT3;
                                end;

                            12:
                                begin
                                    NOT_1 := EISetup.TEXT4;
                                end;

                            13:
                                begin
                                    NOT_1 := ENC."Ship-to Code";
                                end;

                            14:
                                begin
                                    NOT_1 := ENC."Ship-to Name";
                                end;

                            15:
                                begin
                                    NOT_1 := EISetup.TEXT5;
                                end;

                            16:
                                begin
                                    NOT_1 := CompanyInfo."Phone No.";
                                end;
                        end;
                    end;
                }

                trigger OnPreXmlItem()
                begin
                    "NOT".SetRange(Number, 1, 16);
                end;
            }

            textelement(IEN)
            {
                textelement(IEN_1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        IEN_1 := ENC."Ship-to Address";
                    end;
                }

                textelement(IEN_2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        IEN_2 := PostCodeShipTo."Department Code DANE";
                    end;
                }

                textelement(IEN_4)
                {
                    trigger OnBeforePassVariable()
                    begin
                        IEN_4 := PostCodeShipTo."Municipality Code DANE";
                    end;
                }

                textelement(IEN_5)
                {
                    trigger OnBeforePassVariable()
                    begin
                        IEN_5 := ENC."Ship-to Post Code";
                    end;
                }

                textelement(IEN_6)
                {
                    trigger OnBeforePassVariable()
                    begin
                        IEN_6 := ENC."Ship-to Country/Region Code";
                    end;
                }
                textelement(IEN_12)
                {
                    trigger OnBeforePassVariable()
                    begin
                        IEN_12 := PostCodeShipTo."Municipality Code DANE";
                    end;
                }
            }

            textelement(MEP)
            {
                textelement(MEP_1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        MEP_1 := PaymentMethod."Payment Means";
                    end;
                }

                textelement(MEP_2)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if PaymentMethod.Credit then
                            MEP_2 := '2'
                        else
                            MEP_2 := '1';
                    end;
                }

                textelement(MEP_3)
                {
                    trigger OnBeforePassVariable()
                    begin
                        MEP_3 := format(ENC."Due Date", 0, '<Year4><Month,2><Day,2>');
                    end;
                }
            }

            tableelement("ITE"; "Sales Invoice Line")
            {
                LinkTable = ENC;
                LinkFields = "Document No." = field ("No.");

                textelement(ITE_1)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_1 := format(ITE."Line No.");
                    end;
                }

                textelement(ITE_3)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_3 := Format(ITE.Quantity);
                    end;
                }

                textelement(ITE_4)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_4 := UnitOfMeausre."DIAN Code";
                    end;
                }

                textelement(ITE_5)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_5 := delchr(format(ITE.GetLineAmountExclVAT()), '=', '.');
                    end;
                }

                textelement(ITE_6)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_6 := ENC."Currency Code";
                    end;
                }

                textelement(ITE_7)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_7 := delchr(format(ITE."Unit Price"), '=', '.');
                    end;
                }

                textelement(ITE_8)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_8 := ENC."Currency Code";
                    end;
                }

                textelement(ITE_11)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_11 := ITE.Description + ' ' + ITE."Description 2";
                    end;
                }

                textelement(ITE_18)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_18 := ITE."Bill-to Customer No.";
                    end;
                }

                textelement(ITE_19)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_19 := delchr(Format(ITE.Amount), '=', '.');
                    end;
                }

                textelement(ITE_20)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_20 := ENC."Currency Code";
                    end;
                }

                textelement(ITE_21)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_21 := delchr(Format(ITE."Amount Including VAT"), '=', '.');
                    end;
                }

                textelement(ITE_22)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_22 := ENC."Currency Code";
                    end;
                }

                textelement(ITE_27)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_27 := Format(ITE.Quantity);
                    end;
                }

                textelement(ITE_28)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ITE_28 := UnitOfMeausre."DIAN Code";
                    end;
                }

                textelement(IAE)
                {
                    textelement(IAE_1)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            IAE_1 := Item.GTIN;
                        end;
                    }

                    textelement(IAE_2)
                    {
                        trigger OnBeforePassVariable()
                        begin
                            IAE_2 := EISetup."Product Standard";
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    clear(UnitOfMeausre);
                    UnitOfMeausre.Get(ITE."Unit of Measure Code");

                    Clear(Item);
                    Item.Get(ITE."No.");
                end;
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
        PostCodeShipTo: Record "Post Code";
        CountryRegionCompanyInfo: Record "Country/Region";
        CountryRegionCustomer: Record "Country/Region";
        PaymentMethod: Record "Payment Method";
        UnitOfMeausre: Record "Unit of Measure";
        Item: Record Item;
        DianSetup: Record "DIAN Setup";
        NoSerieLine: Record "No. Series Line";



    trigger OnPreXmlPort()
    begin
        Clear(CompanyInfo);
        CompanyInfo.get;

        Clear(PostCodeCompanyInfo);
        PostCodeCompanyInfo.get(CompanyInfo."Post Code", CompanyInfo.City);

        Clear(CountryRegionCompanyInfo);
        CountryRegionCompanyInfo.get(CompanyInfo."Country/Region Code");

        Clear(EISetup);
        EISetup.get;
    end;

    local procedure DocNumberOfLines(pDocNo: Code[20]) rtNoOfLines: Integer;
    var
        invoiceLines: Record "Sales Invoice Line";
    begin
        rtNoOfLines := 0;

        Clear(invoiceLines);
        invoiceLines.SetRange("Document No.", pDocNo);
        invoiceLines.SetFilter(Quantity, '<>%1', 0);
        rtNoOfLines := invoiceLines.Count;
    end;

    local procedure TotalAmountExclVAT(pDocNo: Code[20]) rtAmountExclVAT: Decimal;
    var
        invoiceLines: Record "Sales Invoice Line";
        amountExclVAT: Decimal;
    begin
        rtAmountExclVAT := 0;

        Clear(invoiceLines);
        invoiceLines.SetRange("Document No.", pDocNo);
        invoiceLines.SetFilter(Quantity, '<>%1', 0);
        if invoiceLines.FindSet then begin
            amountExclVAT += invoiceLines.GetLineAmountExclVAT();
        end;
        rtAmountExclVAT := amountExclVAT;
    end;

    local procedure TotalBaseVAT(pDocNo: Code[20]) rtBaseVAT: Decimal;
    var
        invoiceLines: Record "Sales Invoice Line";
        baseVAT: Decimal;
    begin
        rtBaseVAT := 0;

        Clear(invoiceLines);
        invoiceLines.SetRange("Document No.", pDocNo);
        invoiceLines.SetFilter(Quantity, '<>%1', 0);
        if invoiceLines.FindSet then begin
            baseVAT += invoiceLines."VAT Base Amount";
        end;
        rtBaseVAT := baseVAT;
    end;

    local procedure TotalAmountInclVAT(pDocNo: Code[20]) rtAmountInclVAT: Decimal;
    var
        invoiceLines: Record "Sales Invoice Line";
        amountInclVAT: Decimal;
    begin
        rtAmountInclVAT := 0;

        Clear(invoiceLines);
        invoiceLines.SetRange("Document No.", pDocNo);
        invoiceLines.SetFilter(Quantity, '<>%1', 0);
        if invoiceLines.FindSet then begin
            amountInclVAT += invoiceLines."Amount Including VAT";
        end;
        rtAmountInclVAT := amountInclVAT;
    end;

    local procedure TotalDiscountAmount(pDocNo: Code[20]) rtDiscountAmount: Decimal;
    var
        invoiceLines: Record "Sales Invoice Line";
        discountAmount: Decimal;
    begin
        rtDiscountAmount := 0;

        Clear(invoiceLines);
        invoiceLines.SetRange("Document No.", pDocNo);
        invoiceLines.SetFilter(Quantity, '<>%1', 0);
        if invoiceLines.FindSet then begin
            discountAmount += invoiceLines."Line Discount Amount";
        end;
        rtDiscountAmount := discountAmount;
    end;
}