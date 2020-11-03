table 70005 "Magento Sales Header"
{

    fields
    {
        field(1; "Magento Sales Order ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Store; Text[1])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Created at"; DateTime)
        {
            DataClassification = ToBeClassified;
        }

        field(4; "Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Shipping Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(7; "Sub Total"; Decimal)
        {
            DataClassification = ToBeClassified;
        }


        field(8; "Grand Total"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(9; "Total Qty Ordered"; Decimal)
        {
            DataClassification = ToBeClassified;
        }


        field(10; "Shipping Address ID"; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Store Name"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "First Name"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Last Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

        field(15; "Quote ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(16; "Order ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(17; "Bill-to Name"; Text[50])
        {
            Caption = 'Bill-to Name';
            DataClassification = ToBeClassified;
        }
        field(18; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
            DataClassification = ToBeClassified;
        }
        field(19; "Bill-to Address"; Text[50])
        {
            Caption = 'Bill-to Address';
            DataClassification = ToBeClassified;
        }
        field(20; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
            DataClassification = ToBeClassified;
        }
        field(21; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
            DataClassification = ToBeClassified;
        }
        field(22; "Bill-to Contact"; Text[50])
        {
            Caption = 'Bill-to Contact';
            DataClassification = ToBeClassified;
        }
        field(23; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name';
            DataClassification = ToBeClassified;
        }
        field(24; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
            DataClassification = ToBeClassified;
        }
        field(25; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address';
            DataClassification = ToBeClassified;
        }
        field(26; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
            DataClassification = ToBeClassified;
        }
        field(27; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            DataClassification = ToBeClassified;
        }
        field(28; "Ship-to Contact"; Text[50])
        {
            Caption = 'Ship-to Contact';
            DataClassification = ToBeClassified;
        }
        field(29; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }

        field(30; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            DataClassification = ToBeClassified;
        }
        field(31; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            DataClassification = ToBeClassified;
        }
        field(32; "Ship-to Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ship-to Post Code';
        }
        field(33; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            DataClassification = ToBeClassified;
        }
        field(34; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            DataClassification = ToBeClassified;
        }
        field(35; State; Code[10])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }

        field(36; Status; Code[10])
        {
            DataClassification = ToBeClassified;
        }

        field(37; "Shipping Mehtod"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(38; "Order State"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Magento Sales Order ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


}

