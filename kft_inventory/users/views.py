from django.db import connection
from django.shortcuts import render
from .models import Ingredient, Miscellaneous
from django.http import JsonResponse

def home(request):
    
    with connection.cursor() as cursor:
        cursor.callproc('get_all_ingredients')
        ingredients = cursor.fetchall()

        columns = [col[0] for col in cursor.description]

        ingredients = [dict(zip(columns, row)) for row in ingredients]

    with connection.cursor() as cursor:
        cursor.callproc('get_all_miscellaneous')
        misc_items = cursor.fetchall()

        columns = [col[0] for col in cursor.description]

        misc_items = [dict(zip(columns, row)) for row in misc_items]

    return render(request, 'users/home.html', {
        'ingredients': ingredients,
        'misc_items': misc_items
    })

def get_ingredients_json(request):
    with connection.cursor() as cursor:
        cursor.callproc('get_all_ingredients')
        results = cursor.fetchall()
        columns = [col[0] for col in cursor.description]
        ingredients = [dict(zip(columns, row)) for row in results]
    return JsonResponse({'ingredients': ingredients})

def get_miscellaneous_json(request):
    with connection.cursor() as cursor:
        cursor.callproc('get_all_miscellaneous')
        misc_items = cursor.fetchall()

        columns = [col[0] for col in cursor.description]

        misc_items = [dict(zip(columns, row)) for row in misc_items]
    return JsonResponse({'misc_items': misc_items})
