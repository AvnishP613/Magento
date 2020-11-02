codeunit 70001 "Magento Web Request"
{
    var
        XMLDomMgt: Codeunit "XML DOM Mgmt";
        //https://diveshboramsdnavblog.wordpress.com/2018/03/09/vs-code-xml-dom-management-part-2/
        SoapNS11: Label 'http://schemas.xmlsoap.org/soap/envelope/', Locked = true;

    //Use this function to Create a Soap Message
    procedure Login(): Text
    var
        lXmlDocument: XmlDocument;
        lEnvolopeXmlNode: XmlNode;
        lHeaderXmlNode: XmlNode;
        lBodyXmlNode: XmlNode;
        lTempXmlNode: XmlNode;
        lXMLText: Text;
        MagSetup: Record "Magento  Setup";
        ApiNameSpace: Label 'urn:Magento';
    begin
        MagSetup.Get();
        MagSetup.TestField(URL);
        MagSetup.TestField(APIKey);
        MagSetup.TestField(Password);
        CreateSoapDocument(lXmlDocument, 1, lEnvolopeXmlNode, lHeaderXmlNode, lBodyXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'login', '', ApiNameSpace, lBodyXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'username', MagSetup.APIKey, ApiNameSpace, lTempXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'apiKey', MagSetup.Password, ApiNameSpace, lTempXmlNode);
        lXmlDocument.WriteTo(lXMLText);
        exit(lXMLText);
    end;


    procedure EndSession(SessionID: Text): Text;
    var
        lXmlDocument: XmlDocument;
        lEnvolopeXmlNode: XmlNode;
        lHeaderXmlNode: XmlNode;
        lBodyXmlNode: XmlNode;
        lTempXmlNode: XmlNode;
        lXMLText: Text;
        ApiNameSpace: Label 'urn:Magento';
    begin
        CreateSoapDocument(lXmlDocument, 1, lEnvolopeXmlNode, lHeaderXmlNode, lBodyXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'endSession', '', ApiNameSpace, lBodyXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'sessionId', SessionID, ApiNameSpace, lTempXmlNode);
        lXmlDocument.WriteTo(lXMLText);
        exit(lXMLText);

    end;

    procedure ProductList(Filters: Text; SessionID: Text; StoreView: Text[1]): Text
    var
        lXmlDocument: XmlDocument;
        lEnvolopeXmlNode: XmlNode;
        lHeaderXmlNode: XmlNode;
        lBodyXmlNode: XmlNode;
        lTempXmlNode: XmlNode;
        lXMLText: Text;
        ApiNameSpace: Label 'urn:Magento';
    begin
        CreateSoapDocument(lXmlDocument, 1, lEnvolopeXmlNode, lHeaderXmlNode, lBodyXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'catalogProductList', '', ApiNameSpace, lBodyXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'sessionId', SessionID, ApiNameSpace, lTempXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'filters', Filters, ApiNameSpace, lTempXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'storeView', StoreView, ApiNameSpace, lTempXmlNode);
        lXmlDocument.WriteTo(lXMLText);
        exit(lXMLText);
    end;



    procedure SOrderList(SessionID: Text; filters: Text): Text
    var
        lXmlDocument: XmlDocument;
        lEnvolopeXmlNode: XmlNode;
        lHeaderXmlNode: XmlNode;
        lBodyXmlNode: XmlNode;
        lTempXmlNode: XmlNode;
        lXMLText: Text;
        ApiNameSpace: Label 'urn:Magento';
    begin
        CreateSoapDocument(lXmlDocument, 1, lEnvolopeXmlNode, lHeaderXmlNode, lBodyXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'salesOrderList', '', ApiNameSpace, lBodyXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'sessionId', SessionID, ApiNameSpace, lTempXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'filters', filters, ApiNameSpace, lTempXmlNode);
        lXmlDocument.WriteTo(lXMLText);
        exit(lXMLText);
    end;

    procedure SingleOrder(sessionID: Text; OrderID: Text): Text
    var
        lXmlDocument: XmlDocument;
        lEnvolopeXmlNode: XmlNode;
        lHeaderXmlNode: XmlNode;
        lBodyXmlNode: XmlNode;
        lTempXmlNode: XmlNode;
        lXMLText: Text;
        ApiNameSpace: Label 'urn:Magento';
    begin
        CreateSoapDocument(lXmlDocument, 1, lEnvolopeXmlNode, lHeaderXmlNode, lBodyXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'salesOrderInfo', '', ApiNameSpace, lBodyXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'sessionId',sessionID, ApiNameSpace, lTempXmlNode);
        XMLDomMgt.AddElement(lBodyXmlNode, 'orderIncrementId', OrderID, ApiNameSpace, lTempXmlNode);
        lXmlDocument.WriteTo(lXMLText);
        exit(lXMLText);
    end;


    //Use this function to Create a Soap Document with Soap Version 1.1 & 1.2. This function will return the XML Document along with the reference of the created nodes like Envelope, Header & Body.
    procedure CreateSoapDocument(var pXmlDocument: XmlDocument; pVersion: Option "1.1","1.2"; var pEnvelopeXmlNode: XmlNode; var pHeaderXmlNode: XmlNode; var pBodyXmlNode: XmlNode);
    begin
        CreateEnvelope(pXmlDocument, pEnvelopeXmlNode, pVersion);
        CreateBody(pEnvelopeXmlNode, pBodyXmlNode, pVersion);
    end;

    //This function will create a Soap Envelope
    procedure CreateEnvelope(var pXmlDocument: XmlDocument; var pEnvelopeXmlNode: XmlNode; pVersion: Option "1.1","1.2");
    begin
        pXmlDocument := XmlDocument.Create;
        XMLDomMgt.AddDeclaration(pXmlDocument, '1.0', 'UTF-8', 'no');//Soap
        XMLDomMgt.AddRootElementWithPrefix(pXmlDocument, 'Envelope', 'SOAP', SoapNS11, pEnvelopeXmlNode)
    end;

    //This function will create a Soap Header
    procedure CreateHeader(var pEnvelopeXmlNode: XmlNode; var pHeaderXmlNode: XmlNode; pVersion: Option "1.1","1.2");
    begin
        XMLDOMMgt.AddElement(pEnvelopeXmlNode, 'Header', '', SoapNS11, pHeaderXmlNode)
    end;

    //This function will create a Soap Body
    procedure CreateBody(var pSoapEnvelope: XmlNode; var pSoapBody: XmlNode; pVersion: Option "1.1","1.2");
    var
        ApiNameSpace: Label 'urn:Magento';
    begin
        XMLDOMMgt.AddElement(pSoapEnvelope, 'Body', '', SoapNS11, pSoapBody)
    end;



}
