

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
                field(Store; rec.Store)
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

                action(WebSalesOrderID)
                {
                    Caption = 'Magento Order List';
                    ApplicationArea = All;
                    PromotedOnly = true;
                    Promoted = true;
                    Image = GetOrder;
                    PromotedCategory = Process;
                    RunObject = page "Magento Order List";

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
                    MagentoWebManagement: Codeunit "Magento Req Mgmt";

                begin
                    Rec.TestField(Store);
                    MagentoWebManagement.GetItem('', Rec.Store);

                end;
            }

            action("Get Sales Order List")
            {
                ApplicationArea = All;
                ToolTip = 'Get Sales Orders';
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Category4;

                Image = OrderList;
                trigger OnAction();
                var
                    MagentoWebManagement: Codeunit "Magento Req Mgmt";

                begin
                    MagentoWebManagement.GetSOrder('');

                end;
            }

            action(DeleteRec)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                Image = OrderList;
                trigger OnAction();
                var
                    Customer: Record Customer;
                    Item: Record Item;
                    WebOrder: Record "Magento Sales Order List";

                begin
                    WebOrder.DeleteAll();
                    Item.SetRange(Magento, true);
                    Item.DeleteAll();
                    Customer.SetRange(Magento, true);
                    Customer.DeleteAll();

                end;
            }




        }
    }

    var

}


