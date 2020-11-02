tableextension 70000 ItemExt extends Item
{
    fields
    {
        field(50000; Magento; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Magento Type"; Text[15])
        {
            DataClassification = CustomerContent;
        }

        field(50002; Set; Text[5])
        {
            DataClassification = CustomerContent;
        }
        field(50004; Sku; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(50005; "Category ID"; Code[10])
        {
            DataClassification = CustomerContent;
        }

        field(50006; "Website ID"; Code[10])
        {
            DataClassification = CustomerContent;
        }

        // Add changes to table fields here
    }

}