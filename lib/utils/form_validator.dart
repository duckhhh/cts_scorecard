class FormValidator {
  static bool validate(Map<String, dynamic> formData, List<String> requiredFields) {
    for (String field in requiredFields) {
      if (!formData.containsKey(field) || formData[field] == null || formData[field].toString().isEmpty) {
        return false;
      }
    }
    return true;
  }
}