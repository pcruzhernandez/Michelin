dotnet
{
    assembly(System)
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type(System.Security.Cryptography.SHA256; sha256Hasher) { }
        type(System.Array; NETArray) { }
        type(System.Convert; NETConvert) { }
        type(System.Byte; NETByte) { }
        type(System.Text.UTF8Encoding; NETEncoding) { }
        type(System.String; NETString) { }
        type(System.Guid; NETGuid) { }
        type(System.DateTime; NETDt) { }
        type(System.Security.Cryptography.SHA1; sha1Hasher) { }
        type(System.IO.File; NETFile) { }
        type(System.Net.WebRequest; WebRequest) { }
        type(System.Net.HttpWebRequest; NETHttpWebRequest) { }
        type(System.IO.Stream; RequestStream) { }
        type(System.Text.Encoding; NETEncoding2) { }
        type(System.Array; ByteArray) { }
        type(System.Uri; NETUri) { }
        type(System.Net.HttpWebResponse; NETHttpWebResponse) { }
        type(System.Net.HttpStatusCode; StatusCode) { }
        type(System.Net.HttpRequestHeader; HttpWebRequestHeader) { }
        type(System.Net.DecompressionMethods; NETDecompressionMethods) { }
        type(System.Net.HttpStatusCode; NETHttpStatusCode) { }
        type(System.Collections.Specialized.NameValueCollection; ResponseHeaders) { }
        type(System.Net.WebProxy; Proxy) { }
        type(System.Threading.Tasks."Task`1"; Task) { }
        type(System.Exception; DotNetExceptionGl) { }
        type(System.Net.WebExceptionStatus; NETWebExceptionStatus) { }
        type(System.Net.WebException; NetWebException) { }
        type(System.Globalization.CultureInfo; NETGloba) { }
        type(System.IO.MemoryStream; NETMemory) { }
    }

    assembly("System.Xml")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';


        type(System.Xml.XmlDocument; NetXmlDocument) { }


        type(System.Xml.XmlNamespaceManager; NETXmlNamespaceManager) { }
        type(System.Xml.XmlNode; NETXmlNode) { }
    }
}

