table 70003 "Web Sales Order List"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Web Order ID"; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(2; "Store ID"; Text[1])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Store Name"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(4; Order_Status; Text[15])
        {
            DataClassification = ToBeClassified;

        }
        field(5; Order_State; Text[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Total Qty"; Decimal)
        {
            DataClassification = ToBeClassified;

        }

        field(7; "Grand Total"; Decimal)
        {
            DataClassification = ToBeClassified;

        }

        field(8; "First Name"; Text[100])
        {
            DataClassification = ToBeClassified;

        }


        field(9; "Last Name"; Text[100])
        {
            DataClassification = ToBeClassified;

        }

        field(10; "Order ID"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Quuote ID"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Currency Code"; Code[4])
        {
            DataClassification = ToBeClassified;

        }

        field(13; "Magento Created DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(14; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(15; "Created DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }

        field(16; "Shpping Method"; Code[10])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "Web Order ID")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        "Created DateTime" := CurrentDateTime;
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}