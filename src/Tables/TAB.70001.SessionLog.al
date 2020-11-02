table 70001 "Magento Session Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; "Session ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Session Data Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "End Session"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "End Session DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }

    var


    trigger OnInsert()
    begin
        "Session Data Time" := CurrentDateTime;
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