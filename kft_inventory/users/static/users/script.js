document.addEventListener("DOMContentLoaded", function () {
  // Ingredients modal
  const modalIngredients = document.getElementById("filterModalIngredients");
  const btnIngredients = document.getElementById("filterBtnIngredients");
  const closeIngredients = modalIngredients.getElementsByClassName("close")[0];
  const applyIngredients = document.getElementById("applyFilterIngredients");

  btnIngredients.onclick = () => modalIngredients.style.display = "block";
  closeIngredients.onclick = () => modalIngredients.style.display = "none";
  window.onclick = (event) => { if (event.target === modalIngredients) modalIngredients.style.display = "none"; }

  applyIngredients.onclick = () => {
    const sortBy = document.querySelector('input[name="sortByIngredients"]:checked')?.value;
    const order = document.querySelector('input[name="orderIngredients"]:checked')?.value;
    if (!sortBy || !order) { alert("Please select both options."); return; }
    modalIngredients.style.display = "none";
    ingredient_sortBy = sortBy;
    ingredient_order = order;
    fetchIngredients();
  }

  // Miscellaneous modal
  const modalMisc = document.getElementById("filterModalMiscellaneous");
  const btnMisc = document.getElementById("filterBtnMiscellaneous");
  const closeMisc = modalMisc.getElementsByClassName("close")[0];
  const applyMisc = document.getElementById("applyFilterMiscellaneous");

  btnMisc.onclick = () => modalMisc.style.display = "block";
  closeMisc.onclick = () => modalMisc.style.display = "none";
  window.onclick = (event) => { if (event.target === modalMisc) modalMisc.style.display = "none"; }

  applyMisc.onclick = () => {
    const sortBy = document.querySelector('input[name="sortByMiscellaneous"]:checked')?.value;
    const order = document.querySelector('input[name="orderMiscellaneous"]:checked')?.value;
    if (!sortBy || !order) { alert("Please select both options."); return; }
    modalMisc.style.display = "none";
    miscellaneous_sortBy = sortBy;
    miscellaneous_order = order;
    fetchMiscellaneous();
  }
});



var ingredient_order = "asc";
var ingredient_sortBy = "expiration_date";

async function ingredient_change_sort() {
  ingredient_sortBy = document.getElementById('ingredient_sortBy').value;
  fetchIngredients();
}

async function ingredient_change_order() {
  ingredient_order = document.getElementById('ingredient_order').value;
  fetchIngredients();
}

