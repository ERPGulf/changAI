// Copyright (c) 2026, ERpGulf and contributors
// For license information, please see license.txt

frappe.ui.form.on("ChangAI Settings", {
    refresh(frm) {
    },
    choose_file_size(frm) {
        const v = frm.doc.choose_file_size;

        if (v == null) return;

        if (v < 1000 || v > 1500) {
            frappe.msgprint({
                title: "Invalid Train Size",
                message: "Please enter a value between 1000 and 1500 for Train Records Size.",
                indicator: "blue"
            });
            frm.set_value("choose_file_size", null);
        }
    }
});
