from django.shortcuts import render
from .models import Ingredient, Miscellaneous
from django.http import JsonResponse
import json
from django.views.decorators.csrf import csrf_exempt

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
                ingredient = Ingredient.objects.get(ingredientID=id)
                return JsonResponse({
                    'ingredientID': ingredient.ingredientID,
                    'ingredient_name': ingredient.ingredient_name,
                    'type': ingredient.type,
                    'quantity_box': ingredient.quantity_box,
                    'current_individual_stock': ingredient.current_individual_stock,
                    'current_box_stock': ingredient.current_box_stock,
                    'expiration_date': ingredient.expiration_date
                })
            except Ingredient.DoesNotExist:
                return JsonResponse({'error': 'Not found'}, status=404)
        else:
            queryset = Ingredient.objects.all()
            if sortBy in allowed_sort_columns and sortOrder in allowed_sort_orders:
                if sortOrder == 'desc':
                    sortBy = '-' + sortBy
                queryset = queryset.order_by(sortBy)
            data = list(queryset.values())
            return JsonResponse({'ingredients': data})

    elif request.method == 'POST':
        data = json.loads(request.body)
        Ingredient.objects.create(
            ingredient_name=data['ingredient_name'],
            type=data['type'],
            quantity_box=data['quantity_box'],
            current_individual_stock=data['current_individual_stock'],
            current_box_stock=data['current_box_stock'],
            expiration_date=data['expiration_date']
        )
        return JsonResponse({'message': 'Ingredient added'})

    elif request.method == 'PUT' and id:
        data = json.loads(request.body)
        updated = Ingredient.objects.filter(ingredientID=id).update(
            ingredient_name=data['ingredient_name'],
            type=data['type'],
            quantity_box=data['quantity_box'],
            current_individual_stock=data['current_individual_stock'],
            current_box_stock=data['current_box_stock'],
            expiration_date=data['expiration_date']
        )
        if updated:
            return JsonResponse({'message': 'Ingredient updated'})
        else:
            return JsonResponse({'error': 'Not found'}, status=404)

    elif request.method == 'DELETE' and id:
        deleted, _ = Ingredient.objects.filter(ingredientID=id).delete()
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
            try:
                misc = Miscellaneous.objects.get(miscellaneousID=id)
                return JsonResponse({
                    'miscellaneousID': misc.miscellaneousID,
                    'miscellaneous_name': misc.miscellaneous_name,
                    'quantity_box': misc.quantity_box,
                    'current_individual_stock': misc.current_individual_stock,
                    'current_box_stock': misc.current_box_stock
                })
            except Miscellaneous.DoesNotExist:
                return JsonResponse({'error': 'Not found'}, status=404)
        else:
            queryset = Miscellaneous.objects.all()
            if sortBy in allowed_sort_columns and sortOrder in allowed_sort_orders:
                if sortOrder == 'desc':
                    sortBy = '-' + sortBy
                queryset = queryset.order_by(sortBy)
            data = list(queryset.values())
            return JsonResponse({'miscellaneous': data})

    elif request.method == 'POST':
        data = json.loads(request.body)
        Miscellaneous.objects.create(
            miscellaneous_name=data['miscellaneous_name'],
            quantity_box=data['quantity_box'],
            current_individual_stock=data['current_individual_stock'],
            current_box_stock=data['current_box_stock']
        )
        return JsonResponse({'message': 'Miscellaneous added'})

    elif request.method == 'PUT' and id:
        data = json.loads(request.body)
        updated = Miscellaneous.objects.filter(miscellaneousID=id).update(
            miscellaneous_name=data['miscellaneous_name'],
            quantity_box=data['quantity_box'],
            current_individual_stock=data['current_individual_stock'],
            current_box_stock=data['current_box_stock']
        )
        if updated:
            return JsonResponse({'message': 'Miscellaneous updated'})
        else:
            return JsonResponse({'error': 'Not found'}, status=404)

    elif request.method == 'DELETE' and id:
        deleted, _ = Miscellaneous.objects.filter(miscellaneousID=id).delete()
        if deleted:
            return JsonResponse({'message': 'Miscellaneous deleted'})
        else:
            return JsonResponse({'error': 'Not found'}, status=404)

    return JsonResponse({'error': 'Method not allowed'}, status=405)
