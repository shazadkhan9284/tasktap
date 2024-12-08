String? customValidator({
  required String? value,
  required String fieldName,
  int? minLength,
  int? maxLength,
  bool isEmail = false,
  bool isPassword = false,
  bool isPhone = false,
}) {
  if (value == null || value.isEmpty) {
    return "$fieldName can't be empty.";
  }

  if (minLength != null && value.length < minLength) {
    return "$fieldName must be at least $minLength characters.";
  }

  if (maxLength != null && value.length > maxLength) {
    return "$fieldName can't exceed $maxLength characters.";
  }

  if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return "Please enter a valid email address.";
  }

  if (isPassword && value.length < 6) {
    return "Password must be at least 6 characters.";
  }

  if (isPhone && !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
    return "Please enter a valid phone number.";
  }

  return null; // No error
}
