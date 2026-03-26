import frappe
from frappe import _
from werkzeug.wrappers import Response
import json
@frappe.whitelist()
def create_helpdesk_ticket(subject:str,user:str,email:str,priority:str ="Low", ticket_type: str ="Bug"):
    try:

        doc = frappe.new_doc("ChangAI Help Desk")
        doc.subject = subject
        doc.description = subject
        doc.customer = user
        doc.email = email
        doc.priority = priority
        doc.ticket_type = ticket_type
        doc.status = "Open"

        doc.insert(ignore_permissions=True)
        frappe.db.commit()


        return Response(
            json.dumps(
                {
                "kind": "TICKET_CREATED",
                "data": {
                    "ticket_id": doc.name,
                    "subject": doc.subject,
                    "email": doc.email,
                }
            }
            ),
            status=200,
            mimetype="application/json")


    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Create Helpdesk Ticket API")

        return Response(
            json.dumps(
                {
            "message": {
                "kind": "TICKET_CREATED",
                "data": {
                    "error": str(e)
                }
            }
            }
            ),
            status=500,
            mimetype="application/json")

@frappe.whitelist()
def get_user_tickets(ticket_id: int =None):
    try:

        filters = {}
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
                "customer",
            ],
            order_by="creation desc"
        )

        if ticket_id and not tickets:
            return Response(
            json.dumps(
                {
                    "kind": "TICKET_DETAILS",
                    "data": {
                        "error": "Ticket not found"
                    }
                }
            ),
            status=500,
            mimetype="application/json")


        formatted = []
        for t in tickets:
            formatted.append({
                "ticket_id": t.name,
                "subject": t.subject,
                "raised_by": t.customer,
                "status": t.status,
                "priority": t.priority,
                "description": t.description,
                "created_on": str(t.creation)
            })

        return Response(
            json.dumps(
                {
                "kind": "TICKET_DETAILS",
                "data": {
                    "tickets": formatted if not ticket_id else formatted[0]
                }
            }
            ),
            status=200,
            mimetype="application/json")



    except Exception as e:
        frappe.log_error(frappe.get_traceback(), "Get Ticket Details API")
        return Response(
            json.dumps(
                {
                "kind": "TICKET_DETAILS",
                "data": {
                    "status": 500,
                    "error": str(e)
                }
            }
            ),
            status=500,
            mimetype="application/json")

