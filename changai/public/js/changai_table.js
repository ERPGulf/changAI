frappe.ui.form.on("ChangAI Settings", {
  create_validation_data(frm) {
    create_data_from_selected_rows(frm);
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
    method: "changai.validation_data.validation_data.generate_validation_data_for_modules",
    args: {
      modules: modules,
      total_count: frm.doc.train_records_count || 200
    },
    freeze: true,
    freeze_message: __("Generating validation data…"),
    callback(r) {
      if (r.message) {
        frappe.msgprint({
          title: __("Done"),
          message: r.message.message,
          indicator: "green"
        });
      }
    }
  });
}