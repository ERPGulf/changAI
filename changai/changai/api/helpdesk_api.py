import frappe
import frappe
from frappe import _

@frappe.whitelist(allow_guest=True)
def create_helpdesk_ticket(subject, description, customer, email, priority="Low", ticket_type="Bug"):
    try:
        if not subject or not description or not customer:
            frappe.throw(_("Subject, Description and Customer are required"))

        doc = frappe.new_doc("ChangAI Help Desk")
        doc.subject = subject
        doc.description = description
        doc.customer = customer
        doc.email = email
        doc.priority = priority
        doc.ticket_type = ticket_type
        doc.status = "Open"

        doc.insert(ignore_permissions=True)
        frappe.db.commit()

        return doc
    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Create Helpdesk Ticket API")
        return {
            "status": "error",
            "message": str(e)
        }

import frappe

@frappe.whitelist()
def get_ticket_details(ticket_id=None):
    try:
        session_user = frappe.session.user

        filters = {"owner": session_user}
        if ticket_id:
            filters["ticket_id"] = ticket_id

        tickets = frappe.get_all(
            "ChangAI Help Desk",
            filters=filters,
            fields=[
                "ticket_id",
                "subject",
                "status",
                "priority",
                "description",
                "creation",
                "owner"
            ],
            order_by="creation desc"
        )

        if ticket_id and not tickets:
            return {
                "message": {
                    "kind": "TICKET_DETAILS",
                    "data": {
                        "status": 404,
                        "error": "Ticket not found"
                    }
                }
            }

        formatted = []
        for t in tickets:
            formatted.append({
                "ticket_id": t.ticket_id,
                "subject": t.subject,
                "raised_by": t.owner,
                "status": t.status,
                "priority": t.priority,
                "description": t.description,
                "created_on": t.creation
            })

        return {
            "message": {
                "kind": "TICKET_DETAILS",
                "data": {
                    "status": 200,
                    "tickets": formatted if not ticket_id else formatted[0]
                }
            }
        }

    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Get Ticket Details API")
        return {
            "message": {
                "kind": "TICKET_DETAILS",
                "data": {
                    "status": 500,
                    "error": str(e)
                }
            }
        }