$(document).on("form-refresh", function (e, frm) {
    add_translate_button(frm);
});
$(document).on("form-load", function (e, frm) {
    add_translate_button(frm);
});
function add_translate_button(frm) {
    if (frm.page.menu.find('a:contains("AI Translate")').length) return;
    frm.page.add_menu_item(__("AI Translate"), () => {
        open_ai_translate_dialog(frm);
    });
}

async function open_ai_translate_dialog(frm) {
    const fields = get_all_fields(frm);

    if (!fields.length) {
        frappe.msgprint(__("No fields found."));
        return;
    }

    const settings = await frappe.db.get_doc("ChangAI Settings");
    const to_language = settings.to_language || __("Unknown Language");

    const dialog = new frappe.ui.Dialog({
        title: __("AI Translate"),
        fields: [
            {
                fieldname: "from_field",
                label: __("From Field"),
                fieldtype: "Select",
                options: fields,
                reqd: 1
            },
            {
                fieldname: "to_field",
                label: __("To Field"),
                fieldtype: "Select",
                options: fields,
                reqd: 1,
                description: __("Translated text will be saved here")
            }
        ],
        primary_action_label: __("Translate"),
        primary_action(values) {
            const from_field = values.from_field;
            const to_field = values.to_field;
            const source_text = frm.doc[from_field];

            if (!source_text) {
                frappe.msgprint(__("Source field is empty."));
                return;
            }

            dialog.hide();

            frappe.call({
                method: "changai.changai.api.v2.ai_translate.translate_and_store",
                args: {
                    docname: frm.doc.name,
                    doctype: frm.doc.doctype,
                    from_field: from_field,
                    to_field: to_field,
                    text: source_text,
                    to_language: to_language
                },
                freeze: true,
                freeze_message: __("Translating and saving..."),
                callback(r) {
                    if (r.message) {
                        frappe.show_alert({
                            message: __("Translation saved in field: ") + r.message,
                            indicator: "green"
                        });
                        frm.reload_doc();
                    }
                }
            });
        }
    });

    dialog.show();
}
function get_all_fields(frm) {
    return frm.meta.fields
        .filter(df =>
            df.fieldname &&
            [
                "Data",
                "Text",
                "Long Text",
                "Small Text"
            ].includes(df.fieldtype)
        )
        .map(df => ({
            label: df.label,
            value: df.fieldname
        }));
}