page 70004 "Magento Payment Info"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Magento Payment Info";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Order ID"; Rec."Order ID")
                {
                    ApplicationArea = All;
                }
                field("Parent ID"; Rec."Parent ID")
                {
                    ApplicationArea = All;
                }
                field("Payment ID"; Rec."Payment ID")
                {
                    ApplicationArea = All;
                }
                field(cc_exp_month; Rec.cc_exp_month)
                {
                    ApplicationArea = All;
                }
                field(cc_exp_year; Rec.cc_exp_year)
                {
                    ApplicationArea = All;
                }
                field(cc_ss_start_month; Rec.cc_ss_start_month)
                {
                    ApplicationArea = All;
                }
                field(cc_ss_start_year; Rec.cc_ss_start_year)
                {
                    ApplicationArea = All;
                }
            }
        }

    }


}