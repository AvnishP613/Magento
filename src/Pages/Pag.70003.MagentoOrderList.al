page 70003 "Magento Order List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Magento Sales Order List";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Web Order ID"; Rec."Magento Order ID")
                {
                    ApplicationArea = All;
                }
                field("Store ID"; Rec."Store ID")
                {
                    ApplicationArea = All;
                }
                field("Store Name"; Rec."Store Name")
                {
                    ApplicationArea = All;
                    editable=false;
                }
                field(Order_State; Rec.Order_State)
                {
                    ApplicationArea = All;
                }
                field(Order_Status; Rec.Order_Status)
                {
                    ApplicationArea = All;
                }
                field("Grand Total"; Rec."Grand Total")
                {
                    ApplicationArea = All;
                }
                field("Total Qty"; Rec."Total Qty")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Shipment ID"; Rec."Shipment ID")
                {
                    ApplicationArea = All;
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
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
            action(GetOrderDetails)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CoupledOrder;


                trigger OnAction();
                var
                    MagentoReq: Codeunit "Magento Req Mgmt";
                begin
                    MagentoReq.GetSOrderOrderDetail(Format(rec."Magento Order ID"));
                end;
            }

            action(CreateShipment)
            {
                ApplicationArea = All;
                Promoted = true;
                Caption = 'Create Shipment';
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ShipAddress;


                trigger OnAction();
                var
                    MagentoReq: Codeunit "Magento Req Mgmt";
                begin
                    MagentoReq.CreateSOrderShipment('', Rec.Comment, Rec."Magento Order ID");
                end;
            }

            action(CreateInvoice)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Invoice;


                trigger OnAction();
                var
                    MagentoReq: Codeunit "Magento Req Mgmt";
                begin
                    MagentoReq.CreateSOrderiNVOICE('', Rec.Comment, Rec."Magento Order ID");
                end;
            }
        }
    }
}