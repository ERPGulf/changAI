frappe.ui.form.on("Item", {
    refresh(frm) {
        // Add menu option under "Menu"
        frm.add_custom_button(
            __("AI Translate"),
            () => {
                open_ai_translate_dialog(frm);
            },
            __("Menu")
        );
    }
});

function open_ai_translate_dialog(frm) {
    const dialog = new frappe.ui.Dialog({
        title: __("AI Translate"),
        size: "small",
        fields: [
            {
                label: __("From Field"),
                fieldname: "from_field",
                fieldtype: "Select",
                options: get_item_fields(),
                reqd: 1
            },
            {
                label: __("To Field"),
                fieldname: "to_field",
                fieldtype: "Select",
                options: get_item_fields(),
                reqd: 1
            }
        ],
        primary_action_label: __("Go"),
        primary_action(values) {
            dialog.hide();

            // Placeholder action
            frappe.msgprint(
                __(`Translate from <b>${values.from_field}</b> to <b>${values.to_field}</b>`)
            );

            // Later you can call backend AI method here
            // frappe.call({ ... })
        }
    });

    dialog.show();
}

function get_item_fields() {
    // Fields commonly translated in Item
    return [
        "",
        "item_name",
        "item_code",
        "description",
        "custom_arabic_name",
        "custom_arabic_description"
    ].join("\n");
}