import frappe

def get_context(context):
    if frappe.session.user == "Guest":
        frappe.throw(
            frappe._("You must be logged in to access HarborPoint."),
            frappe.PermissionError
        )
    context.no_cache = 1
