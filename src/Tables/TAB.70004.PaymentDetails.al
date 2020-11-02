table 70004 "Magento Payment Info"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Order ID"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Parent ID"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Payment ID"; Code[20])

        {
            DataClassification = ToBeClassified;

        }

        field(4; cc_exp_month; Code[2])

        {
            DataClassification = ToBeClassified;

        }

        field(5; cc_exp_year; Code[4])

        {
            DataClassification = ToBeClassified;

        }

        field(6; cc_ss_start_month; Code[2])

        {
            DataClassification = ToBeClassified;

        }

        field(7; cc_ss_start_year; Code[4])

        {
            DataClassification = ToBeClassified;

        }

        field(8; "Base Amount Ordered"; Decimal)

        {
            DataClassification = ToBeClassified;

        }

        field(9; "Shipping Amount"; Decimal)

        {
            DataClassification = ToBeClassified;

        }
        field(10; Method; Text[30])

        {
            DataClassification = ToBeClassified;

        }
        field(11; "Base Shipping Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "Order ID")
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