codeunit 70002 "Magento Req Mgmt"
{


    local procedure CallWebServices(Body: Text; Instream1: InStream): Boolean
    var
        MagentoSetup: Record "Magento  Setup";
        lXmlDocument: XmlDocument;
        lEnvolopeXmlNode: XmlNode;
        lHeaderXmlNode: XmlNode;
        lBodyXmlNode: XmlNode;
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        lXMLText: Text;
        ResponseXMLText: Text;
        AuthString: Text;
        Cinvert: Codeunit "Base64 Convert";
        url: Text;
        //  HttpsContent: HttpContent;
        InputText: Text;

    begin
        MagentoSetup.Get();
        MagentoSetup.TestField(Password);
        MagentoSetup.TestField(APIKey);

        url := MagentoSetup.URL;
        RequestMessage.SetRequestUri(URL);
        RequestMessage.Method('POST');
        //   SampleText := '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"> <Body><login xmlns="urn:Magento"><username>erp_test</username><apiKey>cbDtek9Kg8y2N7u2Ytxu</apiKey></login></Body></Envelope>';
        Content.WriteFrom(Body);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        //  Headers.Add('Content-Type', 'text/xml;action=login');
        Headers.Add('Content-Type', 'text/xml');
        RequestMessage.Content := Content;

        // HTTPClient.send(RequestMessage, ResponseMessage);

        IF not HttpClient.Post(URL, Content, ResponseMessage) THEN BEGIN
            Message('Fail %1', format(ResponseMessage.HttpStatusCode));
            exit(false);
        end
        else begin
            if ResponseMessage.IsSuccessStatusCode() then begin
                ResponseMessage.Content().ReadAs(Instream1);
                ResponseMessage.Content().ReadAs(inputtext);
                Message(InputText);
                exit(true)
            end;
            if not ResponseMessage.IsSuccessStatusCode then begin
                ResponseMessage.Content.ReadAs(Instream1);
                Message('The web service returned an error message:\\' +
                      'Status code: %1\' +
                      'Description: %2\' + 'Reason %3',
                      ResponseMessage.HttpStatusCode,

            ResponseMessage.ReasonPhrase, Instream1);
                exit(false);


            end;
        end;
    end;


    procedure GetItem(Filters: Text; StoreView: Text[1])
    var
        MSetup: Record "Magento  Setup";
    begin
        MSetup.Get();
        MSetup.TestField("Item Template");
        IF SendLoginRequest THEN BEGIN
            GetItemDetails(Filters, StoreView);
            EndLoginRequest();
        END;
        COMMIT;
    end;

    procedure SendLoginRequest(): Boolean
    var
        WebReq: Codeunit "Magento Request Creation";
        SuccessNodeText: Label 'ns1:loginResponse';
        ReqText: Text;
        Instream1: InStream;
        OInstream: InStream;
    begin
        ReqText := WebReq.Login();
        IF CallWebServices(ReqText, Instream1) THEN BEGIN
            if not ReadError(Instream1) then begin
                ReadSession(Instream1);
                exit(true);
            end
            else
                exit(false)

        end
        else begin
            exit(false);
            InsertWebTxnLog('Error : Login', 2, 2, '', '', '', SessionInfo."Session ID", '');

        end;
    end;

    procedure GetItemDetails(filters: Text; storeview: Text[1]): Boolean
    var
        WebReq: Codeunit "Magento Request Creation";
        SuccessNodeText: Label 'ns1:loginResponse';
        ReqText: Text;
        Instream1: InStream;
        OInstream: InStream;
    begin
        ReqText := WebReq.ProductList(filters, SessionInfo."Session ID", storeview);
        IF CallWebServices(ReqText, Instream1) THEN BEGIN
            if not ReadError(Instream1) then begin
                ReadItemList(Instream1);
                exit(true);
            end
            else
                exit(false)

        end
        else begin
            exit(false);
            InsertWebTxnLog('Item:Receive Web Error', 2, 2, '', '', '', SessionInfo."Session ID", '');

        end;
    end;

    procedure EndLoginRequest(): Boolean
    var
        WebReq: Codeunit "Magento Request Creation";
        SuccessNodeText: Label 'ns1:loginResponse';
        ReqText: Text;
        Instream1: InStream;
        OInstream: InStream;
    begin
        ReqText := WebReq.EndSession(SessionInfo."Session ID");
        IF CallWebServices(ReqText, Instream1) THEN BEGIN
            if not ReadError(Instream1) then begin
                ReadEndSession(Instream1);
                exit(true);
            end else
                exit(false)
        end
        else
            exit(false);
    end;


    local procedure ReadError(Inst: InStream): Boolean
    var
        XmlNamaespaceManager: XmlNamespaceManager;
        XmlDoc: XmlDocument;
        XmlNList: XmlNodeList;
        Node: XmlNode;
        eNode: XmlElement;
        ProdID: Text;
        Outs: OutStream;
        TempB: Codeunit "Temp Blob";
        Instream2: InStream;
        NewInstream: InStream;
    begin
        NewInstream := Inst;
        ProdID := RemoveNamespaces(NewInstream);


        TempB.CreateOutStream(Outs);
        Outs.WriteText(ProdID);


        TempB.CreateInStream(Instream2);


        if Instream2.EOS then
            Error('Cannot Read Blank Stream');
        if XmlDocument.ReadFrom(Instream2, XmlDoc) then begin
            XmlNamaespaceManager.NameTable(XmlDoc.NameTable);
            XmlNamaespaceManager.AddNamespace('SOAP-ENV', 'http://schemas.xmlsoap.org/soap/envelope/');
            XmlNamaespaceManager.AddNamespace('ns1:salesOrderListResponse', 'http://schemas.xmlsoap.org/soap/envelope/');
            XmlNamaespaceManager.AddNamespace('ns1', 'http://schemas.xmlsoap.org/soap/envelope/');
            if XmlDoc.SelectNodes('/Envelope/Body/Fault', XmlNamaespaceManager, XmlNList) then
                foreach Node in XmlNList do begin
                    eNode := Node.AsXmlElement();
                    InsertWebTxnLog('Fault Code', 0, 2, GetText(eNode, 'faultcode'), GetText(eNode, 'faultstring'), '', SessionInfo."Session ID", '');
                    exit(true);
                end;
        end
        else
            exit(false)
    end;

    local procedure ReadSession(Inst2: InStream): Boolean
    var
        myInt: Integer;
        XmlNamaespaceManager: XmlNamespaceManager;
        XmlDoc: XmlDocument;
        XmlNList: XmlNodeList;
        Node: XmlNode;
        eNode: XmlElement;
        XmlBuff: Record "XML Buffer";
        ProdID: Text;
        Outs: OutStream;
        TempB: Codeunit "Temp Blob";
        Instream2: InStream;
        NewInstream: InStream;
    begin
        NewInstream := Inst2;
        ProdID := RemoveNamespaces(NewInstream);


        TempB.CreateOutStream(Outs);
        Outs.WriteText(ProdID);


        TempB.CreateInStream(Instream2);


        if Instream2.EOS then
            Error('Cannot Read Blank Stream');

        if XmlDocument.ReadFrom(Instream2, XmlDoc) then begin
            XmlNamaespaceManager.NameTable(XmlDoc.NameTable);
            XmlNamaespaceManager.AddNamespace('SOAP-ENV', 'http://schemas.xmlsoap.org/soap/envelope/');
            XmlNamaespaceManager.AddNamespace('ns1:loginResponse', 'http://schemas.xmlsoap.org/soap/envelope/');
            //  XmlNamaespaceManager.AddNamespace('ns1:catalogProductListResponse', '');
            // XmlNamaespaceManager.AddNamespace('nrg', 'http://www.dnbnordic.com/nrg');
            XmlNamaespaceManager.AddNamespace('ns1', 'http://schemas.xmlsoap.org/soap/envelope/');
            if XmlDoc.SelectNodes('/Envelope/Body/loginResponse', XmlNamaespaceManager, XmlNList) then
                foreach Node in XmlNList do begin
                    eNode := Node.AsXmlElement();
                    InsertSessionDetails(GetText(eNode, 'loginReturn'));
                    InsertWebTxnLog('Session Created', 2, 1, '', '', '', SessionInfo."Session ID", '');
                    exit(true);
                end;
        end
        else
            exit(false)
    end;

    local procedure ReadItemList(Inst2: InStream): Boolean
    var
        myInt: Integer;
        XmlNamaespaceManager: XmlNamespaceManager;
        XmlDoc: XmlDocument;
        XmlNList: XmlNodeList;
        Node: XmlNode;
        XmlNList2: XmlNodeList;
        Node2: XmlNode;
        XmlNList1: XmlNodeList;
        Node1: XmlNode;
        XmlNList3: XmlNodeList;
        Node3: XmlNode;
        eNode: XmlElement;
        eNode1: XmlElement;
        eNode2: XmlElement;
        eNode3: XmlElement;
        XmlBuff: Record "XML Buffer";
        ProdID: Text;
        Outs: OutStream;
        TempB: Codeunit "Temp Blob";
        Instream2: InStream;
        NewInstream: InStream;
        TotalCount: Integer;
    begin
        NewInstream := Inst2;
        ProdID := RemoveNamespaces(NewInstream);


        TempB.CreateOutStream(Outs);
        Outs.WriteText(ProdID);


        TempB.CreateInStream(Instream2);


        if Instream2.EOS then
            Error('Cannot Read Blank Stream');


        if XmlDocument.ReadFrom(Instream2, XmlDoc) then begin
            XmlNamaespaceManager.NameTable(XmlDoc.NameTable);
            //   XmlNamaespaceManager.AddNamespace('SOAP-ENV', 'http://schemas.xmlsoap.org/soap/envelope/');
            //   XmlNamaespaceManager.AddNamespace('ns1:loginResponse', 'http://schemas.xmlsoap.org/soap/envelope/');
            //   XmlNamaespaceManager.AddNamespace('ns1', 'http://schemas.xmlsoap.org/soap/envelope/');
            //   XmlNamaespaceManager.NameTable(XmlDoc.NameTable);
            TotalCount := 0;
            if XmlDoc.SelectNodes('/Envelope/Body/catalogProductListResponse/storeView/item', XmlNamaespaceManager, XmlNList) then begin
                foreach Node in XmlNList do begin
                    eNode := Node.AsXmlElement();
                    if eNode.SelectNodes('website_ids', XmlNamaespaceManager, XmlNList1) then begin
                        foreach Node1 in XmlNList1 do begin
                            eNode1 := Node1.AsXmlElement();
                        end;


                        if eNode.SelectNodes('category_ids', XmlNamaespaceManager, XmlNList2) then begin
                            foreach Node2 in XmlNList2 do begin
                                eNode2 := Node2.AsXmlElement();
                            end;
                        end;
                        InsertWebTxnLog('Item Created', 2, 1, '', '', '', SessionInfo."Session ID", GetText(eNode, 'product_id'));
                        TotalCount += 1;
                    end;
                end
            end;
            if TotalCount > 0 then
                exit(true)
            else
                exit(false);
        end
        else
            exit(false)
    end;



    local procedure ReadEndSession(Inst2: InStream): Boolean
    var
        myInt: Integer;
        XmlNamaespaceManager: XmlNamespaceManager;
        XmlDoc: XmlDocument;
        XmlNList: XmlNodeList;
        Node: XmlNode;
        eNode: XmlElement;
        XmlBuff: Record "XML Buffer";
        ProdID: Text;
        Outs: OutStream;
        TempB: Codeunit "Temp Blob";
        Instream2: InStream;
        NewInstream: InStream;
    begin

        NewInstream := Inst2;
        ProdID := RemoveNamespaces(NewInstream);


        TempB.CreateOutStream(Outs);
        Outs.WriteText(ProdID);


        TempB.CreateInStream(Instream2);


        if Instream2.EOS then
            Error('Cannot Read Blank Stream');

        if XmlDocument.ReadFrom(Instream2, XmlDoc) then begin
            XmlNamaespaceManager.NameTable(XmlDoc.NameTable);
            XmlNamaespaceManager.AddNamespace('SOAP-ENV', 'http://schemas.xmlsoap.org/soap/envelope/');
            XmlNamaespaceManager.AddNamespace('ns1:loginResponse', 'http://schemas.xmlsoap.org/soap/envelope/');
            //  XmlNamaespaceManager.AddNamespace('ns1:catalogProductListResponse', '');
            // XmlNamaespaceManager.AddNamespace('nrg', 'http://www.dnbnordic.com/nrg');
            XmlNamaespaceManager.AddNamespace('ns1', 'http://schemas.xmlsoap.org/soap/envelope/');
            if XmlDoc.SelectNodes('/Envelope/Body/endSessionResponse', XmlNamaespaceManager, XmlNList) then
                foreach Node in XmlNList do begin
                    eNode := Node.AsXmlElement();
                    InsertWebTxnLog('Session Ended', 2, 1, '', '', '', SessionInfo."Session ID", '');
                    exit(true);
                end;
        end
        else
            exit(false)
    end;


    procedure InsertSessionDetails(LoginID: Text[100]): Boolean
    var

        EntryNo: Integer;
    begin

        SessionInfo.INIT;
        SessionInfo."Session ID" := LoginID;
        IF SessionInfo.INSERT(TRUE) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
        Commit();
    END;




    procedure InsertWebTxnLog(Description: Text[150]; Direction: Option ,Inbound,Outbound; Status: Option ,Success,Failure; FaultCode: Code[10]; FaultDescription: Text[250]; SalesOrderNo: Code[30]; SessionID1: Text[100]; ItemNo: Code[20])
    var
        WebTxnLog: Record "Magento Web Transaction Log";
        OStream: OutStream;
        SessionInfo: Record "Magento Session Log";
    begin
        WebTxnLog.INIT;
        WebTxnLog."Entry No." := CREATEGUID;
        WebTxnLog.Description := Description;
        WebTxnLog.SessionID := SessionID1;

        WebTxnLog."Action Date" := TODAY;
        WebTxnLog."Action Time" := TIME;
        WebTxnLog.Direction := Direction;
        WebTxnLog.Status := Status;
        WebTxnLog."Fault Code" := FaultCode;
        WebTxnLog."Fault Description" := FaultDescription;
        WebTxnLog."Sales Order No." := SalesOrderNo;
        WebTxnLog."Item No." := ItemNo;

        WebTxnLog.INSERT(TRUE);
    end;

    local procedure GetText(e: XmlElement; Name: Text): Text
    var
        FieldNode: XmlNode;
    begin
        foreach FieldNode in e.GetChildElements(Name) do
            exit(FieldNode.AsXmlElement().InnerText);
    end;

    local procedure Getboolean(e: XmlElement; Name: Text): Boolean
    var
        FieldNode: XmlNode;
        value: Boolean;
    begin
        foreach FieldNode in e.GetChildElements(Name) do
            if evaluate(Value, FieldNode.AsXmlElement().InnerText, 9) then
                exit(value);
    end;


    local procedure GetInteger(e: XmlElement; Name: Text): Integer
    var
        FieldNode: XmlNode;
        value: Integer;
    begin
        foreach FieldNode in e.GetChildElements(Name) do
            if evaluate(Value, FieldNode.AsXmlElement().InnerText, 9) then
                exit(value);
    end;

    local procedure GetDateTime(e: XmlElement; Name: Text): DateTime
    var
        FieldNode: XmlNode;
        value: DateTime;
    begin
        foreach FieldNode in e.GetChildElements(Name) do
            if evaluate(Value, FieldNode.AsXmlElement().InnerText, 9) then
                exit(value);
    end;





    procedure ReadInstream(InputInStream: InStream; OutputStream: instream)
    var
        ProdID: text;
        TempB: Codeunit "Temp Blob";
        Outs: outstream;
        XmlDoc: XmlDocument;
        XmlNamaespaceManager: XmlNamespaceManager;
        XmlNList: XmlNodeList;
        Node: XmlNode;
        eNode: XmlElement;

    begin
        ProdID := RemoveNamespaces(InputInStream);


        TempB.CreateOutStream(Outs);
        Outs.WriteText(ProdID);


        TempB.CreateInStream(OutputStream);


        if OutputStream.EOS then
            Error('Cannot Read Blank Stream');

        if XmlDocument.ReadFrom(OutputStream, XmlDoc) then begin

            XmlNamaespaceManager.NameTable(XmlDoc.NameTable);
            XmlNamaespaceManager.AddNamespace('SOAP-ENV', 'http://schemas.xmlsoap.org/soap/envelope/');
            XmlNamaespaceManager.AddNamespace('ns1:loginResponse', 'http://schemas.xmlsoap.org/soap/envelope/');
            //  XmlNamaespaceManager.AddNamespace('ns1:catalogProductListResponse', '');
            // XmlNamaespaceManager.AddNamespace('nrg', 'http://www.dnbnordic.com/nrg');
            XmlNamaespaceManager.AddNamespace('ns1', 'http://schemas.xmlsoap.org/soap/envelope/');
            if XmlDoc.SelectNodes('/Envelope/Body/endSessionResponse', XmlNamaespaceManager, XmlNList) then
                foreach Node in XmlNList do begin
                    eNode := Node.AsXmlElement();
                end;

        end;

    end;

    procedure RemoveNamespaces(XMLText: InStream): Text
    begin
        exit(TransformXMLText(XMLText, GetRemoveNamespacesXSLTText));
    end;





    local procedure GetRemoveNamespacesXSLTText(): Text
    begin
        exit(
          '<?xml version="1.0" encoding="UTF-8"?>' +
          '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
          '<xsl:output method="xml" encoding="UTF-8" />' +
          '<xsl:template match="/">' +
          '<xsl:copy>' +
          '<xsl:apply-templates />' +
          '</xsl:copy>' +
          '</xsl:template>' +
          '<xsl:template match="*">' +
          '<xsl:element name="{local-name()}">' +
          '<xsl:apply-templates select="@* | node()" />' +
          '</xsl:element>' +
          '</xsl:template>' +
          '<xsl:template match="@*">' +
          '<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>' +
          '</xsl:template>' +
          '<xsl:template match="text() | processing-instruction() | comment()">' +
          '<xsl:copy />' +
          '</xsl:template>' +
          '</xsl:stylesheet>');
    end;

    procedure TransformXMLText(XmlInText: InStream; XslInText: Text): Text
    var
        TempBlobXmlIn: Codeunit "Temp Blob";
        TempBlobXsl: Codeunit "Temp Blob";
        TempBlobXmlOut: Codeunit "Temp Blob";
        XmlInStream: InStream;
        XslInStream: InStream;
        XmlOutStream: OutStream;
        XslOutStream: OutStream;
        Outstream2: OutStream;
        Instream2: InStream;
        TempBlob1: Codeunit "Temp Blob";
        XmlText: Text;
        DOMMgmt: Codeunit "XML DOM Management";
    begin
        //  TempBlobXmlIn.CreateOutStream(XmlOutStream, TEXTENCODING::UTF8);
        // XmlOutStream.WriteText(XmlInText);

        TempBlobXsl.CreateOutStream(XslOutStream, TEXTENCODING::UTF8);
        XslOutStream.WriteText(XslInText);

        //  TempBlobXmlIn.CreateInStream(XmlInStream);
        TempBlobXsl.CreateInStream(XslInStream);
        TempBlobXmlOut.CreateOutStream(XmlOutStream);
        if not DOMMgmt.TryTransformXMLToOutStream(XmlInText, XslInStream, XmlOutStream) then
            Error(XMLTransformErr);

        TempBlobXmlOut.CreateInStream(XmlInText);
        if not DOMMgmt.TryGetXMLAsText(XmlInText, XmlText) then
            Error(XmlCannotBeLoadedErr);

        exit(XmlText)
        // exit(Instream2);
    end;



    procedure UpdateCustomerTemplate(VAR Customer: Record Customer)
    var
        MagentoSetup: Record "Magento  Setup";
        CustomerRecRef: RecordRef;
        temTe: Record "Item Templ.";
    begin
        MagentoSetup.Get();
        MagentoSetup.TestField("Item Template");
        MagentoSetup.TestField("Customer Template");

        ConfigTemplateHeader.SETRANGE("Table ID", DATABASE::Customer);
        ConfigTemplateHeader.SETRANGE(Enabled, TRUE);
        ConfigTemplateHeader.SetRange(Code, MagentoSetup."Customer Template");
        IF ConfigTemplateHeader.FindFirst() then begin
            CustomerRecRef.GETTABLE(Customer);
            ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, CustomerRecRef);
            DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Customer."No.", DATABASE::Customer);
            CustomerRecRef.SETTABLE(Customer);
            Customer.FIND;
        END;
    END;




    procedure UpdateItemTemplate(VAR Item: Record Item)
    var
        MagentoSetup: Record "Magento  Setup";
        ItemRecRef: RecordRef;
    begin
        MagentoSetup.Get();
        MagentoSetup.TestField("Item Template");
        MagentoSetup.TestField("Customer Template");
        ConfigTemplateHeader.SETRANGE("Table ID", DATABASE::Item);
        ConfigTemplateHeader.SETRANGE(Enabled, TRUE);
        ConfigTemplateHeader.SetRange(Code, MagentoSetup."Item Template");
        IF ConfigTemplateHeader.FindFirst() then begin
            ItemRecRef.GETTABLE(Item);
            ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ItemRecRef);
            DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Item."No.", DATABASE::Item);
            ItemRecRef.SETTABLE(Item);
            Item.FIND;

        END;
    END;








    var
        XMLTransformErr: Label 'The XML cannot be transformed.';
        XmlCannotBeLoadedErr: Label 'The XML cannot be loaded.';
        SessionID: Text;
        SessionInfo: Record "Magento Session Log";
        ConfigTemplateHeader: Record "Config. Template Header";
        CustomerRecRef: RecordRef;
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        DimensionsTemplate: Record "Dimensions Template";
}