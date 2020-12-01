codeunit 70003 ConvertToBase64
{
    procedure Convert64String()
    var
        SinvHeader: Record "Sales Invoice Header";
        RecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        typehelper: Codeunit "Type Helper";
        Base64Convert: Codeunit "Base64 Convert";


        Instream1: InStream;
        Outstream1: OutStream;

    begin
        SinvHeader.SetRange("No.", 'PS-INV103217');
        SinvHeader.FindFirst();
        RecRef.GetTable(SinvHeader);
        TempBlob.CreateOutStream(Outstream1);
        Report.SaveAs(Report::"Standard Sales - Invoice", '', ReportFormat::Pdf, Outstream1, RecRef);
        Tempblob.CreateInStream(Instream1);
        Base64Value := Base64Convert.ToBase64(Instream1);
        Message(Base64Value);

    end;

    var
        Base64Value: Text;

}
