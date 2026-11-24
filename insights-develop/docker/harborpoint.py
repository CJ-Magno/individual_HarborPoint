import frappe

def get_context(context):
    context.is_guest = frappe.session.user == "Guest"
    context.no_cache = 1