async function fetchIngredients() {
  let url = '/api/ingredients/?sortBy=' + ingredient_sortBy + "&sortOrder=" + ingredient_order;
  const response = await fetch(url);
  const data = await response.json();
  const tbody = document.querySelector('#ingredient-table tbody');
  tbody.innerHTML = '';

  if (data.ingredients.length === 0) {
    tbody.innerHTML = '<tr><td colspan="7">No ingredients found.</td></tr>';
    return;
  }

  data.ingredients.forEach(item => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${item.ingredient_name}</td>
      <td>${item.type}</td>
      <td>${item.quantity_box}</td>
      <td>${item.current_box_stock}</td>
      <td>${item.current_individual_stock}</td>
      <td>${item.expiration_date}</td>
      <td>
        <button onclick="editIngredient(${item.ingredientID})">
          <i class="fa-solid fa-pen-to-square"></i>
          Edit
          </button>
        <button onclick="deleteIngredient(${item.ingredientID})">
          <i class="fa-solid fa-trash"></i>
          Delete
          </button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

document.getElementById('ingredient-form').addEventListener('submit', async function(e) {
  e.preventDefault();
  const id = document.getElementById('ingredientID').value;
  const payload = {
    ingredient_name: document.getElementById('ingredient_name').value,
    type: document.getElementById('type').value,
    quantity_box: parseInt(document.getElementById('quantity_box').value),
    current_box_stock: parseInt(document.getElementById('current_box_stock').value),
    current_individual_stock: parseInt(document.getElementById('current_individual_stock').value),
    expiration_date: document.getElementById('expiration_date').value
  };

  const url = id ? `/api/ingredients/${id}/` : `/api/ingredients/`;
  const method = id ? 'PUT' : 'POST';

  await fetch(url, {
    method: method,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });

  document.getElementById('ingredientID').value = '';
  this.reset();
  fetchIngredients();
});

async function editIngredient(id) {
  const response = await fetch(`/api/ingredients/${id}/`);
  const data = await response.json();

  document.querySelectorAll('#ingredient-table tbody tr').forEach(tr => tr.classList.remove('editing'));
  const rows = document.querySelectorAll('#ingredient-table tbody tr');
  rows.forEach(tr => {
    if (tr.innerHTML.includes(`editIngredient(${id})`)) {
      tr.classList.add('editing');
    }
  });

  document.getElementById('ingredientID').value = id;
  document.getElementById('ingredient_name').value = data.ingredient_name;
  document.getElementById('type').value = data.type;
  document.getElementById('quantity_box').value = data.quantity_box;
  document.getElementById('current_box_stock').value = data.current_box_stock;
  document.getElementById('current_individual_stock').value = data.current_individual_stock;
  document.getElementById('expiration_date').value = data.expiration_date;
}

async function deleteIngredient(id) {
  if (!confirm('Are you sure you want to delete this ingredient?')) return;
  await fetch(`/api/ingredients/${id}/`, { method: 'DELETE' });
  fetchIngredients();
}

fetchIngredients();

var miscellaneous_order = "asc";
var miscellaneous_sortBy = "current_individual_stock";

async function miscellaneous_change_sort() {
  console.log("misc sort call");
  const select = document.getElementById('miscellaneous_sortBy');
  const value = select.value;
  miscellaneous_sortBy = value;

  fetchMiscellaneous();
}
async function miscellaneous_change_order() {
  const select = document.getElementById('miscellaneous_order');
  const value = select.value;
  miscellaneous_order = value;

  fetchMiscellaneous();
}

async function fetchMiscellaneous() {
    let url = '/api/miscellaneous/?sortBy=' + miscellaneous_sortBy 
      + "&sortOrder=" + miscellaneous_order;

  const response = await fetch(url);
  const data = await response.json();
  const tbody = document.querySelector('#miscellaneous-table tbody');
  tbody.innerHTML = '';

  if (data.miscellaneous.length === 0) {
    tbody.innerHTML = '<tr><td colspan="5">No miscellaneous found.</td></tr>';
    return;
  }

  data.miscellaneous.forEach(item => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${item.miscellaneous_name}</td>
      <td>${item.quantity_box}</td>
      <td>${item.current_box_stock}</td>
      <td>${item.current_individual_stock}</td>
      <td>
        <button onclick="editMiscellaneous(${item.miscellaneousID})">
          <i class="fa-solid fa-pen-to-square"></i>
          Edit
          </button>
        <button onclick="deleteMiscellaneous(${item.miscellaneousID})">
          <i class="fa-solid fa-trash"></i>
          Delete
          </button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

document.getElementById('miscellaneous-form').addEventListener('submit', async function(e) {
  e.preventDefault();
  const id = document.getElementById('miscellaneousID').value;
  const payload = {
    miscellaneous_name: document.getElementById('miscellaneous_name').value,
    quantity_box: parseInt(document.getElementById('misc_quantity_box').value),
    current_box_stock: parseInt(document.getElementById('misc_current_box_stock').value),
    current_individual_stock: parseInt(document.getElementById('misc_current_individual_stock').value),
  };

  const url = id ? `/api/miscellaneous/${id}/` : `/api/miscellaneous/`;
  const method = id ? 'PUT' : 'POST';

  await fetch(url, {
    method: method,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });

  document.getElementById('miscellaneousID').value = '';
  this.reset();
  fetchMiscellaneous();
});

async function editMiscellaneous(id) {
  const response = await fetch(`/api/miscellaneous/${id}/`);
  const data = await response.json();

  document.querySelectorAll('#miscellaneous-table tbody tr').forEach(tr => tr.classList.remove('editing'));
  const rows = document.querySelectorAll('#miscellaneous-table tbody tr');
  rows.forEach(tr => {
    if (tr.innerHTML.includes(`editMiscellaneous(${id})`)) {
      tr.classList.add('editing');
    }
  });

  document.getElementById('miscellaneousID').value = id;
  document.getElementById('miscellaneous_name').value = data.miscellaneous_name;
  document.getElementById('misc_quantity_box').value = data.quantity_box;
  document.getElementById('misc_current_box_stock').value = data.current_box_stock;
  document.getElementById('misc_current_individual_stock').value = data.current_individual_stock;
}

async function deleteMiscellaneous(id) {
  if (!confirm('Are you sure you want to delete this miscellaneous?')) return;
  await fetch(`/api/miscellaneous/${id}/`, { method: 'DELETE' });
  fetchMiscellaneous();
}

fetchMiscellaneous();
