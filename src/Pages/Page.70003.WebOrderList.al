page 70003 "Web Order List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Web Sales Order List";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Web Order ID"; Rec."Web Order ID")
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
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    MagentoReq: Codeunit "Magento Req Mgmt";
                begin

                end;
            }
        }
    }
}