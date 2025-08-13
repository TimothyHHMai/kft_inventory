from datetime import date
from ..models import Ingredient

def insert_ingredient(name, type_, quantity_box, current_ind_stock, current_box_stock, expiration_date):
    return Ingredient.objects.create(
        ingredient_name=name,
        type=type_,
        quantity_box=quantity_box,
        current_individual_stock=current_ind_stock,
        current_box_stock=current_box_stock,
        expiration_date=expiration_date
    )

def get_all_ingredients():
    return Ingredient.objects.all()

def update_ingredient(ingredient_id, name, type_, quantity_box, current_ind_stock, current_box_stock, expiration_date):
    return Ingredient.objects.filter(ingredientID=ingredient_id).update(
        ingredient_name=name,
        type=type_,
        quantity_box=quantity_box,
        current_individual_stock=current_ind_stock,
        current_box_stock=current_box_stock,
        expiration_date=expiration_date
    )


def delete_ingredient(ingredient_id):
    return Ingredient.objects.filter(ingredientID=ingredient_id).delete()

def add_from_ingredients(auto_box, ingredient_id, qty_add_individual, qty_add_box):
    try:
        ing = Ingredient.objects.get(ingredientID=ingredient_id)
    except Ingredient.DoesNotExist:
        return {"error": "Item not found or insufficient stock"}

    temp_box_stock = ing.current_box_stock + qty_add_box
    temp_individual_stock = ing.current_individual_stock + qty_add_individual
    quantity_per_box = ing.quantity_box

    msg = ""

    while temp_individual_stock <= 0:
        if temp_box_stock > 0:
            temp_individual_stock += quantity_per_box
            if auto_box == 1:
                temp_box_stock -= 1
        else:
            msg += " ** WARNING** current box stock is empty | "
            break

    msg += f"Successfully added {qty_add_box} boxes and {qty_add_individual} individuals from stock for ingredientID {ingredient_id}, {ing.ingredient_name}"
    msg += f" | remaining current_box_stock: {temp_box_stock} | remaining current_individual_stock: {temp_individual_stock}"

    ing.current_box_stock = temp_box_stock
    ing.current_individual_stock = temp_individual_stock
    ing.save()

    return {"message": msg}

def check_supplies_ingredients(stock_type, threshold):
    if stock_type == 'i':
        return Ingredient.objects.filter(current_individual_stock__lt=threshold).values('ingredient_name', 'current_individual_stock')
    elif stock_type == 'b':
        return Ingredient.objects.filter(current_box_stock__lt=threshold).values('ingredient_name', 'current_box_stock')
    return []

def check_expiration_ingredients(date_value):
    return Ingredient.objects.filter(expiration_date__lt=date_value).values('ingredient_name', 'expiration_date')
