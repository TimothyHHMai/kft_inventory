# services/miscellaneous.py

from .models import Miscellaneous

# 1. Insert Miscellaneous
def insert_miscellaneous(name, qty_box, indiv_stock, box_stock):
    return Miscellaneous.objects.create(
        miscellaneous_name=name,
        quantity_box=qty_box,
        current_individual_stock=indiv_stock,
        current_box_stock=box_stock
    )

# 2. Get All Miscellaneous
def get_all_miscellaneous():
    return Miscellaneous.objects.all()

# 3. Update Miscellaneous
def update_miscellaneous(misc_id, name, qty_box, indiv_stock, box_stock):
    return Miscellaneous.objects.filter(pk=misc_id).update(
        miscellaneous_name=name,
        quantity_box=qty_box,
        current_individual_stock=indiv_stock,
        current_box_stock=box_stock
    )

# 4. Delete Miscellaneous
def delete_miscellaneous(misc_id):
    return Miscellaneous.objects.filter(pk=misc_id).delete()

# 5. Add/Subtract Miscellaneous (auto box logic)
def add_from_miscellaneous(auto_box, misc_id, qty_add_indiv, qty_add_box):
    try:
        misc = Miscellaneous.objects.get(pk=misc_id)
    except Miscellaneous.DoesNotExist:
        return {"error": "Item not found or insufficient stock"}

    # Add stock
    misc.current_box_stock += qty_add_box
    misc.current_individual_stock += qty_add_indiv

    # Auto box conversion
    while misc.current_individual_stock <= 0:
        if misc.current_box_stock > 0:
            misc.current_individual_stock += misc.quantity_box
            if auto_box == 1:
                misc.current_box_stock -= 1
        else:
            misc.save()
            return {"warning": f"Current box stock is empty | remaining box={misc.current_box_stock}, individual={misc.current_individual_stock}"}

    misc.save()
    return {
        "message": f"Successfully added {qty_add_box} boxes and {qty_add_indiv} individuals for {misc.miscellaneous_name} | "
                   f"Remaining: box={misc.current_box_stock}, indiv={misc.current_individual_stock}"
    }

# 6. Check supplies under threshold
def check_supplies_miscellaneous(stock_type, threshold):
    if stock_type == 'i':
        return Miscellaneous.objects.filter(current_individual_stock__lt=threshold).values('miscellaneous_name', 'current_individual_stock')
    elif stock_type == 'b':
        return Miscellaneous.objects.filter(current_box_stock__lt=threshold).values('miscellaneous_name', 'current_box_stock')
    return []

# 7. Optional: Get a single Miscellaneous by ID
def get_miscellaneous_by_id(misc_id):
    try:
        return Miscellaneous.objects.get(pk=misc_id)
    except Miscellaneous.DoesNotExist:
        return None
