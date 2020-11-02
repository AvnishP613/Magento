pageextension 70001 ItemCard extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("Magento Type"; Rec."Magento Type")
            {
                ApplicationArea = All;
            }
            field(Magento; rec.Magento)
            {
                ApplicationArea = All;
            }
            field("Website ID"; Rec."Website ID")
            {
                ApplicationArea = All;
            }
        }
        // Add changes to page layout here
    }


}