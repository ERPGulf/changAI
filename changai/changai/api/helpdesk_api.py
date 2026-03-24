import frappe
import frappe
from frappe import _

@frappe.whitelist(allow_guest = False)
def create_helpdesk_ticket(subject,priority="Low", ticket_type="Bug"):
    try:
        session_user = frappe.session.user

        if session_user == "Guest":
            frappe.throw(_("You must be logged in to create a ticket"))


        user_doc = frappe.get_doc("User", session_user)
        user_email = user_doc.email

        doc = frappe.new_doc("ChangAI Help Desk")
        doc.subject = subject
        doc.description = subject
        doc.customer = session_user
        doc.email = user_email
        doc.priority = priority
        doc.ticket_type = ticket_type
        doc.status = "Open"

        doc.insert(ignore_permissions=True)
        frappe.db.commit()

        return {
                "kind": "TICKET_CREATED",
                "data": {
                    "status": 200,
                    "ticket_id": doc.name,
                    "subject": doc.subject,
                    "email": user_email
                }
            }


    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Create Helpdesk Ticket API")
        return {
            "message": {
                "kind": "TICKET_CREATED",
                "data": {
                    "status": 500,
                    "error": str(e)
                }
            }
        }

@frappe.whitelist(allow_guest = False)
def get_user_tickets(ticket_id=None):
    try:
        session_user = frappe.session.user

        filters = {"owner": session_user}
        if ticket_id:
            filters["name"] = ticket_id

        tickets = frappe.get_all(
            "ChangAI Help Desk",
            filters=filters,
            fields=[
                "name",
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
                    "kind": "TICKET_DETAILS",
                    "data": {
                        "status": 404,
                        "error": "Ticket not found"
                    }
                }


        formatted = []
        for t in tickets:
            formatted.append({
                "ticket_id": t.name,
                "subject": t.subject,
                "raised_by": t.owner,
                "status": t.status,
                "priority": t.priority,
                "description": t.description,
                "created_on": t.creation
            })

        return {
                "kind": "TICKET_DETAILS",
                "data": {
                    "status": 200,
                    "tickets": formatted if not ticket_id else formatted[0]
                }
            }


    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Get Ticket Details API")
        return {
                "kind": "TICKET_DETAILS",
                "data": {
                    "status": 500,
                    "error": str(e)
                }
            }
