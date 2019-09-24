codeunit 50101 "FAE-WS Response"
{
    trigger OnRun()
    begin

    end;

    var
        CompanyInformation: Record 79;
        XMLDocGl: DotNet XmlDocument;
        endpointURL: Text;
        ContentTypeTxt: TextConst ENU = '"multipart/form-data; charset=utf-8"';
        XMLResponseGl: DotNet XmlDocument;
        ServiceURLTxt: TextConst ENU = '\\Service URL: %1.';
        ConnectionErr: TextConst ENU = 'Connection to the remote service could not be established.\\';
        FaultStringXmlPathTxt: TextConst ENU = '/soap:Envelope/soap:Body/soap:Fault/faultstring';
        SoapNamespaceTxt: TextConst ENU = 'http://schemas.xmlsoap.org/soap/envelope/';
        InternalErr: TextConst ENU = 'The remote service has returned the following error message:\\';
        DotNetExceptionGl: DotNet DotNetExceptionGl;
        IsExceptionCatched: Boolean;
        IdTransac: Text;
        g_NumFactura: Code[20];
        //g_cuElectronicInvoice : Codeunit 53000;
        document: array[40, 4] OF Text;


    PROCEDURE Execute(): Boolean;
    BEGIN
        IsExceptionCatched := FALSE;
        InvokeSoapRequest(XMLDocGl);
        EXIT(TRUE);
    END;

    PROCEDURE GetExceptionCatched(): Boolean;
    BEGIN
        EXIT(IsExceptionCatched);
    END;

    PROCEDURE GetResponseNode(VAR XMLNode: DotNet XmlDocument);
    BEGIN
        XMLNode := XMLResponseGl;
    END;

    PROCEDURE GetDocuments(VAR documents: ARRAY[40, 4] OF Text);
    VAR
        x: Integer;
    BEGIN
        FOR x := 1 TO 40 DO BEGIN
            documents[x] [1] := document[x] [1];
            documents[x] [2] := document[x] [2];
            documents[x] [3] := document[x] [3];
            documents[x] [4] := document[x] [4];

        END;
    END;

    procedure InvokeSoapRequest(XMLDoc: DotNet NETXmlDocument);
    var
        ResponseInStreamTempBlob: Record TempBlob;
        HttpWebRequest: DotNet NETHttpWebRequest;
        HttpWebResponse: DotNet NetHttpWebResponse;
        StatusCode: DotNet StatusCode;
        WebServiceUrl: Text;
        StatusDescription: Text;
        ResponseText: Text;
        DecompressionMethods: DotNet NETDecompressionMethods;
        ResponseInStream: InStream;
        parsedResponse: Text;
        Proxy: DotNet Proxy;

    Begin
        WebServiceUrl := endpointURL;

        //Construcci¢n  Proxy
        CompanyInformation.GET();

        IF CompanyInformation."Use proxy" THEN
            Proxy := Proxy.WebProxy(CompanyInformation.Proxy, CompanyInformation.Port);

        HttpWebRequest := HttpWebRequest.Create(WebServiceUrl);
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.KeepAlive := TRUE;
        HttpWebRequest.AllowAutoRedirect := TRUE;
        HttpWebRequest.UseDefaultCredentials := TRUE;
        HttpWebRequest.ContentType := FORMAT(ContentTypeTxt);
        HttpWebRequest.Timeout := 600000;
        HttpWebRequest.AutomaticDecompression := DecompressionMethods.GZip;
        IF CompanyInformation."Use proxy" THEN
            HttpWebRequest.Proxy := Proxy;


        XMLDoc.Save(HttpWebRequest.GetRequestStream());
        ResponseInStreamTempBlob.INIT();
        ResponseInStreamTempBlob.Blob.CREATEINSTREAM(ResponseInStream);

        IF NOT trygetresponse(HttpWebRequest, HttpWebResponse) THEN
            //ERROR DE COMUNICACIàN
            EXIT;


        StatusCode := HttpWebResponse.StatusCode();
        StatusDescription := HttpWebResponse.StatusDescription();
        ResponseText := ReadHttpResponseAsText(HttpWebResponse);


        IF NOT StatusCode.Equals(StatusCode.Accepted) AND NOT StatusCode.Equals(StatusCode.OK) THEN
            //PROCESAR ERROR EN RESPUESTA
            EXIT;

        //PROCESAR RESPUESTA OK
        IF STRPOS(ResponseText, 'Content-Type: application/xop+xml') <> 0 THEN BEGIN
            parsedResponse := COPYSTR(ResponseText, STRPOS(ResponseText, '<soap:'));
            parsedResponse := '<?xml version="1.0" encoding="utf-8"?>' + COPYSTR(parsedResponse, 1, STRPOS(parsedResponse, '</soap:Envelope>')) + '/soap:Envelope>';
        END ELSE
            parsedResponse := ResponseText;

        //EXTRAER PETICION OK
        ExtractContentFromResponse(parsedResponse);
    END;

    LOCAL PROCEDURE ExtractContentFromResponse(ResponseText: Text);
    VAR

        CProcessing: TextConst ENU = 'Processing';
        COK: TextConst ENU = 'Ok process';
        XMLDOMMgt: Codeunit 6224;
        pos: Integer;
        posinicio: Integer;
        posfinal: Integer;
        estadoproceso: Text;
        estado: Text;
        Status: Option OK,FAIL,PROCESSING;
        descripcion: Text;
        descripcionproceso: Text;
        documentnumber: Text;
        documentprefix: Text;
        documenttype: Text;
        senderIdentification: Text;
        x: Integer;
        lenresponse: Integer;
        ResponseText2: Text;

    BEGIN
        XMLDOMMgt.LoadXMLDocumentFromText(ResponseText, XMLResponseGl);
        IF STRPOS(ResponseText, '<transactionId>') <> 0 THEN BEGIN
            pos := STRPOS(ResponseText, '</transactionId>');
            IdTransac := COPYSTR(ResponseText, STRPOS(ResponseText, '<transactionId>') + 15, 32);
            SalesUploadResponse(g_NumFactura, IdTransac);
        END;

        IF STRPOS(ResponseText, '<processStatus>') <> 0 THEN BEGIN
            posinicio := STRPOS(ResponseText, '<processStatus>') + 15;
            posfinal := STRPOS(ResponseText, '</processStatus>');
            estadoproceso := COPYSTR(ResponseText, posinicio, posfinal - posinicio);
            IF STRPOS(ResponseText, '<errorMessage>') <> 0 THEN BEGIN
                posinicio := STRPOS(ResponseText, '<errorMessage>') + 14;
                posfinal := STRPOS(ResponseText, '</errorMessage>');
                descripcionproceso := COPYSTR(ResponseText, posinicio, posfinal - posinicio);
            END;
            IF estadoproceso = 'PROCESSING' THEN
                SalesDocumentStatusResponse(IdTransac, Status::PROCESSING, CProcessing);
            IF estadoproceso = 'OK' THEN
                SalesDocumentStatusResponse(IdTransac, Status::PROCESSING, COK);
            IF estadoproceso = 'FAIL' THEN
                SalesDocumentStatusResponse(IdTransac, Status::FAIL, descripcionproceso);

        END;

        IF STRPOS(ResponseText, '<governmentResponseDescription>') <> 0 THEN BEGIN
            posinicio := STRPOS(ResponseText, '<governmentResponseDescription>') + 31;
            posfinal := STRPOS(ResponseText, '</governmentResponseDescription>');
            descripcion := COPYSTR(ResponseText, posinicio, posfinal - posinicio);
        END;

        IF STRPOS(ResponseText, '<legalStatus>') <> 0 THEN BEGIN
            posinicio := STRPOS(ResponseText, '<legalStatus>') + 13;
            posfinal := STRPOS(ResponseText, '</legalStatus>');
            estado := COPYSTR(ResponseText, posinicio, posfinal - posinicio);
            IF estado = 'RECEIVED' THEN
                SalesDocumentStatusResponse(IdTransac, Status::PROCESSING, descripcion);
            IF estado = 'ACCEPTED' THEN
                SalesDocumentStatusResponse(IdTransac, Status::OK, descripcion);
            IF estado = 'REJECTED' THEN BEGIN
                IF STRPOS(ResponseText, '<errorMessage>') <> 0 THEN BEGIN
                    posinicio := STRPOS(ResponseText, '<errorMessage>') + 14;
                    posfinal := STRPOS(ResponseText, '</errorMessage>');
                    descripcion := COPYSTR(ResponseText, posinicio, posfinal - posinicio);
                END;
                SalesDocumentStatusResponse(IdTransac, Status::FAIL, descripcion);
            END;
        END;

        ResponseText2 := ResponseText;
        x := 1;
        WHILE STRPOS(ResponseText2, '<documentNumber>') <> 0 DO BEGIN
            posinicio := STRPOS(ResponseText2, '<documentNumber>') + 16;
            posfinal := STRPOS(ResponseText2, '</documentNumber>');
            documentnumber := COPYSTR(ResponseText2, posinicio, posfinal - posinicio);
            document[x] [1] := documentnumber;
            IF STRPOS(ResponseText2, '<documentPrefix>') <> 0 THEN BEGIN
                posinicio := STRPOS(ResponseText2, '<documentPrefix>') + 16;
                posfinal := STRPOS(ResponseText2, '</documentPrefix>');
                documentprefix := COPYSTR(ResponseText2, posinicio, posfinal - posinicio);
                document[x] [2] := documentprefix;
            END;
            IF STRPOS(ResponseText2, '<documentType>') <> 0 THEN BEGIN
                posinicio := STRPOS(ResponseText2, '<documentType>') + 14;
                posfinal := STRPOS(ResponseText2, '</documentType>');
                documenttype := COPYSTR(ResponseText2, posinicio, posfinal - posinicio);
                document[x] [3] := documenttype;
            END;
            IF STRPOS(ResponseText2, '<senderIdentification>') <> 0 THEN BEGIN
                posinicio := STRPOS(ResponseText2, '<senderIdentification>') + 22;
                posfinal := STRPOS(ResponseText2, '</senderIdentification>');
                senderIdentification := COPYSTR(ResponseText2, posinicio, posfinal - posinicio);
                document[x] [4] := senderIdentification;
            END;
            lenresponse := STRLEN(ResponseText2);
            ResponseText2 := DELSTR(ResponseText2, 1, posfinal + 22);
            x += 1;
        END;
    END;

    PROCEDURE SalesUploadResponse(CodeDocument: Code[20]; XMLTransactionID: Text[50]);
    VAR
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
    BEGIN
        IF SalesInvoiceHeader.GET(CodeDocument) THEN BEGIN
            SalesInvoiceHeader."XML Transaction ID" := XMLTransactionID;
            SalesInvoiceHeader.MODIFY();
        END ELSE BEGIN
            IF SalesCrMemoHeader.GET(CodeDocument) THEN BEGIN
                SalesCrMemoHeader."XML Transaction ID" := XMLTransactionID;
                SalesCrMemoHeader.MODIFY();
            end;
        END;
    END;

    PROCEDURE SalesDocumentStatusResponse(TransactionID: Text; Status: Option OK,FAIL,PROCESSING,REJECTED; StatusError: Text);
    VAR
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
    BEGIN
        SalesInvoiceHeader.SETRANGE("XML Transaction ID", TransactionID);
        IF SalesInvoiceHeader.FINDFIRST() THEN BEGIN
            CASE Status OF
                Status::OK:
                    BEGIN
                        SalesInvoiceHeader."Electronic Invoice Status" := SalesInvoiceHeader."Electronic Invoice Status"::Accepted;
                        SalesInvoiceHeader."Elec. Invoice Stat. Error" := COPYSTR(StatusError, 1, 250);
                        SalesInvoiceHeader."Elec. Invoice Stat. Error 2" := COPYSTR(StatusError, 251, 250);
                        SalesInvoiceHeader.MODIFY();
                    END;
                Status::REJECTED:
                    BEGIN
                        SalesInvoiceHeader."Electronic Invoice Status" := SalesInvoiceHeader."Electronic Invoice Status"::Rejected;
                        SalesInvoiceHeader."Elec. Invoice Stat. Error" := COPYSTR(StatusError, 1, 250);
                        SalesInvoiceHeader."Elec. Invoice Stat. Error 2" := COPYSTR(StatusError, 251, 250);
                        SalesInvoiceHeader.MODIFY;
                    END;
                Status::PROCESSING:
                    BEGIN
                        SalesInvoiceHeader."Electronic Invoice Status" := SalesInvoiceHeader."Electronic Invoice Status"::"In process";
                        SalesInvoiceHeader."Elec. Invoice Stat. Error" := COPYSTR(StatusError, 1, 250);
                        SalesInvoiceHeader."Elec. Invoice Stat. Error 2" := COPYSTR(StatusError, 251, 250);
                        SalesInvoiceHeader.MODIFY;
                    END;
                Status::FAIL:
                    BEGIN
                        SalesInvoiceHeader."Electronic Invoice Status" := SalesInvoiceHeader."Electronic Invoice Status"::Fail;
                        SalesInvoiceHeader."Elec. Invoice Stat. Error" := COPYSTR(StatusError, 1, 250);
                        SalesInvoiceHeader."Elec. Invoice Stat. Error 2" := COPYSTR(StatusError, 251, 250);
                        SalesInvoiceHeader.MODIFY;
                    END;
            END;
            EXIT;
        END;

        SalesCrMemoHeader.SETRANGE("XML Transaction ID", TransactionID);
        IF SalesCrMemoHeader.FINDFIRST() THEN BEGIN
            CASE Status OF
                Status::OK:
                    BEGIN
                        SalesCrMemoHeader."Electronic Invoice Status" := SalesCrMemoHeader."Electronic Invoice Status"::Accepted;
                        SalesCrMemoHeader."Elec. Invoice Stat. Error" := COPYSTR(StatusError, 1, 250);
                        SalesCrMemoHeader."Elec. Invoice Stat. Error 2" := COPYSTR(StatusError, 251, 250);
                        SalesCrMemoHeader.MODIFY;
                    END;
                Status::REJECTED:
                    BEGIN
                        SalesCrMemoHeader."Electronic Invoice Status" := SalesCrMemoHeader."Electronic Invoice Status"::Rejected;
                        SalesCrMemoHeader."Elec. Invoice Stat. Error" := COPYSTR(StatusError, 1, 250);
                        SalesCrMemoHeader."Elec. Invoice Stat. Error 2" := COPYSTR(StatusError, 251, 250);
                        SalesCrMemoHeader.MODIFY;
                    END;
                Status::PROCESSING:
                    BEGIN
                        SalesCrMemoHeader."Electronic Invoice Status" := SalesCrMemoHeader."Electronic Invoice Status"::"In process";
                        SalesCrMemoHeader."Elec. Invoice Stat. Error" := COPYSTR(StatusError, 1, 250);
                        SalesCrMemoHeader."Elec. Invoice Stat. Error 2" := COPYSTR(StatusError, 251, 250);
                        SalesCrMemoHeader.MODIFY;
                    END;
                Status::FAIL:
                    BEGIN
                        SalesCrMemoHeader."Electronic Invoice Status" := SalesCrMemoHeader."Electronic Invoice Status"::Fail;
                        SalesCrMemoHeader."Elec. Invoice Stat. Error" := COPYSTR(StatusError, 1, 250);
                        SalesCrMemoHeader."Elec. Invoice Stat. Error 2" := COPYSTR(StatusError, 251, 250);
                        SalesCrMemoHeader.MODIFY;
                    END;
            END;
            EXIT;
        END;
    END;

    local procedure trygetresponse(var httpwebrequest: DotNet HttpWebRequest; var httpwebresponse: dotnet HttpWebResponse): Boolean;
    var
        task: DotNet Task;
    begin
        Task := HttpWebRequest.GetResponseAsync();

        WHILE NOT Task.IsCompleted() DO BEGIN

        END;

        IF Task.IsFaulted() THEN BEGIN
            DotNetExceptionGl := Task.Exception().InnerException();
            IsExceptionCatched := TRUE;
            EXIT(FALSE);
        END ELSE
            HttpWebResponse := Task.Result();

        EXIT(TRUE);
    end;

    LOCAL PROCEDURE ReadHttpResponseAsText(HttpWebResponse: DotNet HttpWebResponse) ResponseText: Text;
    VAR
        StreamReader: DotNet StreamReader;
    BEGIN
        StreamReader := StreamReader.StreamReader(HttpWebResponse.GetResponseStream());
        ResponseText := StreamReader.ReadToEnd();
    END;

    procedure setDataToSend(endpointURLLocal: Text; XMLDocLocal: DotNet NETXmlDocument; pnumfactura: Code[20]; idTra: Text);
    begin
        endpointURL := endpointURLLocal;
        XMLDocGl := XMLDocLocal;
        g_NumFactura := pnumfactura;
        IdTransac := idTra;
    end;

    PROCEDURE ProcessFaultResponse2013(SupportInfo: Text);
    VAR
        XMLDOMMgt: Codeunit 6224;
        WebException: DotNet NetWebException;
        WebExceptionStatus: DotNet NETWebExceptionStatus;
        HttpWebResponseError: DotNet HttpWebResponse;
        HttpStatusCode: DotNet StatusCode;
        XmlNode: DotNet XmlNode;
        ErrorText: Text;
        ServiceURL: Text;
        ResponseText: Text;
        parsedResponse: Text;
        l_recSalesInvoice: Record 112;
    BEGIN
        WebException := DotNetExceptionGl;

        IF NOT ISNULL(WebException.Response) THEN
            IF NOT ISNULL(WebException.Response.ResponseUri) THEN
                ServiceURL := STRSUBSTNO(ServiceURLTxt, WebException.Response.ResponseUri.AbsoluteUri);

        ErrorText := ConnectionErr + WebException.Message + ServiceURL;
        IF NOT WebException.Status.Equals(WebExceptionStatus.ProtocolError) THEN
            ERROR(ErrorText);

        IF ISNULL(WebException.Response) THEN
            ERROR('Error en la respuesta. Fault code vac¡o');

        HttpWebResponseError := WebException.Response;
        IF NOT (HttpWebResponseError.StatusCode.Equals(HttpStatusCode.Found) OR
                HttpWebResponseError.StatusCode.Equals(HttpStatusCode.InternalServerError))
        THEN
            ERROR(ErrorText);

        ResponseText := ReadHttpResponseAsText(WebException.Response);
        //PROCESAR RESPUESTA OK
        IF STRPOS(ResponseText, 'Content-Type: application/xop+xml') <> 0 THEN BEGIN
            parsedResponse := COPYSTR(ResponseText, STRPOS(ResponseText, '<soap:'));
            parsedResponse := COPYSTR(parsedResponse, 1, STRPOS(parsedResponse, '</soap:Envelope>')) + '/soap:Envelope>';
        END ELSE
            parsedResponse := ResponseText;

        XMLDOMMgt.LoadXMLNodeFromText(parsedResponse, XmlNode);

        ErrorText := XMLDOMMgt.FindNodeTextWithNamespace(XmlNode, FaultStringXmlPathTxt, 'soap', SoapNamespaceTxt);
        IF ErrorText = '' THEN
            ErrorText := WebException.Message;

        //ERROR
        CLEAR(l_recSalesInvoice);
        IF l_recSalesInvoice.GET(g_NumFactura) THEN BEGIN
            l_recSalesInvoice."Electronic Invoice Status" := l_recSalesInvoice."Electronic Invoice Status"::Rejected;
            l_recSalesInvoice."Elec. Invoice Stat. Error" := ErrorText;
            l_recSalesInvoice.MODIFY;
        END;
        ErrorText := InternalErr + ErrorText + ServiceURL;

        IF SupportInfo <> '' THEN
            ErrorText += '\\' + SupportInfo;

        ERROR(ErrorText);
    END;
}