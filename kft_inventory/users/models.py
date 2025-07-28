from django.db import models

class Ingredient(models.Model):
    ingredientID = models.AutoField(primary_key=True, db_column='ingredientID')
    ingredientName = models.CharField(max_length=50, db_column='ingredientName')
    type = models.CharField(max_length=10, db_column='type')
    quantity_box = models.IntegerField(default=0, db_column='quantity_box')
    current_individual_stock = models.IntegerField(default=0, db_column='current_individual_stock')
    current_box_stock = models.IntegerField(default=0, db_column='current_box_stock')
    expiration_date = models.DateField(db_column='expiration_date')

    class Meta:
        managed = False  
        db_table = 'ingredients'


class Miscellaneous(models.Model):
    miscellaneousID = models.AutoField(primary_key=True, db_column='miscellaneousID')
    miscellaneous_name = models.CharField(max_length=50, db_column='miscellaneous_name')
    quantity_box = models.IntegerField(default=0, db_column='quantity_box')
    current_individual_stock = models.IntegerField(default=0, db_column='current_individual_stock')
    current_box_stock = models.IntegerField(default=0, db_column='current_box_stock')

    class Meta:
        managed = False  
        db_table = 'miscellaneous'
