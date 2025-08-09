from django.db import connection
from django.shortcuts import render
from .models import Ingredient, Miscellaneous
from django.http import JsonResponse
import json
from django.views.decorators.csrf import csrf_exempt


def home(request):
    return render(request, 'users/home.html')

@csrf_exempt
def ingredients_api(request, id=None):
    cursor = connection.cursor()

    if request.method == 'GET':
        sortBy = request.GET.get('sortBy')  
        sortOrder = request.GET.get('sortOrder', 'asc').lower() 

        allowed_sort_columns = {'expiration_date', 'ingredient_name', 'current_individual_stock', 'current_box_stock'}  
        allowed_sort_orders = {'asc', 'desc'}

        if id:
            cursor.execute("SELECT * FROM ingredients WHERE ingredientID = %s", [id])
            row = cursor.fetchone()
            if not row:
                return JsonResponse({'error': 'Not found'}, status=404)
            keys = [col[0] for col in cursor.description]
            return JsonResponse(dict(zip(keys, row)))
        else:
            if sortBy in allowed_sort_columns and sortOrder in allowed_sort_orders:
                query = f"SELECT * FROM ingredients ORDER BY {sortBy} {sortOrder.upper()}"
                cursor.execute(query)
            else:
                cursor.execute("CALL get_all_ingredients()")

            results = cursor.fetchall()
            keys = [col[0] for col in cursor.description]
            data = [dict(zip(keys, row)) for row in results]
            return JsonResponse({'ingredients': data})

    elif request.method == 'POST':
        data = json.loads(request.body)
        cursor.callproc('insert_ingredient', [
            data['ingredient_name'], data['type'], data['quantity_box'],
            data['current_individual_stock'], data['current_box_stock'], data['expiration_date']
        ])
        return JsonResponse({'message': 'Ingredient added'})

    elif request.method == 'PUT' and id:
        data = json.loads(request.body)
        cursor.callproc('update_ingredient', [
            id, data['ingredient_name'], data['type'], data['quantity_box'],
            data['current_individual_stock'], data['current_box_stock'], data['expiration_date']
        ])
        return JsonResponse({'message': 'Ingredient updated'})

    elif request.method == 'DELETE' and id:
        cursor.callproc('delete_ingredient', [id])
        return JsonResponse({'message': 'Ingredient deleted'})


    return JsonResponse({'error': 'Method not allowed'}, status=405)

@csrf_exempt
def miscellaneous_api(request, id=None):
    cursor = connection.cursor()

    if request.method == 'GET':
        if id:
            cursor.execute("SELECT * FROM miscellaneous WHERE miscellaneousID = %s", [id])
            row = cursor.fetchone()
            if not row:
                return JsonResponse({'error': 'Not found'}, status=404)
            keys = [col[0] for col in cursor.description]
            return JsonResponse(dict(zip(keys, row)))
        else:
            cursor.execute("CALL get_all_miscellaneous()")
            results = cursor.fetchall()
            keys = [col[0] for col in cursor.description]
            data = [dict(zip(keys, row)) for row in results]
            return JsonResponse({'miscellaneous': data})

    elif request.method == 'POST':
        data = json.loads(request.body)
        cursor.callproc('insert_miscellaneous', [
            data['miscellaneous_name'], data['quantity_box'],
            data['current_individual_stock'], data['current_box_stock']
        ])
        return JsonResponse({'message': 'Miscellaneous added'})

    elif request.method == 'PUT' and id:
        data = json.loads(request.body)
        cursor.callproc('update_miscellaneous', [
            id, data['miscellaneous_name'], data['quantity_box'],
            data['current_individual_stock'], data['current_box_stock']
        ])
        return JsonResponse({'message': 'Miscellaneous updated'})

    elif request.method == 'DELETE' and id:
        cursor.callproc('delete_miscellaneous', [id])
        return JsonResponse({'message': 'Miscellaneous deleted'})

    return JsonResponse({'error': 'Method not allowed'}, status=405)
