String? validateUsername(String? value){
  if (value == null || value.isEmpty) {
    return "Username cannot be empty";
  }
  if (value.length < 6) {
    return "Username has to be at least 6 characters";
  }
  if (value.startsWith(RegExp('^[0-9]'))) {
    return "Username cannot start with a number";
  }
  return null;
}

String? validatePassword(String? value){
  if (value == null || value.isEmpty) {
    return "Password cannot be empty";
  }
  if (value.length < 6) {
    return "Password has to be at least 8 characters";
  }
  return null;
}

String? validateEmail(String? value){
  if(value == null || value.isEmpty){
    return "Email Address cannot be empty";
  }
  if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
    return "Input an email address";
  }
  return null;
}