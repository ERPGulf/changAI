// Copyright (c) 2026, ERpGulf and contributors
// For license information, please see license.txt
frappe.ui.form.on("ChangAI Settings", {
    refresh(frm) {

        frm.add_custom_button(__('Download Embedding Model'), () => {
            frappe.call({
                method: "changai.changai.api.v2.text2sql_pipeline_v2.download_model_from_ui",
                freeze: true,
                freeze_message: __("Re-downloading embedding model..."),
                callback(r) {
                    if (!r.message) return;

                    if (r.message.status === "success") {
                        frappe.msgprint({
                            title: __("Success"),
                            message: __("Embedding model downloaded successfully."),
                            indicator: "green"
                        });
                    } else {
                        frappe.msgprint({
                            title: __("Error"),
                            message: __(r.message.message || "Unknown error occurred."),
                            indicator: "red"
                        });
                    }
                }
            });
        });

    },

    create_train_data(frm) {
        create_data_from_selected_rows(frm);
    },

    update_masterdata_file(frm) {
        frappe.call({
            method: "changai.changai.api.v2.auto_gen_api.sync_master_data_smart",
            freeze: true,
            freeze_message: "Updating Master Data...",
            callback(r) {
                console.log(r.message);
            }
        });
    },

    update_schema_file(frm) {
        frappe.call({
            method: "changai.changai.api.v2.auto_gen_api.sync_schema_and_enqueue_descriptions",
            freeze: true,
            freeze_message: "Syncing schema...",
            callback(r) {
                console.log(r.message);
            }
        });
    }
});


function create_data_from_selected_rows(frm) {
    const table_field = "module_and_description";
    const grid = frm.fields_dict[table_field].grid;

    const selected_rows = grid.get_selected_children();

    if (!selected_rows.length) {
        frappe.msgprint({
            title: __("No modules selected"),
            message: __("Please select at least one row."),
            indicator: "orange"
        });
        return;
    }

    const modules = selected_rows.map(row => ({
        module: row.module,
        description: row.description || ""
    }));

    frappe.call({
        method: "changai.changai.api.v2.train_data_api.start_train",
        args: {
            modules: modules,
            module_name: frm.doc.choose_module,
            total_count: frm.doc.choose_file_size
        },
        freeze: true,
        freeze_message: "Creating Data...",
        callback(r) {
            console.log("Response:", r.message);
        }
    });
}