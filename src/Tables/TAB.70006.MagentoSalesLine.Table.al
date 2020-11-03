table 70006 "Magento Sales Line"
{

    fields
    {

        field(1; "Magento Sales Order ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = item;
            DataClassification = ToBeClassified;


        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
            begin
            end;
        }
        field(7; "Invoiced Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
            begin
            end;
        }
        field(8; "Shipped Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
            begin
            end;
        }

        field(9; "Cancelled Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
            begin
            end;
        }

        field(10; "Refunded Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
            begin
            end;
        }

        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }

        field(14; Price; Decimal)
        {
            DataClassification = ToBeClassified;
        }


        field(15; "Tax %"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
        field(16; "Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Amount Refunded"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Row Invoiced"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Quote Item ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(20; "Item ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

         field(21; "Row Total"; Decimal)
        {
            DataClassification = ToBeClassified;
        }




    }

    keys
    {
        key(Key1; "Magento Sales Order ID", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

