import 'package:reunite_x/core/validators/app_validators.dart';
import 'package:reunite_x/shared/models/SignupModel.dart';

/// Centralized, step-aware validation. This runs *in addition* to the
/// per-field `TextFormField.validator`s so that "Next" is blocked even if
/// a step has fields without their own inline `Form` validators (e.g. the
/// date/gender picker on Step 2, which isn't a `TextFormField`).
class SignupValidator {
  static String? validateStep(int step, SignupModel model) {
    switch (step) {
      case 0:
        return _step1(model);
      case 1:
        return _step2(model);
      case 2:
        return _step3(model);
      default:
        return null;
    }
  }

  static String? _step1(SignupModel model) {
    return AppValidators.required(model.fullName, field: "Full Name") ??
        AppValidators.email(model.email) ??
        AppValidators.phone(model.phone);
  }

  static String? _step2(SignupModel model) {
    if (model.dob == null || model.dob!.isEmpty) {
      return "Date of birth is required";
    }
    if (model.gender == null || model.gender!.isEmpty) {
      return "Gender is required";
    }
    return null;
  }

  static String? _step3(SignupModel model) {
    return AppValidators.strongPassword(model.password) ??
        AppValidators.confirmPassword(
          model.confirmPassword,
          model.password ?? '',
        );
  }
}