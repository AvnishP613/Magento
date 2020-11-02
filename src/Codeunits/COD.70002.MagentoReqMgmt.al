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
        MSetup.TestField("Customer Template");
        IF SendLoginRequest THEN BEGIN
            GetSalesOrders(Filters);
            EndLoginRequest();
        END;
        COMMIT;
    end;



    procedure GetSOrderOrderDetail(Filters: Text)
    var
        MSetup: Record "Magento  Setup";
    begin
        MSetup.Get();
        MSetup.TestField("Customer Template");
        MSetup.TestField("Item Template");
        IF SendLoginRequest THEN BEGIN
            GetSingleOrder(Filters);
            EndLoginRequest();
        END;
        COMMIT;
    end;

    procedure CreateSOrderShipment(Filters: Text; CText: text; SOrderID: CODE[20])
    var
        MSetup: Record "Magento  Setup";
    begin
        Clear(GlobalSOrderID);
        GlobalSOrderID := SOrderID;

        MSetup.Get();
        IF SendLoginRequest THEN BEGIN
            CreaterOrderShipment(Filters, CText, SOrderID);
            EndLoginRequest();
        END;
        COMMIT;
    end;


    procedure CreateSOrderiNVOICE(Filters: Text; CText: text; SOrderID: CODE[20])
    var
        MSetup: Record "Magento  Setup";
    begin
        Clear(GlobalSOrderID);
        GlobalSOrderID := SOrderID;
        MSetup.Get();
        IF SendLoginRequest THEN BEGIN
            CreaterOrderInvoice(Filters, CText, SOrderID);
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
        Clear(ReqText);
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
            InsertWebTxnLog('Error : Login', 2, 2, '', '', '', SessionInfo."Session ID", '', '', '');

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
            InsertWebTxnLog('Item:Receive Web Error', 2, 2, '', '', '', SessionInfo."Session ID", '', '', '');

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
                ReadOrderList(Instream1);
                exit(true);
            end
            else
                exit(false)

        end
        else begin
            exit(false);
            InsertWebTxnLog('SalesOrdersList:Receive Web Error', 2, 2, '', '', '', SessionInfo."Session ID", '', '', '');

        end;
    end;


    local procedure CreaterOrderShipment(filters: Text; CommentText: text; SOrdID: Code[20]): Boolean
    var
        WebReq: Codeunit "Magento Request Creation";
        SuccessNodeText: Label 'ns1:loginResponse';
        ReqText: Text;
        Instream1: InStream;
        OInstream: InStream;
    begin
        ReqText := WebReq.SorderShipmentCreate(SessionInfo."Session ID", CommentText, SOrdID);
        IF CallWebServices(ReqText, Instream1) THEN BEGIN
            if not ReadError(Instream1) then begin
                ReadCreatedShipment(Instream1);
                exit(true);
            end
            else
                exit(false)

        end
        else begin
            exit(false);
            InsertWebTxnLog('CreateShipment:Receive Web Error', 2, 2, '', '', GlobalSOrderID, SessionInfo."Session ID", '', '', '');

        end;
    end;

    local procedure CreaterOrderInvoice(filters: Text; CommentText: text; SOrdID: Code[20]): Boolean
    var
        WebReq: Codeunit "Magento Request Creation";
        SuccessNodeText: Label 'ns1:loginResponse';
        ReqText: Text;
        Instream1: InStream;
        OInstream: InStream;
    begin
        ReqText := WebReq.SorderInvoiceCreate(SessionInfo."Session ID", CommentText, SOrdID);
        IF CallWebServices(ReqText, Instream1) THEN BEGIN
            if not ReadError(Instream1) then begin
                ReadCreatedInvoice(Instream1);
                exit(true);
            end
            else
                exit(false)

        end
        else begin
            exit(false);
            InsertWebTxnLog('Create Invoice:Receive Web Error', 2, 2, '', '', GlobalSOrderID, SessionInfo."Session ID", '', '', '');

        end;
    end;


    local procedure GetSingleOrder(SOrderNo: Text): Boolean
    var
        WebReq: Codeunit "Magento Request Creation";
        SuccessNodeText: Label 'ns1:loginResponse';
        ReqText: Text;
        Instream1: InStream;
        OInstream: InStream;
    begin
        ReqText := WebReq.SingleOrder(SessionInfo."Session ID", SOrderNo);
        IF CallWebServices(ReqText, Instream1) THEN BEGIN
            if not ReadError(Instream1) then begin
                ReadSingleOrderList(Instream1);//  ReadOrderList(Instream1);
                exit(true);
            end
            else
                exit(false)

        end
        else begin
            exit(false);
            InsertWebTxnLog('SalesOrder Single:Receive Web Error', 2, 2, '', '', SOrderNo, SessionInfo."Session ID", '', '', '');

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
                    InsertWebTxnLog('Fault Code', 0, 2, GetText(eNode, 'faultcode'), GetText(eNode, 'faultstring'), '', SessionInfo."Session ID", '', '', '');
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
                    InsertWebTxnLog('Session Created', 2, 1, '', '', '', SessionInfo."Session ID", '', '', '');
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

                                InsertWebTxnLog('Item Created', 2, 1, '', '', '', SessionInfo."Session ID", GetText(eNode, 'product_id'), '', '');
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
        FirstName: Text;
        CustomerID: Text;

        WebSOrderRec: Record "MAGENTO Sales Order List";
        WebOrderID: Code[20];
        CustomerRecord: Record Customer;
        ShippingMethodText: Text;
        ShippingMethodRec: Record "Shipment Method";
        NoSereriesMgmt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Sales & Receivables Setup";
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
            if XmlDoc.SelectNodes('/Envelope/Body/salesOrderListResponse/result/item', XmlNamaespaceManager, XmlNList) then begin
                foreach Node in XmlNList do begin
                    eNode := Node.AsXmlElement();
                    Clear(WebOrderID);
                    Clear(FirstName);
                    WebOrderID := GetText(eNode, 'increment_id');
                    FirstName := GetText(eNode, 'customer_firstname');
                    if WebOrderID <> '' then begin
                        WebSOrderRec.Reset();
                        WebSOrderRec.SetRange("Magento Order ID", WebOrderID);
                        if not WebSOrderRec.FindFirst() then begin
                            WebSOrderRec.Reset();
                            WebSOrderRec.Init();
                            WebSOrderRec."Magento Order ID" := WebOrderID;
                            WebSOrderRec."Last Name" := GetText(eNode, 'customer_lastname');
                            WebSOrderRec."First Name" := FirstName;
                            WebSOrderRec.Order_State := GetText(eNode, 'state');
                            WebSOrderRec.Order_Status := GetText(eNode, 'status');
                            WebSOrderRec."Order ID" := GetText(eNode, 'order_id');
                            WebSOrderRec."Quote ID" := GetText(eNode, 'quote_id');
                            WebSOrderRec."Store ID" := GetText(eNode, 'store_id');
                            WebSOrderRec."Store Name" := GetText(eNode, 'store_name');
                            WebSOrderRec."Currency Code" := GetText(eNode, 'base_currency_code');
                            //      order_id
                            WebSOrderRec."Total Qty" := GetDecimal(eNode, 'total_qty_ordered');
                            WebSOrderRec."Grand Total" := GetDecimal(eNode, 'grand_total');
                            WebSOrderRec."Magento Created DateTime" := GetDateTime(eNode, 'created_at');

                            ShippingMethodText := GetText(eNode, 'shipping_method');
                            if ShippingMethodText <> '' then
                                WebSOrderRec."Shpping Method" := CopyStr(ShippingMethodText, 1, 10);
                            WebSOrderRec.Insert(true);

                            if ShippingMethodText <> '' then begin
                                ShippingMethodText := CopyStr(ShippingMethodText, 1, 10);
                                ShippingMethodRec.Reset();
                                ShippingMethodRec.SetRange(Code, ShippingMethodText);
                                if not ShippingMethodRec.FindFirst() then begin

                                    ShippingMethodRec.Reset();
                                    ShippingMethodRec.Init();
                                    ShippingMethodRec.Code := ShippingMethodText;
                                    ShippingMethodRec.Description := GetText(eNode, 'shipping_description');
                                    ShippingMethodRec.Insert(true);
                                end;
                            end;
                            if FirstName <> '' then begin
                                CustomerRecord.Reset();
                                CustomerRecord.SetRange("First Name", FirstName);
                                if not CustomerRecord.FindFirst() then begin
                                    CustomerRecord.Reset();
                                    CustomerRecord.Init();
                                    SalesSetup.Get();
                                    SalesSetup.TestField("Customer Nos.");
                                    // NoSeriesMgt.InitSeries(SalesSetup."Customer Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                                    CustomerRecord."No." := NoSereriesMgmt.GetNextNo3(SalesSetup."Customer Nos.", WorkDate(), true, false);
                                    CustomerRecord."First Name" := FirstName;
                                    CustomerRecord."Last Name" := GetText(eNode, 'customer_lastname');
                                    CustomerRecord.Name := FirstName + ' ' + CustomerRecord."Last Name";
                                    CustomerRecord.Magento := true;
                                    CustomerRecord.Insert();
                                    // UpdateCustomerFromTemplate(CustomerRecord);
                                    ApplyTemplateCustomer(CustomerRecord, MgSetup."Customer Template");
                                end;
                            end;

                            InsertWebTxnLog('Magento Order Created', 2, 1, '', '', GetText(eNode, 'increment_id'), SessionInfo."Session ID", '', '', '');
                            TotalCount += 1;
                            Commit();
                        end;
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



    local procedure ReadCreatedShipment(Inst2: InStream): Boolean
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
        FirstName: Text;
        CustomerID: Text;

        WebSOrderRec: Record "Magento Sales Order List";
        WebOrderID: Code[20];

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
            if XmlDoc.SelectNodes('/Envelope/Body/salesOrderShipmentCreateResponse', XmlNamaespaceManager, XmlNList) then begin
                foreach Node in XmlNList do begin
                    eNode := Node.AsXmlElement();

                    InsertWebTxnLog('Create Order Shipment Created', 2, 1, '', '', GlobalSOrderID, SessionInfo."Session ID", '', GetText(eNode, 'shipmentIncrementId'), '');
                    WebOrderID := '';
                    WebOrderID := GetText(eNode, 'shipmentIncrementId');
                    WebSOrderRec.Reset();
                    WebSOrderRec.SetRange("Magento Order ID", WebOrderID);
                    if WebSOrderRec.FindFirst() then begin
                        WebSOrderRec."Shipment ID" := WebOrderID;
                        WebSOrderRec.Modify();
                    end;
                    TotalCount += 1;
                    Commit();
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

    local procedure ReadCreatedInvoice(Inst2: InStream): Boolean
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

        WebSOrderRec: Record "Magento Sales Order List";
        WebOrderID: Code[20];

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
            if XmlDoc.SelectNodes('/Envelope/Body/salesOrderInvoiceCreateResponse', XmlNamaespaceManager, XmlNList) then begin
                foreach Node in XmlNList do begin
                    eNode := Node.AsXmlElement();

                    InsertWebTxnLog('Create Order Invoice Created', 2, 1, '', '', GlobalSOrderID, SessionInfo."Session ID", '', '', GetText(eNode, 'result'));
                    WebOrderID := '';
                    WebOrderID := GetText(eNode, 'result');
                    WebSOrderRec.Reset();
                    WebSOrderRec.SetRange("Magento Order ID", WebOrderID);
                    if WebSOrderRec.FindFirst() then begin
                        WebSOrderRec."Invoice ID" := WebOrderID;
                        WebSOrderRec.Modify();
                    end;
                    TotalCount += 1;
                    Commit();
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


    local procedure ReadSingleOrderList(Inst2: InStream): Boolean
    var

        XmlNamaespaceManager: XmlNamespaceManager;
        XmlDoc: XmlDocument;
        XmlNList: XmlNodeList;
        Node: XmlNode;
        XmlNList2: XmlNodeList;
        Node2: XmlNode;
        XmlNList1: XmlNodeList;
        XmlNList4: XmlNodeList;
        XmlNList5: XmlNodeList;
        Node1: XmlNode;
        XmlNList3: XmlNodeList;
        Node3: XmlNode;
        Node4: XmlNode;
        Node5: XmlNode;
        eNode: XmlElement;
        eNode1: XmlElement;
        eNode2: XmlElement;
        eNode3: XmlElement;
        eNode4: XmlElement;
        eNode5: XmlElement;
        XmlBuff: Record "XML Buffer";
        ProdID: Text;
        Outs: OutStream;
        TempB: Codeunit "Temp Blob";
        Instream2: InStream;
        NewInstream: InStream;
        TotalCount: Integer;
        //  ItemRec: Record item;
        FirstName: Text;
        CustomerID: Text;

        WebSOrderRec: Record "Magento Sales Order List";
        WebOrderID: Code[20];
        CustomerRecord: Record Customer;
        ShippingMethodText: Text;
        ShippingMethodRec: Record "Shipment Method";
        NoSereriesMgmt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Sales & Receivables Setup";
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
            if XmlDoc.SelectNodes('/Envelope/Body/salesOrderInfoResponse/result', XmlNamaespaceManager, XmlNList) then begin
                foreach Node in XmlNList do begin
                    eNode := Node.AsXmlElement();
                    if eNode.SelectNodes('billing_address', XmlNamaespaceManager, XmlNList1) then begin
                        foreach Node2 in XmlNList1 do begin
                            eNode2 := Node2.AsXmlElement();
                        end;
                    end;
                    if eNode.SelectNodes('items/item', XmlNamaespaceManager, XmlNList2) then begin
                        foreach Node3 in XmlNList2 do begin
                            eNode3 := Node3.AsXmlElement();
                        end;
                    end;
                    if eNode.SelectNodes('payment', XmlNamaespaceManager, XmlNList3) then begin
                        foreach Node4 in XmlNList3 do begin
                            eNode4 := Node4.AsXmlElement();
                        end;
                    end;

                    if eNode.SelectNodes('status_history', XmlNamaespaceManager, XmlNList4) then begin
                        foreach Node5 in XmlNList4 do begin
                            eNode5 := Node5.AsXmlElement();
                        end;
                    end;

                    InsertWebTxnLog('Web Order Single Received', 2, 1, '', '', GetText(eNode, 'increment_id'), SessionInfo."Session ID", '', '', '');
                    TotalCount += 1;
                    Commit();
                end;

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
                    InsertWebTxnLog('Session Ended', 2, 1, '', '', '', SessionInfo."Session ID", '', '', '');
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


    procedure UpdateCustomerFromTemplate(VAR Customer: Record Customer)
    var

    begin
        MgSetup.Get();
        ConfigTemplateHeader.SETRANGE("Table ID", DATABASE::Customer);
        ConfigTemplateHeader.SETRANGE(Enabled, TRUE);
        ConfigTemplateHeader.SetRange(Code, MgSetup."Customer Template");
        IF ConfigTemplateHeader.FindFirst() then begin
            //ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
            //  ConfigTemplates.LOOKUPMODE(TRUE);
            //  IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
            //    ConfigTemplates.GETRECORD(ConfigTemplateHeader);
            CustomerRecRef.GETTABLE(Customer);
            ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, CustomerRecRef);
            DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader, Customer."No.", DATABASE::Customer);
            CustomerRecRef.SETTABLE(Customer);
            Customer.FIND;
        END;
        //END;
    END;

    procedure InsertWebTxnLog(Description: Text[150]; Direction: Option ,Inbound,Outbound; Status: Option ,Success,Failure; FaultCode: Code[10]; FaultDescription: Text[250]; SalesOrderNo: Code[30]; SessionID1: Text[100]; ItemNo: Code[20]; ShipID: Code[20]; InvID: Code[20])
    var
        WebTxnLog: Record "Magento Web Transaction Log";
        OStream: OutStream;
        SessionInfo: Record "Magento Session Log";
    begin
        WebTxnLog.INIT;
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
        WebTxnLog."Shipment ID" := ShipID;
        WebTxnLog."Invoice ID" := InvID;

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



    local procedure GetDecimal(e: XmlElement; Name: Text): Decimal
    var
        FieldNode: XmlNode;
        value: Decimal;
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
        MgSetup: Record "Magento  Setup";
        CustomerRecRef: RecordRef;
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        DimensionsTemplate: Record "Dimensions Template";
        GlobalSOrderID: Code[20];
}