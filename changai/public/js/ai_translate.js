frappe.ui.form.on("Item", {
    refresh(frm) {
        // Prevent duplicate menu items
        if (frm.ai_translate_added) return;
        frm.ai_translate_added = true;

        frm.page.add_menu_item(__("AI Translate"), () => {
            open_ai_translate_dialog(frm);
        });
    }
});

function open_ai_translate_dialog(frm) {
    const fields = get_item_text_fields(frm);

    if (!fields.length) {
        frappe.msgprint(__("No translatable fields found."));
        return;
    }

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
                reqd: 1
            }
        ],
        primary_action_label: __("Go"),
        primary_action(values) {
            dialog.hide();

            frappe.msgprint({
                title: __("AI Translate"),
                message: __(
                    `From <b>${values.from_field}</b> → To <b>${values.to_field}</b>`
                ),
                indicator: "green"
            });

            // AI call will go here later
        }
    });

    dialog.show();
}

function get_item_text_fields(frm) {
    return frm.meta.fields
        .filter(df =>
            ["Data", "Small Text", "Text", "Long Text"].includes(df.fieldtype)
        )
        .map(df => ({
            label: df.label,
            value: df.fieldname
        }));
}