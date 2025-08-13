# KFT_INVENTORY


## using SQLite (default)

### First Build

#### 1. source inventory/Scripts/activate
#### 2. python manage.py makemigrations
#### 3. python manage.py migrate
#### 4. python manage.py loaddata initial_data.json

### Run server

#### python manage.py runserver


## using mySQL

### First Build

#### 1. source inventory/Scripts/activate
#### 2. **IN SQL** run django_init_inventory
#### 3. python manage.py makemigrations
#### 4. python manage.py migrate
#### 5. **IN SQL** select kftinventory as database - make sure its bolded
#### 6. **IN SQL** run procedure scripts
#### 7. python manage.py loaddata initial_data.json

### Run server

#### python manage.py runserver