codeunit 50100 "FAE-WS Send"
{
    trigger OnRun()
    var
        p_optMethod: Option Upload,DocumentStatus,Download,AvaliableDocument,DownloadDocuments;
        instr: InStream;
        Netarray: DotNet NETArray;
        doc: array[40, 2] of Text[20];
    begin
        SendMethod(p_optMethod::Upload, 'xxxxx', instr, Netarray, '103028', doc, 112, 0);
    end;

    var
        XMLDOMManagement: Codeunit 6224;
        SoapenvTxt: TextConst ENU = 'http://schemas.xmlsoap.org/soap/envelope/';
        invTxt: TextConst ENU = 'http://invoice.carvajal.com/invoiceService/';
        wsseTxt: TextConst ENU = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
        wsuTxt: TextConst ENU = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
        g_numFactura: Code[20];
        MsgOK: TextConst ENU = 'File correctly loaded.';
        ErrTableID: TextConst ENU = 'Wrong ID Table.';

    procedure Validations(p_NoDocument: Code[20])
    var
        Currency: Record 4;
        Customer: Record 18;
        CI01: TextConst ENU = 'The field "VAT Registration No." is empty in Company Information.', ESP = 'El campo "CIF/NIF" est  vac¡o en Informaci¢n de empresa.';
        SalesLine: Record 37;
        CompanyInfo: Record 79;
        UnitOfMeasure: Record 204;
        NoSeriesLine: Record 309;
        Contact: Record 5050;
        ContactBusinessRelation: Record 5054;
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        EI_Setup: Record 50100;
        SalesHeader: record 36;
        CI02: TextConst ENU = 'The field "VAT Registration Type" is empty in Company Information.', ESP = 'El campo "Tipo NIT/C‚dula" est  vac¡o en Informaci¢n de empresa.';
        CI03: TextConst ENU = 'The field "Name" is empty in Company Information.', ESP = 'El campo "Nombre" est  vac¡o en Informaci¢n de empresa.';
        CI04: TextConst ENU = 'The field "Address" is empty in Company Information.', ESP = 'El campo "Direcci¢n" est  vac¡o en Informaci¢n de empresa.';
        CI05: TextConst ENU = 'The field "City" is empty in Company Information.', ESP = 'El campo "Ciudad" est  vac¡o en Informaci¢n de empresa.';
        CI06: TextConst ENU = 'The field "Country/Region Code" is empty in Company Information.', ESP = 'El campo "C¢d. Pa¡s/Regi¢n" est  vac¡o en Informaci¢n de empresa.';
        CI07: TextConst ENU = 'The field "Person Type Catalogue" is empty in Company Information.', ESP = 'El campo "Cat logo Tipo Persona" est  vac¡o en Informaci¢n de empresa.';
        CI08: TextConst ENU = 'The field "ICA Tariff" is empty in Company Information.', ESP = 'El campo "Tarifa ICA" est  vac¡o en Informaci¢n de empresa.';
        CI09: TextConst ENU = 'The field "Electronic Invloice Path" is empty in Company Information.', ESP = 'El campo "Ruta Facturaci¢n Electr¢nica" est  vac¡o en Informaci¢n de empresa.';
        CI10: TextConst ENU = 'The field "Electronic Invoice WDSL" is empty in EI_Setup.', ESP = 'El campo "WDSL Facturaci¢n Electr¢nica" est  vac¡o en EI_Setup.';
        CI11: TextConst ENU = 'The field "Electronic Invoice User" is empty in EI_Setup.', ESP = 'El campo "Usuario Facturaci¢n Electr¢nica" est  vac¡o en EI_Setup.';
        CI12: TextConst ENU = 'The field "Electronic Invoice Password" is empty in EI_Setup.', ESP = 'El campo "Contrase¤a Facturaci¢n Electr¢nica" est  vac¡o en EI_Setup.';
        CI13: TextConst ENU = 'The field "Electronic Invoice CompanyID" is empty in EI_Setup.', ESP = 'El campo "IDCompa¤¡a Facturaci¢n Electr¢nica" est  vac¡o en EI_Setup.';
        CI14: TextConst ENU = 'The field "Electronic Invoice AccountID" is empty in EI_Setup.', ESP = 'El campo "IDCuenta Facturaci¢n Electr¢nica" est  vac¡o en EI_Setup.';
        CI15: TextConst ENU = 'The field "Proxy" is empty in EI_Setup.', ESP = 'El campo "Proxy" est  vac¡o en EI_Setup.';
        CI16: TextConst ENU = 'The field "Port" is empty in EI_Setup.', ESP = 'El campo "Puerto" est  vac¡o en EI_Setup.';
        CI17: TextConst ENU = 'The field "Business Registration No." is empty in Company Information.', ESP = 'El campo "N§ Matr¡cula Mercantil" est  vac¡o en Informaci¢n de empresa.';
        CI18: TextConst ENU = 'The field "Electronic Invoice URLEndpoint" is empty in EI_Setup.', ESP = 'El campo "Endpoint URL Facturaci¢n Electr¢nica" est  vac¡o en EI_Setup.';
        CI19: TextConst ENU = 'The field "Electronic Invoice Web Response" is empty in Company Information.', ESP = 'El campo "Web Respuesta Facturaci¢n Electr¢nica" est  vac¡o en Informaci¢n de empresa.';
        CI20: TextConst ENU = 'The field "Electronic Invoice Web Response" is empty in Company Information.', ESP = 'El campo "Web Respuesta Facturaci¢n Electr¢nica" est  vac¡o en Informaci¢n de empresa.';
        CO01: TextConst ENU = '"The field ""DIAN Code"" is empty in VAT Registration Type "', ESP = '"El campo ""C¢digo DIAN"" est  vac¡o en el tipo de registro de IVA "';
        CO02: TextConst ENU = '"The field ""DIAN Table 20"" has no selected option in VAT Registration Type "', ESP = '"El campo ""DIAN Table 20"" no tiene opci¢n seleccionada en el tipo de registro de IVA "';
        CU01: TextConst ENU = 'The field VAT Registration No. is empty in Customer.', ESP = 'El campo CIF/NIF est  vac¡o en Cliente.';
        CU02: TextConst ENU = 'The field "Fiscal Regimen" is empty in Customer.', ESP = 'El campo "Fiscal Regimen" est  vac¡o en Cliente.';
        CU03: TextConst ENU = 'The field "Name" is empty in Customer.', ESP = 'El campo "Nombre" est  vac¡o en Cliente.';
        CU04: TextConst ENU = 'The field "Name 2" is empty in Customer.', ESP = 'El campo "Nombre 2" est  vac¡o en Cliente.';
        CU05: TextConst ENU = 'The field "Address" is empty in Customer.', ESP = 'El campo "Direcci¢n" est  vac¡o en Cliente.';
        CU06: TextConst ENU = 'The field "City" is empty in Customer.', ESP = 'El campo "Ciudad" est  vac¡o en Cliente.';
        CU07: TextConst ENU = 'The field "Country/Region Code" is empty in Customer.', ESP = 'El campo "C¢d. Pa¡s/Regi¢n" est  vac¡o en Cliente.';
        CU08: TextConst ENU = 'The field "Regime Type" is empty in Customer.', ESP = 'El campo "Tipo R‚gimen" est  vac¡o en Cliente.';
        CU09: TextConst ENU = 'There is no contact of Type "Contact" related to Customer.', ESP = 'No existe un contacto de Tipo "Contacto" vinculado al Cliente.';
        CU10: TextConst ENU = 'The field "Phone No." is empty in Customer. Continue?', ESP = 'El campo "N§ Tel‚fono" est  vac¡o en Cliente. ¨Desea continuar?';
        CU11: TextConst ENU = '"The field ""E-Mail"" is empty in Customer. "', ESP = 'El campo "Correo electr¢nico" est  vac¡o en Cliente.';
        CU12: TextConst ENU = 'The field "Business Registration No." is empty in Customer.', ESP = 'El campo "N§ Matr¡cula Mercantil" est  vac¡o en Cliente.';
        CU13: TextConst ENU = 'The field "Fiscal Responsabilities" is empty in Customer.', ESP = 'El campo "Fiscal Responsabilities" est  vac¡o en Cliente.';

        DO01: TextConst ENU = '"Specifies ""Applies-to Doc. No."" in "', ESP = '"Especifique ""Liq. por N§ Documento"" en "';
        DO02: TextConst ENU = '"""Applies-to Doc. Type"" must be ""Invoice"" in Credit Memo "', ESP = '"""Liq. por Tipo Documento"" debe ser ""Factura"" en Nota de cr‚dito "';
        DO03: TextConst ENU = '"""Applies-to Doc. Type"" must be ""Credit Memo"" in Debit Note  "', ESP = '"""Liq. por Tipo Documento"" debe ser ""Abono"" en Nota de d‚bito "';
        DO04: TextConst ENU = '"The field ""DIAN Code"" is empty in Currency "', ESP = '"El campo ""C¢digo DIAN"" est  vac¡o en Divisa "';
        DO05: TextConst ENU = '"""Applies-to Doc. No."" must be a Sales Invoice in Credit Memo "', ESP = '"""Liq. por N§ Documento"" debe ser una Factura de Ventas en Nota de cr‚dito "';
        DO06: TextConst ENU = '"""Applies-to Doc. No."" must be a Sales Credit Memo in Invoice "', ESP = '"""Liq. por N§ Documento"" debe ser una Nota de cr‚dito de Ventas en Nota de d‚bito "';
        SE01: TextConst ENU = '"The field ""Resolution No."" is empty in No. Series Code "', ESP = '"El campo ""N§ resoluci¢n DIAN"" est  vac¡o en C¢d. N§ Serie "';
        SE02: TextConst ENU = '"The field ""Resolution Date"" is empty in No. Series Code "', ESP = '"El campo ""Fecha resoluci¢n"" est  vac¡o en C¢d. N§ Serie "';
        SE03: TextConst ENU = '"The field ""Resolution Expiration Date"" is empty in No. Series Code "', ESP = '"El campo ""Fecha vcto. resoluci¢n"" est  vac¡o en C¢d. N§ Serie "';
        SE04: TextConst ENU = '"The field ""Prefix Numbering"" is empty in No. Series Code "', ESP = '"El campo ""Prefijo de numeraci¢n"" est  vac¡o en C¢d. N§ Serie "';
        SE05: TextConst ENU = '"The field ""Doc. Type DIAN"" is empty in Sales Invoice"', ESP = '"The field ""Doc. Type DIAN"" is empty in Factura de venta "';
        SE06: TextConst ENU = '"The field ""Shiptment Port"" is empty in Sales Invoice"', ESP = '"The field ""Shiptment Port"" is empty in Factura de venta "';
        SE07: TextConst ENU = '"The field ""Destination Port"" is empty in Sales Invoice"', ESP = '"The field ""Destination Port"" is empty in Factura de venta "';

        SE08: TextConst ENU = '"The field ""Gross Weight"" is empty in Sales Invoice"', ESP = '"The field ""Gross Weight"" is empty in Factura de venta "';
        SE09: TextConst ENU = '"The field ""Shipping Information"" is empty in Sales Invoice"', ESP = '"The field ""Shipping Information"" is empty in Factura de venta "';

        SE10: TextConst ENU = '"The field ""Destination Port"" is empty in Sales Invoice"', ESP = '"The field ""Destination Port"" is empty in Factura de venta "';
        SE11: TextConst ENU = '"The field ""EIConcept"" is empty in Sales Invoice"', ESP = '"The field ""EIConcept"" is empty in Factura de venta "';
        IT01: TextConst ENU = '"The field ""DIAN Code"" is empty in Unit of Measure"', ESP = '"El campo ""C¢digo DIAN"" est  vac¡o en Unidad de medida "';
        PM01: TextConst ENU = '"The field ""Payment Means"" is empty in Payment Method"', ESP = '"El campo ""Payment Means"" est  vac¡o en Unidad de medida "';
        PM02: TextConst ENU = 'The field Tax Area Code is empty in Sales Header', ESP = 'El campo Tax Area Code esta vacío en Cabecera Venta ';
        PM03: TextConst ENU = 'The field Ship-to Post Code is empty in Sales Header', ESP = 'El campo Envio Codigo Posta esta vacío en Cabecera Venta ';
        PM04: TextConst ENU = 'The field Bill-to Post Code is empty in Sales Header', ESP = 'El campo Factura a Codigo Postal esta vacío en Cabecera Venta ';
        PM05: TextConst ENU = 'The field Currency Code is empty in Sales Header', ESP = 'El campo Divisa esta vacío en Cabecera Venta ';
        Canceled: TextConst ENU = 'Canceled by user.', ESP = 'Cancelado por el usuario.';
        NoSeriesManagement: Codeunit 396;
        PaymentMethod: Record "Payment Method";

    begin
        // Comprobaciones en Informaci¢n de empresa
        CompanyInfo.GET;
        EI_Setup.GET;

        IF CompanyInfo."VAT Registration No." = '' THEN
            ERROR(CI01);

        //   VATRegistrationType.GET(CompanyInfo."VAT Registration Type");
        //   IF VATRegistrationType."DIAN Code" = '' THEN
        //     ERROR(CO01 + CompanyInfo."VAT Registration Type");

        //   IF VATRegistrationType."DIAN Table 20" = VATRegistrationType."DIAN Table 20"::" " THEN
        //     ERROR(CO02 + CompanyInfo."VAT Registration Type");

        IF CompanyInfo.Name = '' THEN
            ERROR(CI03);

        IF CompanyInfo.Address = '' THEN
            ERROR(CI04);

        IF CompanyInfo.City = '' THEN
            ERROR(CI05);

        IF CompanyInfo."Country/Region Code" = '' THEN
            ERROR(CI06);

        if CompanyInfo."Post Code" = '' then
            Error(CI20);

        IF EI_Setup."Electronic Invoice Company ID" = '' THEN
            ERROR(CI13);

        IF EI_Setup."Elec. Inv. Account ID" = '' THEN
            ERROR(CI14);

        IF (EI_Setup."Use proxy") AND (EI_Setup.Proxy = '') THEN
            ERROR(CI15);

        IF (EI_Setup."Use proxy") AND (EI_Setup.Port = 0) THEN
            ERROR(CI16);

        //>>CO-18-001-03
        IF EI_Setup."Electronic Invoice Endpoint" = '' THEN
            ERROR(CI18);



        if SalesHeader.GET(SalesHeader."Document Type"::Invoice, p_NoDocument) then begin
            // Comprobaciones en Cliente
            Customer.GET(SalesHeader."Bill-to Customer No.");
        end else begin
            if salesHeader.GET(SalesHeader."Document Type"::"Credit Memo", p_NoDocument) then begin
                Customer.GET(SalesHeader."Bill-to Customer No.");
            end;
        end;

        if SalesHeader."Tax Area Code" = '' then
            ERROR(PM02);
        if SalesHeader."Ship-to Post Code" = '' then
            ERROR(PM03);
        if SalesHeader."Bill-to Post Code" = '' then
            ERROR(PM04);

        if SalesHeader."Currency Code" = '' then
            ERROR(PM05);






        IF Customer."VAT Registration No." = '' THEN
            ERROR(CU01);

        IF Customer."Fiscal Regime" = '' THEN
            ERROR(CU02);

        if Customer."Fiscal Responsabilities" = '' then
            error(CU13);

        IF Customer.Name = '' THEN
            ERROR(CU03);

        IF Customer.Address = '' THEN
            ERROR(CU05);

        IF Customer.City = '' THEN
            ERROR(CU06);

        IF Customer."Country/Region Code" = '' THEN
            ERROR(CU07);

        //   ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
        //   ContactBusinessRelation.SETRANGE("No.",Customer."No.");
        //   IF ContactBusinessRelation.FINDFIRST THEN BEGIN
        //     Contact.SETRANGE("Company No.",ContactBusinessRelation."Contact No.");
        //     Contact.SETRANGE("Contact Type Elect. Invoice",Contact."Contact Type Elect. Invoice"::Contact);
        //     IF NOT Contact.FINDFIRST THEN
        //       ERROR(CU09);
        //     IF (Contact."Phone No." = '') AND (Customer."Phone No." = '') THEN BEGIN
        //       IF NOT CONFIRM(CU10,FALSE) THEN
        //         ERROR(Canceled);
        //     END;

        //     IF (Contact."E-Mail" = '') AND (Customer."E-Mail" = '') THEN
        //       ERROR(CU11);
        //   END ELSE
        //     ERROR(CU09);

        //   IF (VATRegistrationType."DIAN Table 20" = VATRegistrationType."DIAN Table 20"::"Legal Entity") AND (Customer."Business Registration No." = '') THEN
        //     ERROR(CU12);

        // Comprobaciones en cabecera

        if SalesHeader."Doc. Type DIAN" = '' then
            error(SE05);


        if salesheader."Doc. Type DIAN" = '02' then begin
            if SalesHeader."Shiptment Port" = '' then
                error(SE06);
            if SalesHeader."Destination Port" = '' then
                error(SE07);
            if SalesHeader."Gross Weight" = '' then
                error(SE08);
            if SalesHeader."Shipping Information" = '' then
                error(SE09);
            if SalesHeader."Net Weight" = '' then
                error(SE10);
        end;
        if (SalesHeader."Doc. Type DIAN" = '91') or (SalesHeader."Doc. Type DIAN" = '92') then
            if SalesHeader."EIConcept" = '' then
                error(SE11);

        //Control Paymenth Method
        PaymentMethod.GET(SalesHeader."Payment Method Code");
        if PaymentMethod."Payment Means" = '' then
            Error(PM01);

        //   IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") OR
        //     (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") OR
        //     (((SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) OR
        //     (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) AND (SalesHeader."Debit Memo"))) AND
        //     (SalesHeader."Applies-to Doc. No." = '') THEN
        //     ERROR(DO01 + FORMAT(SalesHeader."Document Type") + ' ' + SalesHeader."No.");

        //   IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") AND
        //     (SalesHeader."Applies-to Doc. Type" <> SalesHeader."Applies-to Doc. Type"::Invoice)) THEN
        //     ERROR(DO02 + SalesHeader."No.");

        //   IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) OR
        //     (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) AND (SalesHeader."Debit Memo") AND
        //     (SalesHeader."Applies-to Doc. Type" <> SalesHeader."Applies-to Doc. Type"::"Credit Memo") THEN
        //     ERROR(DO03 + SalesHeader."No.");

        // //   IF Currency.GET(SalesHeader."Currency Code") AND (Currency."DIAN Code" = '') THEN
        // //     ERROR(DO04 + SalesHeader."Currency Code");

        //   IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") AND
        //     (NOT SalesInvoiceHeader.GET(SalesHeader."Applies-to Doc. No.")) THEN
        //     ERROR(DO05 + SalesHeader."No.");

        //   IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) OR
        //     (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) AND (SalesHeader."Debit Memo") AND
        //     (NOT SalesCrMemoHeader.GET(SalesHeader."Applies-to Doc. No.")) THEN
        //     ERROR(DO06 + SalesHeader."No.");

        // Comprobaciones en N§ Serie
        NoSeriesLine.SETRANGE("Series Code", SalesHeader."Posting No. Series");
        NoSeriesLine.SETFILTER("Starting No.", '<=%1', NoSeriesManagement.GetNextNo(SalesHeader."Posting No. Series", SalesHeader."Posting Date", FALSE));
        NoSeriesLine.SETFILTER("Ending No.", '>=%1', NoSeriesManagement.GetNextNo(SalesHeader."Posting No. Series", SalesHeader."Posting Date", FALSE));
        IF NoSeriesLine.FINDFIRST THEN BEGIN
            IF NoSeriesLine."Resolution No." = '' THEN
                ERROR(SE01 + SalesHeader."Posting No. Series");

            // IF NoSeriesLine."Resolution Date" = 0D THEN
            //   ERROR(SE02 + SalesHeader."Posting No. Series");

            // IF NoSeriesLine."Resolution Expiration Date" = 0D THEN
            //   ERROR(SE03 + SalesHeader."Posting No. Series");

            // IF (STRLEN(DELCHR(NoSeriesLine."Starting No.",'=','0123456789')) <> 0) AND (NoSeriesLine."Prefix Numbering" = '') THEN
            //   ERROR(SE04 + SalesHeader."Posting No. Series");
        END;

        // Comprobaciones en l¡neas
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER("Unit of Measure Code", '<>%1', '');
        IF SalesLine.FINDFIRST THEN
            REPEAT
                IF UnitOfMeasure.GET(SalesLine."Unit of Measure Code") THEN
                    IF UnitOfMeasure."DIAN Code" = '' THEN
                        ERROR(IT01 + UnitOfMeasure.Code);
            UNTIL SalesLine.NEXT = 0;
    end;

    PROCEDURE GenerateRecordLink(IsVar: Variant);
    VAR

        EISetup: Record 50100;
        RecordLink: Record 2000000068;
        Record: RecordRef;
        Field: FieldRef;
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        ServiceInvoiceHeader: Record 5992;
        ServiceCrMemoHeader: Record 5994;
        XmlFile: File;
        ZipFile: File;
        FileOutStream: OutStream;
        FileInStream: InStream;
        FilePath: Text;
        ZipName: ARRAY[2] OF Text;
        ClientFileName: ARRAY[3] OF Text;
        ServerFileName: ARRAY[3] OF Text;
        XmlName: Text;
        l_OpWebServices: Option Upload,DocumentStatus,Download;
        l_DnetStream: DotNet NETMemory;
        l_DnetArray: DotNet NETArray;
        l_Documents: array[40, 4] OF Text;
        prueba: XmlPort "Export Contact";
        recContact: Record Contact;
        tempBlob: Record TempBlob;
    BEGIN
        IF IsVar.ISRECORD() THEN BEGIN
            Record.GETTABLE(IsVar);
            EISetup.GET();
            //EISetup.TESTFIELD("Electronic Invoice Path");
            // FilePath := EISetup."Electronic Invoice Path";
            // IF COPYSTR(FilePath, STRLEN(FilePath) - 1, 1) <> '\' THEN
            //     FilePath += '\';
            Field := Record.FIELD(3);

            //Assing XML Name
            XmlName := Field.Value();
            XmlName += '.xml';
            tempBlob.blob.CreateOutStream(FileOutStream);
            //Generate Xml File
            //XmlFile.Create('c:\TEMP\prueba.xml');
            //DownloadFromStream(FileInStream, '', FilePath, '', XmlName);
            //XmlFile.CREATEOUTSTREAM(FileOutStream);

            CASE Record.NUMBER OF
                DATABASE::"Sales Invoice Header":
                    BEGIN
                        SalesInvoiceHeader.SETFILTER("No.", FORMAT(Field.VALUE));
                        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Doc. Type DIAN", '91');
                        IF SalesInvoiceHeader.FINDFIRST THEN
                            XMLPORT.EXPORT(XMLPORT::"EI-ExportInvoice", FileOutStream, SalesInvoiceHeader);

                        SalesInvoiceHeader.SETFILTER("No.", FORMAT(Field.VALUE));
                        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Doc. Type DIAN", '92');
                        IF SalesInvoiceHeader.FINDFIRST THEN
                            XMLPORT.EXPORT(XMLPORT::"EI-ExportInvoice", FileOutStream, SalesInvoiceHeader);

                        tempBlob.Blob.CreateInStream(FileInStream);
                    END;
                DATABASE::"Sales Cr.Memo Header":
                    BEGIN
                        SalesCrMemoHeader.SETFILTER("No.", FORMAT(Field.VALUE));
                        //XMLPORT.EXPORT(XMLPORT::"Export Sales Cr.Memo",FileOutStream,SalesCrMemoHeader);
                    END;

            END;
            //XmlFile.CLOSE;

            // WITH RecordLink DO BEGIN
            //     // Insert XML in Record Link
            //     RESET;
            //     SETCURRENTKEY("Record ID");
            //     SETRANGE("Record ID", Record.RECORDID);
            //     SETRANGE(Type, Type::Link);
            //     SETFILTER(Description, '%1', 'Electronic Invoice ' + XmlName);
            //     IF FINDSET THEN BEGIN
            //         URL1 := FilePath + XmlName + '.xml';
            //         MODIFY;
            //     END ELSE BEGIN
            //         INIT;
            //         "Record ID" := Record.RECORDID;
            //         Description := 'Electronic Invoice ' + XmlName;
            //         Type := Type::Link;
            //         "User ID" := USERID;
            //         Created := CURRENTDATETIME;
            //         URL1 := FilePath + XmlName + '.xml';
            //         Company := COMPANYNAME;
            //         INSERT;
            //     END;
            //     COMMIT;

            //     CLEAR(ZipName);
            //     CLEAR(ClientFileName);
            //     CLEAR(ServerFileName);
            // END;
            // COMMIT;

            // Insert file in blob Field
            //ZipFile.OPEN(FORMAT(FilePath + XmlName + '.xml'));
            //ZipFile.CREATEINSTREAM(FileInStream);
            CASE Record.NUMBER OF
                DATABASE::"Sales Invoice Header":
                    BEGIN
                        IF SalesInvoiceHeader.GET(FORMAT(Field.VALUE)) THEN BEGIN
                            SalesInvoiceHeader."Electronic Invoice Status" := SalesInvoiceHeader."Electronic Invoice Status"::"In process";
                            //COPYSTREAM(FileOutStream, FileInStream);
                            SalesInvoiceHeader.MODIFY;
                            //SalesInvoiceHeader.ADDLINK(FilePath + XmlName + '.xml', 'Electronic Invoice Compressed ' + XmlName + '.xml');
                            l_DnetStream := l_DnetStream.MemoryStream;
                            COPYSTREAM(l_DnetStream, FileInStream);
                            l_DnetArray := l_DnetStream.GetBuffer();
                            SendMethod(l_OpWebServices::Upload, XmlName + '.xml', FileInStream, l_DnetArray, SalesInvoiceHeader."No.", l_Documents, 112, 0);
                        END;
                    END;
                DATABASE::"Sales Cr.Memo Header":
                    BEGIN
                        IF SalesCrMemoHeader.GET(FORMAT(Field.VALUE)) THEN BEGIN
                            SalesCrMemoHeader."Electronic Invoice Status" := SalesCrMemoHeader."Electronic Invoice Status"::"In process";
                            //COPYSTREAM(FileOutStream, FileInStream);
                            SalesCrMemoHeader.MODIFY;
                            SalesCrMemoHeader.ADDLINK(FilePath + XmlName + '.xml', 'Electronic Invoice Compressed ' + XmlName + '.xml');
                            l_DnetStream := l_DnetStream.MemoryStream;
                            COPYSTREAM(l_DnetStream, FileInStream);
                            l_DnetArray := l_DnetStream.GetBuffer();
                            SendMethod(l_OpWebServices::Upload, XmlName + '.xml', FileInStream, l_DnetArray, SalesCrMemoHeader."No.", l_Documents, 114, 0);

                        END;
                    END;
            END;
            //ZipFile.CLOSE;
        END;
    END;

    Procedure SendMethod(p_optMethod: Option Upload,DocumentStatus,Download,AvaliableDocument,DownloadDocuments; p_texNombreFichero: Text; p_inFichero: InStream; p_dnetArray: dotnet NETArray; p_numfactura: Code[20]; VAR documentos: ARRAY[40, 4] OF Text; p_tableID: Integer; p_DocumentType: Integer);
    VAR
        XMLDoc: DotNet XmlDocument;
        cuHelper: Codeunit 50101;
        XMLDocResponse: DotNet XmlDocument;
        l_texFicheroB64: Text;
        l_recPurchaseHeader: Record 38;
        l_recSalesInvoice: Record 112;
        l_recSalesCrMemo: Record 114;
        l_recServiceInvoice: Record 5992;
        l_recServiceCrMemo: Record 5994;
        l_recEISetup: Record 50100;
        XMLDOMMgt: Codeunit 6224;
        ResponseText: Text;
        ResponseText2: Text;
        x: Integer;
        posinicio: Integer;
        posfinal: Integer;
        documentnumber: Text;
        documentprefix: Text;
        documenttype: Text;
        senderIdentification: Text;
        senderAccount: Text;
        endpointURL: Text[50];
    BEGIN
        l_recEISetup.GET;
        g_numFactura := p_numfactura;
        endpointURL := l_recEISetup."Electronic Invoice Endpoint";
        CASE p_tableID OF
            //VENTAS Y SERVICIOS
            112:
                BEGIN
                    CASE p_optMethod OF
                        p_optMethod::Upload:
                            BEGIN
                                CLEAR(l_recSalesInvoice);
                                l_recSalesInvoice.GET(p_numfactura);
                                IF l_recSalesInvoice."XML Transaction ID" = '' THEN
                                    UploadMethod(XMLDoc, p_texNombreFichero, '', l_recEISetup."Electronic Invoice Company ID", l_recEISetup."Elec. Inv. Account ID",
                                                 l_recEISetup."Electronic Invoice User", l_recEISetup."Electronic Invoice Pass", p_dnetArray)
                                ELSE
                                    EXIT;
                            END;
                        p_optMethod::DocumentStatus:
                            BEGIN
                                CLEAR(l_recSalesInvoice);
                                l_recSalesInvoice.GET(p_numfactura);
                                IF l_recSalesInvoice."XML Transaction ID" <> '' THEN
                                    DocumentStatusMethod(XMLDoc, l_recEISetup."Electronic Invoice Company ID", l_recEISetup."Elec. Inv. Account ID",
                                                         l_recEISetup."Electronic Invoice User", l_recEISetup."Electronic Invoice Pass", l_recSalesInvoice."XML Transaction ID");
                            END;
                        p_optMethod::DownloadDocuments:
                            BEGIN
                                DownloadDocumentsMethod(XMLDoc, l_recEISetup."Electronic Invoice Company ID", l_recEISetup."Elec. Inv. Account ID",
                                                         l_recEISetup."Electronic Invoice User", l_recEISetup."Electronic Invoice Pass", documentos);
                            END;
                    END;
                    cuHelper.setDataToSend(endpointURL, XMLDoc, g_numFactura, l_recSalesInvoice."XML Transaction ID");
                END;
            114:
                BEGIN
                    CASE p_optMethod OF
                        p_optMethod::Upload:
                            BEGIN
                                CLEAR(l_recSalesCrMemo);
                                l_recSalesCrMemo.GET(p_numfactura);
                                IF l_recSalesCrMemo."XML Transaction ID" = '' THEN
                                    UploadMethod(XMLDoc, p_texNombreFichero, '', l_recEISetup."Electronic Invoice Company ID", l_recEISetup."Elec. Inv. Account ID",
                                                 l_recEISetup."Electronic Invoice User", l_recEISetup."Electronic Invoice Pass", p_dnetArray)
                                ELSE
                                    EXIT;
                            END;
                        p_optMethod::DocumentStatus:
                            BEGIN
                                CLEAR(l_recSalesCrMemo);
                                l_recSalesCrMemo.GET(p_numfactura);
                                IF l_recSalesCrMemo."XML Transaction ID" <> '' THEN
                                    DocumentStatusMethod(XMLDoc, l_recEISetup."Electronic Invoice Company ID", l_recEISetup."Elec. Inv. Account ID",
                                                         l_recEISetup."Electronic Invoice User", l_recEISetup."Electronic Invoice Pass", l_recSalesCrMemo."XML Transaction ID");
                            END;
                        p_optMethod::DownloadDocuments:
                            BEGIN
                                DownloadDocumentsMethod(XMLDoc, l_recEISetup."Electronic Invoice Company ID", l_recEISetup."Elec. Inv. Account ID",
                                                         l_recEISetup."Electronic Invoice User", l_recEISetup."Electronic Invoice Pass", documentos);
                            END;
                    END;
                    cuHelper.setDataToSend(endpointURL, XMLDoc, g_numFactura, l_recSalesCrMemo."XML Transaction ID");
                END;

            ELSE BEGIN
                    ERROR(ErrTableID);
                END;
        END;


        COMMIT;
        IF (cuHelper.Execute) THEN BEGIN
            //IF (cuHelper.RUN) THEN BEGIN
            IF NOT cuHelper.GetExceptionCatched() THEN BEGIN
                //respuesta ok
                cuHelper.GetResponseNode(XMLDocResponse);
                //EN LA VARIABLE TENEMOS EL XML CON LA RESPUESTA
                //availabledocuments
                //XMLDOMMgt.LoadXMLDocumentFromText(ResponseText,XMLDocResponse);
                IF p_optMethod = p_optMethod::AvaliableDocument THEN BEGIN
                    cuHelper.GetDocuments(documentos);
                END;
                //avaliabledocumets
                MESSAGE(MsgOK);
                //XMLDocResponse.Save('E:\test\company\ENVIOS XML\SAVEDATA_response.XML');
            END ELSE BEGIN
                //error ver fault code
                cuHelper.ProcessFaultResponse2013('');
            END;
        END;
    END;




    Local procedure UploadMethod(VAR XMLDoc: DotNet NETXmlDocument; filename: Text; filePath: Text; companyId: Text; accountId: Text; userName: Text; password: Text; dnetArray: DotNet NETArray);
    VAR
        CurrentXMlNode: DotNet NETXMLNode;
        XMLNode: DotNet NETXmlNode;
    BEGIN
        PopulateXmlPrerequisites(XMLDoc, XMLNode, userName, password);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'UploadRequest', '', 'inv', invTxt, CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'fileName', filename, '', XMLNode);


        //XMLDOMManagement.AddElement(CurrentXMlNode, 'fileData', 'xxxxxx', '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'companyId', companyId, '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'accountId', accountId, '', XMLNode);
    END;

    LOCAL PROCEDURE DocumentStatusMethod(VAR XMLDoc: DotNet XmlDocument; companyId: Text; accountId: Text; userName: Text; password: Text; trasID: Text);
    VAR
        CurrentXMlNode: DotNet XmlNode;
        XMLNode: DotNet XmlNode;
    BEGIN
        PopulateXmlPrerequisites(XMLDoc, XMLNode, userName, password);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DocumentStatusRequest', '', 'inv', invTxt, CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'companyId', companyId, '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'accountId', accountId, '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'transactionId', trasID, '', XMLNode);
    END;

    LOCAL PROCEDURE DownloadDocumentsMethod(VAR XMLDoc: DotNet XmlDocument; companyId: Text; accountId: Text; userName: Text; password: Text; VAR documents: ARRAY[100, 4] OF Text);
    VAR
        CurrentXMlNode: DotNet XmlNode;
        XMLNode: DotNet XmlNode;
        x: Integer;
        OpXMlNode: DotNet XmlNode;
    BEGIN
        PopulateXmlPrerequisites(XMLDoc, XMLNode, userName, password);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DownloadAvailableDocumentsRequest', '', 'inv', invTxt, CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'companyId', companyId, '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'resourceType', 'INVOICE_DOCUMENT_TRANSFORMED', '', XMLNode);
        FOR x := 1 TO 10 DO BEGIN
            IF documents[x] [1] <> '' THEN BEGIN
                XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'availableDocument', '', '', '', OpXMlNode);
                XMLDOMManagement.AddElement(OpXMlNode, 'documentNumber', documents[x] [1], '', XMLNode);
                XMLDOMManagement.AddElement(OpXMlNode, 'documentPrefix', documents[x] [2], '', XMLNode);
                XMLDOMManagement.AddElement(OpXMlNode, 'documentType', documents[x] [3], '', XMLNode);
                XMLDOMManagement.AddElement(OpXMlNode, 'senderIdentification', documents[x] [4], '', XMLNode);
            END;
        END;
    END;

    Local procedure PopulateXmlPrerequisites(VAR XMLDoc: DotNet NETXmlDocument; VAR XMLNode: DotNet NETXmlNode; UserName: Text; Password: Text);
    VAR
        RootXMLNode: DotNet NETXmlNode;
        CurrentXMlNode: DotNet XmlNode;
        XMLNamespaceManager: DotNet XmlNamespaceManager;
        typePassword: TextConst ENU = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText';
        encodingTypeNonce: TextConst ENU = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary';
        texto: DotNet NETString;

    BEGIN
        XMLDoc := XMLDoc.XmlDocument;
        XMLDOMManagement.AddRootElementWithPrefix(XMLDoc, 'Envelope', 'soapenv', SoapenvTxt, RootXMLNode);
        XMLDOMManagement.AddAttribute(RootXMLNode, 'xmlns:inv', invTxt);
        XMLDOMManagement.AddAttribute(RootXMLNode, 'xmlns:wsse', wsseTxt);
        XMLDOMManagement.AddAttribute(RootXMLNode, 'xmlns:wsu', wsuTxt);
        XMLDOMManagement.AddDeclaration(XMLDoc, '1.0', 'UTF-8', '');
        XmlNamespaceManager := XmlNamespaceManager.XmlNamespaceManager(RootXMLNode.OwnerDocument.NameTable);
        texto := FORMAT(wsseTxt);
        XMLNamespaceManager.AddNamespace('wsse', texto);
        texto := FORMAT(wsuTxt);
        XMLNamespaceManager.AddNamespace('wsu', texto);

        XMLDOMManagement.AddElementWithPrefix(RootXMLNode, 'Header', '', 'soapenv', SoapenvTxt, CurrentXMlNode);
        //cabecera de seguridad
        XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'Security', '', 'wsse', wsseTxt, CurrentXMlNode);
        XMLDOMManagement.AddAttribute(CurrentXMlNode, 'soapenv:mustUnderstand', '1');
        XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'UsernameToken', '', 'wsse', wsseTxt, CurrentXMlNode);
        XMLDOMManagement.AddAttribute(CurrentXMlNode, 'wsu:Id', GetUserTokenId());
        XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'Username', UserName, 'wsse', wsseTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'Password', GetSHA256String(Password), 'wsse', wsseTxt, XMLNode);
        XMLDOMManagement.AddAttribute(XMLNode, 'Type', typePassword);
        XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'Nonce', GetNonce, 'wsse', wsseTxt, XMLNode);
        //XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode,'Nonce','','wsse',wsseTxt,XMLNode);

        XMLDOMManagement.AddAttribute(XMLNode, 'EncodingType', encodingTypeNonce);
        XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'Created', GetCreatedDT, 'wsu', wsuTxt, XMLNode);


        XMLDOMManagement.AddElementWithPrefix(RootXMLNode, 'Body', '', 'soapenv', SoapenvTxt, CurrentXMlNode);

        XMLNode := CurrentXMlNode;
    END;

    procedure GetSHA256String(phrase: Text): Text;
    var
        i: Integer;
        textreturn: Text;
        sha256Hasher: DotNet sha256Hasher;
        NETArray: DotNet NETArray;
        NETConvert: DotNet NETConvert;
        NETByte: DotNet NETByte;
        NETENcoding: DotNet NETEncoding;
    begin

        sha256Hasher := sha256Hasher.Create();
        NETEncoding := NETEncoding.UTF8Encoding();

        NETArray := sha256Hasher.ComputeHash(NETEncoding.GetBytes(phrase));
        FOR i := 0 TO NETArray.Length - 1 DO BEGIN
            NETByte := NETArray.GetValue(i);
            textReturn += NETByte.ToString('x2');
        END;

        EXIT(textReturn);
    end;

    Local procedure GetUserTokenId(): Text;
    VAR
        NETGuid: DotNet NETGuid;
        phrase: Text;
        textReturn: Text;
    BEGIN
        //NETobject := NETGuid.NewGuid();
        //EXIT(NETobject.ToString());
        textReturn := FORMAT(NETGuid.NewGuid()); //quitamos{}
        textReturn := COPYSTR(textReturn, 2, STRLEN(textReturn) - 2);
        EXIT('UsernameToken-' + textReturn);//  ToString()));
    END;

    Local procedure GetNonce(): Text;
    VAR
        NETGuid: DotNet NETGuid;
        phrase: Text;
        textReturn: Text;
        NETdt: DotNet NETDt;
    BEGIN
        //A¥ADIMOS LA FECHA ACTUAL CON MILESIMAS PARA QUE NO GENERE VALORES IGUALES
        NETdt := NETdt.Now();
        textReturn := FORMAT(NETGuid.NewGuid()); //quitamos{}
        textReturn := COPYSTR(textReturn, 2, STRLEN(textReturn) - 2);
        textReturn := textReturn + '-' + NETdt.ToString('yyyy-MM-ddTHH:mm:ss.fffZ');

        EXIT(GetSHA1String(textReturn));//  ToString())); 
    END;

    Local procedure GetSHA1String(phrase: Text): Text;
    VAR
        sha1Hasher: DotNet sha1Hasher;
        NETArray: DotNet NETArray;
        NETEncoding: DotNet NETEncoding;
        NETConvert: DotNet NETConvert;
    BEGIN
        sha1Hasher := sha1Hasher.Create();
        NETEncoding := NETEncoding.UTF8Encoding();

        NETArray := sha1Hasher.ComputeHash(NETEncoding.GetBytes(phrase));

        EXIT(NETConvert.ToBase64String(NETArray));
    END;

    Local procedure GetCreatedDT(): Text;
    VAR
        NETdt: DotNet NETDt;
        NetString: DotNet NETString;
        NetGloba: DotNet NETGloba;
    BEGIN
        NETdt := NETdt.UTCNow();
        NetString := 'es-CO';
        NetGloba := NetGloba.CultureInfo(NetString);
        //OJO ZONA HORARIA PONER LA QUE CORRESPONDA - ESPA¥A +01
        //Message(NETdt.ToString('yyyy-MM-ddTHH:mm:ss.fffZ'));

        //EXIT(NETdt.ToString('yyyy-MM-ddTHH:mm:ss.fffZ'));
        //DESCOMENTAR SIGUIENTE LÖNEA  Y COMENTAR LA ANTERIOR PARA PROVOCAR UN SOAP FAULT
        EXIT(NETdt.ToString('yyyy-MM-ddTHH:mm:ss.fffZ', NetGloba));
    END;

    Local procedure GetFileB64String(NETArray: DotNet NETArray): Text;
    VAR
        NETEncoding: DotNet NETEncoding;
        NETConvert: DotNet NETConvert;
        NETFile: DotNet NETFile;
        l_bigText: BigText;
    BEGIN
        //l_BigText.WRITE(OutStream)
        //NETArray := NETFile.ReadAllBytes(filePath);

        EXIT(NETConvert.ToBase64String(NETArray));
    END;

}