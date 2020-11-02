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


    procedure GetSOrder(Filters: Text)
    var
        MSetup: Record "Magento  Setup";
    begin
        MSetup.Get();
        MSetup.TestField("Item Template");
        IF SendLoginRequest THEN BEGIN
            GetSalesOrders(Filters);
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

    local procedure GetItemDetails(filters: Text; storeview: Text[1]): Boolean
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



    local procedure GetSalesOrders(filters: Text): Boolean
    var
        WebReq: Codeunit "Magento Request Creation";
        SuccessNodeText: Label 'ns1:loginResponse';
        ReqText: Text;
        Instream1: InStream;
        OInstream: InStream;
    begin
        ReqText := WebReq.SOrderList(SessionInfo."Session ID", filters);
        IF CallWebServices(ReqText, Instream1) THEN BEGIN
            if not ReadError(Instream1) then begin
                // ReadItemList(Instream1);
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
        ItemRec: Record item;
        itemID: Text;
        MgSetup: Record "Magento  Setup";
    begin
        MgSetup.Get();
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
                    Clear(itemID);
                    itemID := GetText(eNode, 'product_id');

                    if itemID <> '' then begin
                        ItemRec.Reset();
                        ItemRec.SetRange("No.", itemID);
                        if not ItemRec.FindFirst() then begin
                            ItemRec.Reset();
                            ItemRec.Init();
                            ItemRec."No." := GetText(eNode, 'product_id');
                            ItemRec.Description := GetText(eNode, 'name');
                            ItemRec."Magento Type" := GetText(eNode, 'type');


                            if eNode.SelectNodes('website_ids', XmlNamaespaceManager, XmlNList1) then begin
                                foreach Node1 in XmlNList1 do begin
                                    eNode1 := Node1.AsXmlElement();
                                    ItemRec."Magento Type" := GetText(eNode, 'item');
                                end;


                                if eNode.SelectNodes('category_ids', XmlNamaespaceManager, XmlNList2) then begin
                                    foreach Node2 in XmlNList2 do begin
                                        eNode2 := Node2.AsXmlElement();
                                        ItemRec."Magento Type" := GetText(eNode, 'item');
                                    end;
                                end;
                                ItemRec.Magento := true;
                                ItemRec.Insert(true);
                                ApplyTemplateItem(ItemRec, MgSetup."Item Template");

                                InsertWebTxnLog('Item Created', 2, 1, '', '', '', SessionInfo."Session ID", GetText(eNode, 'product_id'));
                                TotalCount += 1;
                            end;
                        end
                    end;
                end;

                if TotalCount > 0 then
                    exit(true)
                else
                    exit(false);
            end;
        end
        else
            exit(false)
    end;



    local procedure ReadOrderList(Inst2: InStream): Boolean
    var

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
        //  ItemRec: Record item;
        Customer: Text;
        MgSetup: Record "Magento  Setup";
    begin
        MgSetup.Get();
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
            if XmlDoc.SelectNodes('/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:salesOrderListResponse/result/item', XmlNamaespaceManager, XmlNList) then begin
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
                    end
                end;

                if TotalCount > 0 then
                    exit(true)
                else
                    exit(false);
            end;
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

    local procedure ApplyTemplateCustomer(var Customer: Record Customer; TemplCode: Code[20])
    var
        CustomerTempl: Record "Customer Templ.";
    begin
        CustomerTempl.Get(TemplCode);
        Customer.City := CustomerTempl.City;
        Customer."Customer Posting Group" := CustomerTempl."Customer Posting Group";
        Customer."Currency Code" := CustomerTempl."Currency Code";
        Customer."Language Code" := CustomerTempl."Language Code";
        Customer."Payment Terms Code" := CustomerTempl."Payment Terms Code";
        Customer."Fin. Charge Terms Code" := CustomerTempl."Fin. Charge Terms Code";
        Customer."Invoice Disc. Code" := CustomerTempl."Invoice Disc. Code";
        Customer."Country/Region Code" := CustomerTempl."Country/Region Code";
        Customer."Bill-to Customer No." := CustomerTempl."Bill-to Customer No.";
        Customer."Payment Method Code" := CustomerTempl."Payment Method Code";
        Customer."Application Method" := CustomerTempl."Application Method".AsInteger();
        Customer."Prices Including VAT" := CustomerTempl."Prices Including VAT";
        Customer."Gen. Bus. Posting Group" := CustomerTempl."Gen. Bus. Posting Group";
        Customer."Post Code" := CustomerTempl."Post Code";
        Customer.County := CustomerTempl.County;
        Customer."VAT Bus. Posting Group" := CustomerTempl."VAT Bus. Posting Group";
        Customer."Block Payment Tolerance" := CustomerTempl."Block Payment Tolerance";
        Customer."Validate EU Vat Reg. No." := CustomerTempl."Validate EU Vat Reg. No.";
        Customer.Blocked := CustomerTempl.Blocked;
        Customer.Modify(true);
    end;


    local procedure ApplyTemplateItem(var Item: Record Item; TemplCode: Code[20])
    var
        ItemTempl: Record "Item Templ.";
    begin
        ItemTempl.Get(TemplCode);
        Item.Type := ItemTempl.Type;
        Item."Inventory Posting Group" := ItemTempl."Inventory Posting Group";
        Item."Item Disc. Group" := ItemTempl."Item Disc. Group";
        Item."Allow Invoice Disc." := ItemTempl."Allow Invoice Disc.";
        Item."Price/Profit Calculation" := ItemTempl."Price/Profit Calculation";
        Item."Profit %" := ItemTempl."Profit %";
        Item."Costing Method" := ItemTempl."Costing Method";
        Item."Indirect Cost %" := ItemTempl."Indirect Cost %";
        Item."Price Includes VAT" := ItemTempl."Price Includes VAT";
        Item."Gen. Prod. Posting Group" := ItemTempl."Gen. Prod. Posting Group";
        Item."Automatic Ext. Texts" := ItemTempl."Automatic Ext. Texts";
        Item."Tax Group Code" := ItemTempl."Tax Group Code";
        Item."VAT Prod. Posting Group" := ItemTempl."VAT Prod. Posting Group";
        Item."Item Category Code" := ItemTempl."Item Category Code";
        Item."Service Item Group" := ItemTempl."Service Item Group";
        Item."Warehouse Class Code" := ItemTempl."Warehouse Class Code";
        Item.Blocked := ItemTempl.Blocked;
        Item."Sales Blocked" := ItemTempl."Sales Blocked";
        Item."Purchasing Blocked" := ItemTempl."Purchasing Blocked";
        Item.Validate("Base Unit of Measure", ItemTempl."Base Unit of Measure");
        Item.Modify(true);
        InsertDimensions(Item."No.", ItemTempl.Code);
    end;



    local procedure InsertDimensions(ItemNo: Code[20]; ItemTemplCode: Code[20])
    var
        SourceDefaultDimension: Record "Default Dimension";
        DestDefaultDimension: Record "Default Dimension";
    begin
        SourceDefaultDimension.SetRange("Table ID", Database::"Item Templ.");
        SourceDefaultDimension.SetRange("No.", ItemTemplCode);
        if SourceDefaultDimension.FindSet() then
            repeat
                DestDefaultDimension.Init();
                DestDefaultDimension.Validate("Table ID", Database::Item);
                DestDefaultDimension.Validate("No.", ItemNo);
                DestDefaultDimension.Validate("Dimension Code", SourceDefaultDimension."Dimension Code");
                DestDefaultDimension.Validate("Dimension Value Code", SourceDefaultDimension."Dimension Value Code");
                DestDefaultDimension.Validate("Value Posting", SourceDefaultDimension."Value Posting");
                DestDefaultDimension.Insert(true);
            until SourceDefaultDimension.Next() = 0;
    end;








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