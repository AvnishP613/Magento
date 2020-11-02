page 70002 "Magento Web Transaction"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Magento Web Transaction Log";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(SessionID; Rec.SessionID)
                {
                    ApplicationArea = All;
                }
                field("Fault Code"; Rec."Fault Code")
                {
                    ApplicationArea = All;
                }
                field("Fault Description"; Rec."Fault Description")
                {
                    ApplicationArea = All;
                }
                field("Action Date"; Rec."Action Date")
                {
                    ApplicationArea = All;
                }
                field("Action Time"; Rec."Action Time")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }


}