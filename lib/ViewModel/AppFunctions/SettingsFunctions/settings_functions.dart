class SettingsFunctions {
  // Function to fetch edit fields hint text
  String? fetchHintText(
      {required bool isPasswordField, required String? hintText}) {
    if (isPasswordField) {
      return hintText?.replaceAll(RegExp('.'), '⦁');
    } else {
      return hintText;
    }
  }

  // Function to validate text fields
  String? Function(String?)? textFieldValidator = null;
}
