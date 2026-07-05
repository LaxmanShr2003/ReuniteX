/// Field-level, reusable validators. Every validator returns `null` when
/// the value is valid, or an error string to display when it isn't.
class AppValidators {
  static String? required(String? value, {String field = "Field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$field is required";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return "Email is required";

    final emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 7) {
      return "Enter a valid phone number";
    }
    return null;
  }

  /// Matches the requirement checklist shown on the Secure Account step
  /// (8+ chars, uppercase, number, special character) so the inline
  /// checklist and the centralized validator never disagree.
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Use at least 8 characters";
    if (!value.contains(RegExp(r'[A-Z]'))) return "Add an uppercase letter";
    if (!value.contains(RegExp(r'[0-9]'))) return "Add a number";
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return "Add a special character";
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return "Please confirm your password";
    if (value != original) return "Passwords do not match";
    return null;
  }


    static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    return null;
  }
}