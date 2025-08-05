from django.db import connection
from django.shortcuts import render
from .models import Ingredient, Miscellaneous
from django.http import JsonResponse

def home(request):
    return render(request, 'users/home.html')


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
        miscellaneous = cursor.fetchall()

        columns = [col[0] for col in cursor.description]

        miscellaneous = [dict(zip(columns, row)) for row in miscellaneous]
    return JsonResponse({'miscellaneous': miscellaneous})
