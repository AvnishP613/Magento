

page 70000 "Magento Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Magento  Setup";

    layout
    {
        area(Content)
        {
            group(Magento)
            {

                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = URL;
                }
                field(APIKey; Rec.APIKey)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field("Customer Template"; Rec."Customer Template")
                {
                    ApplicationArea = All;
                }
                field("Item Template"; Rec."Item Template")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Records)
            {
                action(Session)
                {
                    ApplicationArea = All;
                    PromotedOnly = true;
                    Promoted = true;
                    Image = Item;
                    PromotedCategory = Process;
                    RunObject = page "Magento Session Info";

                }
                action(TransactionLog)
                {
                    ApplicationArea = All;
                    PromotedOnly = true;
                    Promoted = true;
                    Image = OpenWorksheet;
                    PromotedCategory = Process;
                    RunObject = page "Magento Web Transaction";

                }
            }
            action(GetItems)
            {
                ApplicationArea = All;
                Caption = 'Get Items';
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Category5;

                Image = Item;
                trigger OnAction();
                var

                begin


                end;
            }

            action(OrderList)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Category5;

                Image = LogSetup;
                trigger OnAction()
                var
                    MagentoReq: Codeunit "Magento Web Request";
                    TextValue: Text;
                begin
                    TextValue := MagentoReq.SOrderList('dsrrrrrr', '2123');
                    Message(TextValue);

                end;
            }

            action(signleorder)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Category5;

                Image = LogSetup;
                trigger OnAction()
                var
                    MagentoReq: Codeunit "Magento Web Request";
                    TextValue: Text;
                begin
                    TextValue := MagentoReq.SingleOrder('dsrrrrrr', '2123');
                    Message(TextValue);

                end;
            }

            action(EndSession)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Category5;

                Image = LogSetup;
                trigger OnAction()
                var
                    MagentoReq: Codeunit "Magento Web Request";
                    TextValue: Text;
                begin
                    TextValue := MagentoReq.ProductList('', '112dddd', '1');
                    Message(TextValue);

                end;
            }
        }
    }

    var

}


