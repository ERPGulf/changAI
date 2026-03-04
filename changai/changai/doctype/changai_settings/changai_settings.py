# Copyright (c) 2026, ERpGulf and contributors
# For license information, please see license.txt

# import frappe
from frappe.model.document import Document


class ChangAISettings(Document):
	pass

def validate(self):
    if self.choose_file_size:
        if self.choose_file_size < 1000 or self.choose_file_size > 1500:
            frappe.throw(_("Train Records must be between 1000 and 1500."))