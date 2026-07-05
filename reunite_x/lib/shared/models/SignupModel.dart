/// Holds all data collected across the multi-step signup flow.
///
/// Renamed from `signup_model` -> `SignupModel` to follow Dart's
/// UpperCamelCase class naming convention.
class SignupModel {
  String? fullName;
  String? email;
  String? phone;
  String? dob;
  String? gender;
  String? password;
  String? confirmPassword;

  @override
  String toString() {
    return 'SignupModel(fullName: $fullName, email: $email, phone: $phone, '
        'dob: $dob, gender: $gender)';
  }
}