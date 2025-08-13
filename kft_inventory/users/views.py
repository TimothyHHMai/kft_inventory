from django.shortcuts import render
from .models import Ingredient, Miscellaneous
from django.http import JsonResponse
import json
from django.views.decorators.csrf import csrf_exempt
from .scripts.ingredients import (
    insert_ingredient,
    get_all_ingredients,
    update_ingredient,
    delete_ingredient,
    add_from_ingredients,
    check_supplies_ingredients,
    check_expiration_ingredients
)
from .scripts.miscellaneous import (
    insert_miscellaneous,
    get_all_miscellaneous,
    update_miscellaneous,
    delete_miscellaneous,
    add_from_miscellaneous,
    check_supplies_miscellaneous,
    get_miscellaneous_by_id
)

def home(request):
    return render(request, 'users/home.html')

@csrf_exempt
def ingredients_api(request, id=None):
    if request.method == 'GET':
        sortBy = request.GET.get('sortBy')
        sortOrder = request.GET.get('sortOrder', 'asc').lower()

        allowed_sort_columns = {'expiration_date', 'ingredient_name', 'current_individual_stock', 'current_box_stock'}
        allowed_sort_orders = {'asc', 'desc'}

        if id:
            try:
                ing = get_all_ingredients().get(ingredientID=id)
                return JsonResponse({
                    'ingredientID': ing.ingredientID,
                    'ingredient_name': ing.ingredient_name,
                    'type': ing.type,
                    'quantity_box': ing.quantity_box,
                    'current_individual_stock': ing.current_individual_stock,
                    'current_box_stock': ing.current_box_stock,
                    'expiration_date': ing.expiration_date
                })
            except Ingredient.DoesNotExist:
                return JsonResponse({'error': 'Not found'}, status=404)
        else:
            queryset = get_all_ingredients()
            if sortBy in allowed_sort_columns and sortOrder in allowed_sort_orders:
                if sortOrder == 'desc':
                    sortBy = '-' + sortBy
                queryset = queryset.order_by(sortBy)
            data = list(queryset.values())
            return JsonResponse({'ingredients': data})

    elif request.method == 'POST':
        data = json.loads(request.body)
        ing = insert_ingredient(
            name=data['ingredient_name'],
            type_=data['type'],
            quantity_box=data['quantity_box'],
            current_ind_stock=data['current_individual_stock'],
            current_box_stock=data['current_box_stock'],
            expiration_date=data['expiration_date']
        )
        return JsonResponse({'message': f'Ingredient {ing.ingredient_name} added'})

    elif request.method == 'PUT' and id:
        data = json.loads(request.body)
        updated = update_ingredient(
            ingredient_id=id,
            name=data['ingredient_name'],
            type_=data['type'],
            quantity_box=data['quantity_box'],
            current_ind_stock=data['current_individual_stock'],
            current_box_stock=data['current_box_stock'],
            expiration_date=data['expiration_date']
        )
        if updated:
            return JsonResponse({'message': 'Ingredient updated'})
        else:
            return JsonResponse({'error': 'Not found'}, status=404)

    elif request.method == 'DELETE' and id:
        deleted, _ = delete_ingredient(id)
        if deleted:
            return JsonResponse({'message': 'Ingredient deleted'})
        else:
            return JsonResponse({'error': 'Not found'}, status=404)

    return JsonResponse({'error': 'Method not allowed'}, status=405)



@csrf_exempt
def miscellaneous_api(request, id=None):
    if request.method == 'GET':
        sortBy = request.GET.get('sortBy')
        sortOrder = request.GET.get('sortOrder', 'asc').lower()

        allowed_sort_columns = {'miscellaneous_name', 'current_individual_stock', 'current_box_stock'}
        allowed_sort_orders = {'asc', 'desc'}

        if id:
            misc = get_miscellaneous_by_id(id)
            if misc:
                return JsonResponse({
                    'miscellaneousID': misc.miscellaneousID,
                    'miscellaneous_name': misc.miscellaneous_name,
                    'quantity_box': misc.quantity_box,
                    'current_individual_stock': misc.current_individual_stock,
                    'current_box_stock': misc.current_box_stock
                })
            else:
                return JsonResponse({'error': 'Not found'}, status=404)
        else:
            queryset = get_all_miscellaneous()
            if sortBy in allowed_sort_columns and sortOrder in allowed_sort_orders:
                if sortOrder == 'desc':
                    sortBy = '-' + sortBy
                queryset = queryset.order_by(sortBy)
            data = list(queryset.values())
            return JsonResponse({'miscellaneous': data})

    elif request.method == 'POST':
        data = json.loads(request.body)
        misc = insert_miscellaneous(
            name=data['miscellaneous_name'],
            qty_box=data['quantity_box'],
            indiv_stock=data['current_individual_stock'],
            box_stock=data['current_box_stock']
        )
        return JsonResponse({'message': f'Miscellaneous {misc.miscellaneous_name} added'})

    elif request.method == 'PUT' and id:
        data = json.loads(request.body)
        updated = update_miscellaneous(
            misc_id=id,
            name=data['miscellaneous_name'],
            qty_box=data['quantity_box'],
            indiv_stock=data['current_individual_stock'],
            box_stock=data['current_box_stock']
        )
        if updated:
            return JsonResponse({'message': 'Miscellaneous updated'})
        else:
            return JsonResponse({'error': 'Not found'}, status=404)

    elif request.method == 'DELETE' and id:
        deleted, _ = delete_miscellaneous(id)
        if deleted:
            return JsonResponse({'message': 'Miscellaneous deleted'})
        else:
            return JsonResponse({'error': 'Not found'}, status=404)

    return JsonResponse({'error': 'Method not allowed'}, status=405)

