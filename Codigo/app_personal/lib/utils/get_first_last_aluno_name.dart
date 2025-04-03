String getFirstAndLastName(String fullName) {
  List<String> names = fullName.split(' ');
  if (names.length > 1) {
    return '${names.first} ${names.last}';
  }
  return '$fullName'; // Caso o nome tenha apenas uma palavra
}
