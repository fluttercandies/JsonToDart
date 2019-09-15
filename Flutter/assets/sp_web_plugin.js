function _putValue(key, value) {
  localStorage.setItem(key, value);
}

function _getValue(key) {
  return localStorage.getItem(key);
}

function _clear() {
  localStorage.clear();
}

function _removeValue(key) {
  localStorage.removeItem(key);
}
