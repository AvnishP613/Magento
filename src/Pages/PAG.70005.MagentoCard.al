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
                    ApplicationArea = all;
                }
                field("Created at"; rec."Created at")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Name 2"; rec."Bill-to Name 2")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Address"; rec."Bill-to Address")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Address 2"; rec."Bill-to Address 2")
                {
                    ApplicationArea = all;
                }
                field("Bill-to City"; rec."Bill-to City")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Contact"; rec."Bill-to Contact")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Post Code"; rec."Bill-to Post Code")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Country/Region Code"; rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {
                    ApplicationArea = all;
                }
            }
            group(Shipping)
            {
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Name 2"; Rec."Ship-to Name 2")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = all;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = all;
                }
            }
            group("Status Info")
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
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

