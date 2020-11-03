page 70005 "Magento Sales Order"
{


    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;

    SourceTable = "Magento Sales Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Magento Sales Order ID"; rec."Magento Sales Order ID")
                {
                }
                field("Order Date"; Rec."Order Date")
                {
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                }
                field("Bill-to Name 2"; rec."Bill-to Name 2")
                {
                }
                field("Bill-to Address"; rec."Bill-to Address")
                {
                }
                field("Bill-to Address 2"; rec."Bill-to Address 2")
                {
                }
                field("Bill-to City"; rec."Bill-to City")
                {
                }
                field("Bill-to Contact"; rec."Bill-to Contact")
                {
                }
                field("Bill-to Post Code"; rec."Bill-to Post Code")
                {
                }
                field("Bill-to Country/Region Code"; rec."Bill-to Country/Region Code")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {
                }
            }
            group(Shipping)
            {
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                }
                field("Ship-to Name 2"; Rec."Ship-to Name 2")
                {
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                }
            }
            group("Status Info")
            {
                field(Status; Rec.Status)
                {
                }

            }
            part("Magento Sales Line"; "Magento Sales Line Subform")
            {
                ApplicationArea = all;
                SubPageLink = "Magento Sales Order ID" = field("Magento Sales Order ID");
            }
            part("Inbound Payment Line"; "Magento Payment Info")
            {
                SubPageLink = "Order ID" = field("Magento Sales Order ID");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(processing)
        {



        }
    }

    var

}

