from django.shortcuts import render
from .models import Ingredient, Miscellaneous

def home(request):
    ingredients = Ingredient.objects.all()
    misc_items = Miscellaneous.objects.all()
    
    return render(request, 'users/home.html', {
        'ingredients': ingredients,
        'misc_items': misc_items
    })
