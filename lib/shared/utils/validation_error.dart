validatePassword(password) {
  if (password == null || password.isEmpty) {
    return {'message': 'Please enter Password'};
  } else if (password.trim().length < 6) {
    return {'message': 'Password must be at least 6 characters'};
  } else {
    return {'message': null};
  }
}

validateEmail(email) {
  if (email == null || email.isEmpty) {
    return {'message': 'Please enter Email'};
  } else if (!RegExp(r'^[\w-\.]+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
      .hasMatch(email)) {
    return {'message': 'Invalid email address'};
  } else {
    return {'message': null};
  }
}

validateName(name, type) {
  if (name == null || name.isEmpty) {
    return {'message': 'Please enter ${type}name'};
  } else if (name.trim().length < 4) {
    return {'message': '${type}name must be at least 4 characters'};
  } else {
    return {'message': null};
  }
}
