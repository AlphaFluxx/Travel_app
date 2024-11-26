final List<Map<String, String>> dummyUsers = [
  {'username': 'ahmad', 'email': 'ahmad@gmail.com', 'password': 'ahmad123'},
  {'username': 'farhan', 'email': 'farhan@gmail.com', 'password': 'farhan123'},
];

// fungsi untuk memeriksa apakah email sudah digunakan
bool isEmailInUse(String email) {
  for (var user in dummyUsers) {
    if (user['email'] == email) {
      return true;
    }
  }
  return false;
}

// fungsi untuk memeriksa apakah username sudah digunakan
bool isUsernameInUse(String username) {
  for (var user in dummyUsers) {
    if (user['username'] == username) {
      return true;
    }
  }
  return false;
}

// fungsi untuk memeriksa apakah username dan password cocok
bool isValidUser(String username, String password) {
  for (var user in dummyUsers) {
    if (user['username'] == username && user['password'] == password) {
      return true;
    }
  }
  return false;
}

// fungsi untuk mendaftarkan pengguna baru
bool register(String username, String email, String password) {
  if (isEmailInUse(email) || isUsernameInUse(username)) {
    return false; 
  } else {
    dummyUsers.add({'username': username, 'email': email, 'password': password});
    return true; 
  }
}

