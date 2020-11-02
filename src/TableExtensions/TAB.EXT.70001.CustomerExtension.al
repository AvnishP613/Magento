tableextension 70001 CustomerExt extends Customer
{
    fields
    {
        field(50000; Magento; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "First Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(50002; "Last Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        // Add changes to table fields here
    }


}