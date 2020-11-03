page 70006 "Magento Sales Line Subform"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = "Magento Sales Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Magento Sales Order ID";rec."Magento Sales Order ID")
                {
                    ApplicationArea = All;
                 }
                field("Line No."; Rec."Line No.")
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                }

            }
        }
    }

    actions
    {
    }
}

