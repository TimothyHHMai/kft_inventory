from django.urls import path
from users import views

urlpatterns = [
    path("", views.home, name="home"),

    path('api/ingredients/<int:id>/', views.ingredients_api),
    path('api/ingredients/json/', views.get_ingredients_json),
    path('api/ingredients/', views.get_ingredients_json, name='get_ingredients_json'),

    path('api/miscellaneous/<int:id>/', views.miscellaneous_api),
    path('api/miscellaneous/', views.get_miscellaneous_json),
    path('api/miscellaneous/', views.get_miscellaneous_json, name='get_miscellaneous_json'),
]