pageextension 70000 CustomerCard extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("First Name"; Rec."First Name")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Last Name"; rec."Last Name")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field(Magento; rec.Magento)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }


}