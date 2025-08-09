from django.urls import path
from users import views

urlpatterns = [
    path("", views.home, name="home"),

    path('api/ingredients/', views.ingredients_api),
    path('api/ingredients/<int:id>/', views.ingredients_api),
    
    path('api/miscellaneous/', views.miscellaneous_api),
    path('api/miscellaneous/<int:id>/', views.miscellaneous_api),
]
