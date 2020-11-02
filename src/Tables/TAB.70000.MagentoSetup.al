table 70000 "Magento  Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';
        }
        field(2; URL; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var

            begin
                url := DelChr(URL, '=', '');
            end;
        }

        field(3; APIKey; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var

            begin
                APIKey := DelChr(APIKey, '=', '');
            end;
        }


        field(4; Password; Text[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var

            begin
                Password := DelChr(Password, '=', '');
            end;
        }
        field(5; "List URL"; Text[100])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var

            begin
                "List URL" := DelChr("List URL", '=', '');
            end;
        }

        field(6; "Item Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Templ.";
        }

        field(7; "Customer Template"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Templ.";
        }


    }

    keys
    {
        key(PK; "Primary Key")
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