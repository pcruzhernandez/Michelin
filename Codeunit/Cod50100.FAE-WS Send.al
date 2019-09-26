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
            EISetup.TESTFIELD("Electronic Invoice Path");
            FilePath := EISetup."Electronic Invoice Path";
            IF COPYSTR(FilePath, STRLEN(FilePath) - 1, 1) <> '\' THEN
                FilePath += '\';
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
                        //recContact.get('CT200081');
                        SalesInvoiceHeader.SETFILTER("No.", FORMAT(Field.VALUE));
                        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Doc. Type DIAN", '91');
                        IF SalesInvoiceHeader.FINDFIRST THEN
                            //XMLPORT.EXPORT(XMLPORT::"Export Sales Invoice",FileOutStream,SalesInvoiceHeader);
                            XMLPORT.EXPORT(XMLPORT::"Export Contact", FileOutStream, recContact);

                        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Doc. Type DIAN", '92');
                        //IF SalesInvoiceHeader.FINDFIRST THEN
                        //XMLPORT.EXPORT(XMLPORT::"Export Sales Debit Memo",FileOutStream,SalesInvoiceHeader);
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
                            COPYSTREAM(FileOutStream, FileInStream);
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