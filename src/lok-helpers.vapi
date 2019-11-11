[CCode (cname="LibreOfficeKitDocumentType", cprefix = "LOK_DOCTYPE_", cheader_filename = "LibreOfficeKit/LibreOfficeKitEnums.h", has_type_id = false)]
public enum LibreOfficeKit.DocumentType {
    TEXT,
    SPREADSHEET,
    PRESENTATION,
    DRAWING,
    OTHER
}

[CCode (cname="lok_doc_view_get_command_values", cheader_filename = "lok-helpers.h")]
public string get_command_values (LOKDoc.View doc, string command);
[CCode (cname="lok_doc_view_get_document_type", cheader_filename = "lok-helpers.h")]
public LibreOfficeKit.DocumentType get_document_type (LOKDoc.View doc);
