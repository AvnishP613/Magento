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
    actions

    {
        addafter("Account Detail")
        {
            action(Base64Value)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Add;
                trigger OnAction()
                var
                    B64: Codeunit ConvertToBase64;
                begin
                    B64.Convert64String();
                end;
            }
        }

    }


}
