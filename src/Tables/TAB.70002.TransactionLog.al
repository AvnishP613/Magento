table 70002 "Magento Web Transaction Log"
{


    fields
    {
        field(1; "Entry No."; Guid)
        {
            Editable = false;
        }
        field(2; Description; Text[100])
        {
            Editable = false;
        }
        field(3; SessionID; Text[100])
        {
            Editable = false;
        }
        field(4; "Request XML"; BLOB)
        {
        }
        field(5; "Response XML"; BLOB)
        {
        }
        field(6; "Action Date"; Date)
        {
        }
        field(7; "Action Time"; Time)
        {
        }
        field(8; Direction; Option)
        {
            OptionCaption = ',Inbound,Outbound';
            OptionMembers = ,Inbound,Outbound;
        }
        field(9; Status; Option)
        {
            OptionCaption = ',Success,Failure';
            OptionMembers = ,Success,Failure;
        }
        field(10; "Fault Code"; Code[10])
        {
        }
        field(11; "Fault Description"; Text[250])
        {
        }
        field(12; "Sales Order No."; Code[30])
        {
        }
        field(13; "Item No."; Code[20])
        {
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin


    end;
}

