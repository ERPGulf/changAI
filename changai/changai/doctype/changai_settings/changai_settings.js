// Copyright (c) 2026, ERPGulf and contributors
// For license information, please see license.txt
class Tooltip {
    constructor(options) {
        this.maxLength = options.maxLength || 200;
        this.containerClass = options.containerClass || "tooltip-container";
        this.tooltipClass = options.tooltipClass || "custom-tooltip";
        this.iconClass = options.iconClass || "info-icon";
        this.hoverEffect = options.hoverEffect || true;
        this.text = options.text || "";
        this.links = options.links || [];
    }
    renderTooltip(targetElement) {
        const tooltipContainer = document.createElement("div");
        tooltipContainer.className = this.containerClass;

        // ✅ Make container inline so it sits beside the button
        tooltipContainer.style.display = "inline-flex";
        tooltipContainer.style.alignItems = "center";
        tooltipContainer.style.verticalAlign = "middle";

        const infoIcon = document.createElement("div");
        infoIcon.className = this.iconClass;
        infoIcon.style.display = "inline-flex";
        infoIcon.style.alignItems = "center";
        infoIcon.style.cursor = "pointer";
        infoIcon.style.marginLeft = "6px";
        infoIcon.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-info-circle" viewBox="0 0 16 16">
            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
            <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/>
        </svg>
    `;

        const tooltipElement = document.createElement("div");
        tooltipElement.className = this.tooltipClass;
        tooltipElement.innerHTML = this.text;

        this.links.forEach((link) => {
            const anchor = document.createElement("a");
            anchor.href = link;
            anchor.target = "_blank";
            anchor.textContent = link;
            tooltipElement.appendChild(document.createElement("br"));
            tooltipElement.appendChild(anchor);
        });

        tooltipContainer.appendChild(infoIcon);
        tooltipContainer.appendChild(tooltipElement);

        // ✅ Check if target is a button — insert differently
        const isButton = targetElement.tagName === "BUTTON";
        if (isButton) {
            // Insert tooltip container right after the button
            targetElement.parentElement.style.display = "inline-flex";
            targetElement.parentElement.style.alignItems = "center";
            targetElement.insertAdjacentElement("afterend", tooltipContainer);
        } else {
            // Normal label fields — original behavior
            targetElement.parentElement.insertBefore(tooltipContainer, targetElement.nextSibling);
        }

        // Tooltip initial state
        tooltipElement.style.visibility = "hidden";
        tooltipElement.style.opacity = "0";
        let isTooltipVisible = false;

        infoIcon.addEventListener("click", (event) => {
            event.preventDefault();
            event.stopPropagation();
            isTooltipVisible = !isTooltipVisible;
            if (isTooltipVisible) {
                tooltipElement.style.visibility = "visible";
                tooltipElement.style.opacity = "1";
            } else {
                tooltipElement.style.visibility = "hidden";
                tooltipElement.style.opacity = "0";
            }
        });

        document.addEventListener("click", (event) => {
            if (!tooltipContainer.contains(event.target)) {
                tooltipElement.style.visibility = "hidden";
                tooltipElement.style.opacity = "0";
                isTooltipVisible = false;
            }
        });
    }
}
console.log("Tooltip.js loaded");
window.Tooltip = Tooltip;
frappe.ui.form.on("ChangAI Settings", {
    refresh(frm) {
        function applyTooltips(context, fieldsWithTooltips) {
            fieldsWithTooltips.forEach((field) => {
                let fieldContainer;
                if (context.fields_dict?.[field.fieldname]) {
                    fieldContainer = context.fields_dict[field.fieldname];
                }
                else if (context.dialog?.fields_dict?.[field.fieldname]) {
                    fieldContainer = context.dialog.fields_dict[field.fieldname];
                }
                else if (context.page) {
                    fieldContainer = $(context.page).find(`[data-fieldname="${field.fieldname}"]`).closest('.frappe-control');
                }
                if (!fieldContainer) {
                    console.error(`Field '${field.fieldname}' not found in the provided context.`);
                    return;
                }
                const fieldWrapper = fieldContainer.$wrapper || $(fieldContainer);
                if (!fieldWrapper || fieldWrapper.length === 0) {
                    console.error(`Field wrapper for '${field.fieldname}' not found.`);
                    return;
                }

                let labelElement;

                // 1. Try label
                if (fieldWrapper.find('label').length > 0) {
                    labelElement = fieldWrapper.find('label').first();
                }
                // 2. Try control-label
                else if (fieldWrapper.find('.control-label').length > 0) {
                    labelElement = fieldWrapper.find('.control-label').first();
                }
                // 3. ✅ Try button (for button-type fields) — FIXED POSITION
                else if (fieldWrapper.find('button').length > 0) {
                    labelElement = fieldWrapper.find('button').first();
                }
                // 4. Fallback for dialog/page
                else if (context.dialog || context.page) {
                    labelElement = fieldWrapper.find('.form-control').first();
                }

                if (!labelElement || labelElement.length === 0) {
                    console.error(`Label for field '${field.fieldname}' not found.`);
                    return;
                }

                const tooltipContainer = labelElement.next('.tooltip-container');
                if (tooltipContainer.length === 0) {
                    const tooltip = new Tooltip({
                        containerClass: "tooltip-container",
                        tooltipClass: "custom-tooltip",
                        iconClass: "info-icon",
                        text: field.text,
                        links: field.links || [],
                    });
                    tooltip.renderTooltip(labelElement[0]);
                }
            });
        }
        const fieldsWithTooltips = [
            {
                fieldname: "remote",
                text: `
                    Enable this to use a remote server for AI processing instead of the local server.
                `,
            },
            {
                fieldname: "from_language",
                text: `
                   Set the default source language for AI translation.This will be automatically used as the translation input language whenever you use the AI Translate option on any doctype — no need to set it again each time.
                `,
            },
            {
                fieldname: "to_language",
                text: `
                    Set the default target language for AI translation. Whenever AI Translate is triggered on any doctype, the field value will be translated into this language and saved to your selected target field automatically.
                `,
            },
            {
                fieldname: "gemini_api_key",
                text: `
                    Enter your Gemini API key from Google AI Studio. This is required to use Gemini as your AI provider (Free Tier).Get your key at: https://aistudio.google.com/app/apikey
                `,
            },
            {
                fieldname: "retain_memory",
                text: `
                    When enabled, the AI will remember the context of previous messages within the same conversation session.
                `,
            },
            {
                fieldname: "gemini_location",
                text: `
                    Enter the Google Cloud region where your Gemini Paid Tier service is hosted. Example: us-central1.
                `,
            },
            {
                fieldname: "gemini_project_id",
                text: `
                    Enter your Google Cloud Project ID linked to the Gemini Paid Tier service account.
                `,
            },
            {
                fieldname: "gemini_json_content",
                text: `
                    Paste your Google Cloud Service Account credentials JSON here. This is required to authenticate with Gemini Paid Tier.
                `,
            },
            {
                fieldname: "llm",
                text: `
                    Select the Large Language Model (LLM) to use for generating SQL queries and AI responses.
                `,
            },
            {
                fieldname: "result_formatting",
                text: `
                    Select how AI query results are presented in the chat."Model" formats the response in a friendly, readable way using AI. "Local" uses code-based formatting and may show technical output..
                `,
            },
            {
                fieldname: "update_masterdata_file",
                text: `
                    Sync and update the master data file that the AI uses to understand your business data. Run this whenever your key business records change.
                `,
            },
            {
                fieldname: "choose_file_size",
                text: `
                    Set the number of records to use for training the AI model.Choose a value between 1000 and 1500.
                `,
            },
            {
                fieldname: "update_schema_file",
                text: `
                    Sync the latest database schema so the AI knows your current doctype structure and fields. Run this after adding or modifying any doctypes.
                `,
            },
        ];
        applyTooltips(frm, fieldsWithTooltips);
        frm.add_custom_button(__('Download Embedding Model'), () => {
            frappe.call({
                method: "changai.changai.api.v2.text2sql_pipeline_v2.download_model",
                freeze: true,
                freeze_message: "Downloading Model...",
                callback(r) {
                    if (!r.message) return;
                    frappe.show_alert({
                        message: __("Model download started in the background. This may take a few minutes."),
                        indicator: "blue"
                    }, 8);
                },
                error(r) {
                    frappe.msgprint({
                        title: __("Error"),
                        message: __("Failed to start model download. Please try again."),
                        indicator: "red"
                    });
                }
            });
        });
    },
    update_masterdata_file(frm) {
        frappe.call({
            method: "changai.changai.api.v2.auto_gen_api.update_masterdata",
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
    },

    create_train_data(frm) {
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