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