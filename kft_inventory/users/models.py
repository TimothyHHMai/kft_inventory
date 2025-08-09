from django.db import models

class Ingredient(models.Model):
    ingredientID = models.AutoField(primary_key=True, db_column='ingredientID')

    TYPE_CHOICES = [
        ('Syrup', 'Syrup'),
        ('Powder', 'Powder'),
        ('Topping', 'Topping'),
        ('Tea', 'Tea'),
    ]

    ingredient_name = models.CharField(max_length=50, db_column='ingredient_name')
    type = models.CharField(max_length=10, choices=TYPE_CHOICES)
    quantity_box = models.IntegerField(default=0)
    current_individual_stock = models.IntegerField(default=0)
    current_box_stock = models.IntegerField(default=0)
    expiration_date = models.DateField()

    def __str__(self):
        return f"{self.ingredient_name} ({self.type})"

    class Meta:
        db_table = 'ingredients'


class Miscellaneous(models.Model):
    miscellaneousID = models.AutoField(primary_key=True, db_column='miscellaneousID')

    miscellaneous_name = models.CharField(max_length=50, db_column='miscellaneous_name')
    quantity_box = models.IntegerField(default=0)
    current_individual_stock = models.IntegerField(default=0)
    current_box_stock = models.IntegerField(default=0)

    def __str__(self):
        return self.miscellaneous_name

    class Meta:
        db_table = 'miscellaneous'
