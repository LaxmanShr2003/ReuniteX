import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// class ReuniteXApp extends StatelessWidget {
//   const ReuniteXApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ReuniteX',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Georgia',
//         scaffoldBackgroundColor: const Color(0xFFEEF1F8),
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D2B6E)),
//       ),
//       home: const OnboardingFlow(),
//     );
//   }
// }
import 'package:reunite_x/core/validators/app_validators.dart';
import 'package:reunite_x/core/validators/signup_validators.dart';
import 'package:reunite_x/shared/models/SignupModel.dart';

// ─────────────────────────────────────────────
// ONBOARDING FLOW CONTROLLER
// ─────────────────────────────────────────────
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 0; // 0=Step1, 1=Step2, 2=Step3(Password), 3=OTP
  final SignupModel signupData = SignupModel();
  final _formKeys = [
    GlobalKey<FormState>(), // Step 0
    GlobalKey<FormState>(), // Step 1
    GlobalKey<FormState>(), // Step 2
  ];

  void _nextStep() {
    FocusScope.of(context).unfocus();

    // 1. Validate the current Form's TextFormFields (if this step has one).
    if (_currentStep < _formKeys.length) {
      final isValid = _formKeys[_currentStep].currentState?.validate() ?? false;
      if (!isValid) return;
    }

    // 2. Run the centralized, model-based validator. This is what catches
    //    non-TextFormField inputs (date picker, gender chips) and acts as
    //    a single source of truth shared with the rest of the app.
    final error = SignupValidator.validateStep(_currentStep, signupData);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    // 3. Move forward.
    setState(() => _currentStep++);
  }

  void _prevStep() {
    if (_currentStep == 0) return;
    setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return Scaffold(
          body: Form(
            key: _formKeys[0],
            child: PersonalIdentityStep(data: signupData, onNext: _nextStep),
          ),
        );
      case 1:
        return Scaffold(
          body: Form(
            key: _formKeys[1],
            child: PersonalDetailsStep(
              onNext: _nextStep,
              onBack: _prevStep,
              data: signupData,
            ),
          ),
        );
      case 2:
        return Scaffold(
          body: Form(
            key: _formKeys[2],
            child: SecureAccountStep(
              onNext: _nextStep,
              onBack: _prevStep,
              data: signupData,
            ),
          ),
        );
      case 3:
        return Scaffold(body: OtpVerificationStep(onBack: _prevStep));
      default:
        return Scaffold(
          body: Form(
            key: _formKeys[0],
            child: PersonalIdentityStep(data: signupData, onNext: _nextStep),
          ),
        );
    }
  }
}

// ─────────────────────────────────────────────
// SHARED CONSTANTS
// ─────────────────────────────────────────────
const Color kNavy = Color(0xFF0D2B6E);
const Color kBg = Color(0xFFEEF1F8);
const Color kBackBtn = Color(0xFFD6DDE8);
const int kTotalSteps = 3;

// ─────────────────────────────────────────────
// SHARED WIDGET: page scaffold background + footer wrapper
// Every step used a slightly different SafeArea/SingleChildScrollView/Column
// combo before. This gives all of them one consistent shell.
// ─────────────────────────────────────────────
class StepScaffold extends StatelessWidget {
  final Widget header;
  final Widget content;
  final bool showFooter;

  const StepScaffold({
    super.key,
    required this.header,
    required this.content,
    this.showFooter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBg,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: content,
              ),
              const SizedBox(height: 28),
              if (showFooter) buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED WIDGET: header + progress bar
// Step 1 previously built its title inline. Step 2/3 used `buildNavBar`.
// OTP used yet another layout. This one component now covers all of them.
// ─────────────────────────────────────────────
class StepHeader extends StatelessWidget {
  final int stepNumber; // 1-based; pass 0 to hide the progress bar (OTP)
  final VoidCallback? onBack;

  const StepHeader({super.key, required this.stepNumber, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (onBack != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: onBack,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.arrow_back, size: 20, color: Colors.black87),
                        SizedBox(width: 4),
                        Text('Back', style: TextStyle(fontSize: 15, color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
              const Text(
                'ReuniteX',
                style: TextStyle(
                  color: kNavy,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              if (stepNumber > 0)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Step $stepNumber of $kTotalSteps',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ),
        if (stepNumber > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: stepNumber / kTotalSteps,
                minHeight: 5,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(kNavy),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SHARED WIDGET: the white rounded card used by every step
// ─────────────────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  const AppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────
// SHARED WIDGET: labeled text field
// This replaces Step 1's private `_field()` and Step 2's bare `TextField`
// with one component every step uses.
// ─────────────────────────────────────────────
InputDecoration _decoration(String hint, {Widget? suffix}) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kNavy, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.white,
    );

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: _decoration(hint, suffix: suffix),
          validator: validator,
        ),
      ],
    );
  }
}

/// Password field with its own show/hide toggle, sharing the same
/// label/border styling as [AppTextField].
class AppPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const AppPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: !_visible,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: _decoration(
            '••••••••',
            suffix: GestureDetector(
              onTap: () => setState(() => _visible = !_visible),
              child: Icon(
                _visible ? Icons.visibility : Icons.visibility_outlined,
                color: Colors.black45,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SHARED BUTTONS + FOOTER
// ─────────────────────────────────────────────
Widget buildFooter() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _footerLink('Privacy Policy'),
          _footerLink('Terms of Service'),
          _footerLink('Help Center'),
        ],
      ),
      const SizedBox(height: 6),
      const Text(
        '© 2024 ReuniteX. All rights reserved.',
        style: TextStyle(fontSize: 11, color: Colors.black45),
      ),
      const SizedBox(height: 16),
    ],
  );
}

Widget _footerLink(String text) => Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
    );

Widget buildNavyButton(String label, VoidCallback onTap) => SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kNavy,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
      ),
    );

Widget buildBackButton(String label, VoidCallback onTap) => SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kBackBtn,
          foregroundColor: kNavy,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );

// ─────────────────────────────────────────────
// STEP 1 — PERSONAL IDENTITY
// ─────────────────────────────────────────────
class PersonalIdentityStep extends StatefulWidget {
  final VoidCallback onNext;
  final SignupModel data;
  const PersonalIdentityStep({super.key, required this.onNext, required this.data});

  @override
  State<PersonalIdentityStep> createState() => _PersonalIdentityStepState();
}

class _PersonalIdentityStepState extends State<PersonalIdentityStep> {
  late final _nameCtrl = TextEditingController(text: widget.data.fullName);
  late final _emailCtrl = TextEditingController(text: widget.data.email);
  late final _phoneCtrl = TextEditingController(text: widget.data.phone);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _handleNext() {
    // ✅ FIX: previously these values were never written back to the
    // model, so the centralized SignupValidator always saw null fields.
    widget.data.fullName = _nameCtrl.text.trim();
    widget.data.email = _emailCtrl.text.trim();
    widget.data.phone = _phoneCtrl.text.trim();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Center(
                  child: const Text(
                    'ReuniteX',
                    style: TextStyle(
                      color: kNavy,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'STEP 1 OF\n3',
                          style: TextStyle(
                            color: kNavy,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'Personal Identity',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 1 / 3,
                        minHeight: 5,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(kNavy),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Let's start with\nthe basics",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Provide your contact details to begin the reunification process.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _card(),
                  ],
                ),
              ),
              buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Photo upload
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EBF5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: kNavy,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Upload profile photo',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 28),
          _field('Full Name', _nameCtrl, 'John Doe', TextInputType.name),
          const SizedBox(height: 20),
          _field(
            'Email Address',
            _emailCtrl,
            'name@example.com',
            TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _field(
            'Phone Number',
            _phoneCtrl,
            '+1 (555) 000-0000',
            TextInputType.phone,
          ),
          const SizedBox(height: 28),
          buildNavyButton('Next Step', widget.onNext),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              // const Text(
              //   'Log in',
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w700,
              //     color: kNavy,
              //   ),
              // ),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kNavy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider(color: Colors.black26)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR SIGN UP\nWITH',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Colors.black26)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialBtn(
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.black54,
                  size: 22,
                ),
                color: Colors.grey.shade300,
              ),
              const SizedBox(width: 16),
              _socialBtn(
                child: const Icon(
                  Icons.facebook,
                  color: Colors.white,
                  size: 24,
                ),
                color: const Color(0xFF1877F2),
              ),
              const SizedBox(width: 16),
              _socialBtn(
                child: const Text(
                  'X',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                color: Colors.grey.shade200,
              ),
            ],
    return StepScaffold(
      header: const StepHeader(stepNumber: 1),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Let's start with\nthe basics",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black, height: 1.2),
          ),
          const SizedBox(height: 16),
          const Text(
            'Provide your contact details to begin the reunification process.',
            style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 28),
          AppCard(
            child: Column(
              children: [
                _photoUpload(),
                const SizedBox(height: 10),
                const Text(
                  'Upload profile photo',
                  style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 28),
                AppTextField(
                  label: 'Full Name',
                  controller: _nameCtrl,
                  hint: 'John Doe',
                  keyboardType: TextInputType.name,
                  validator: (v) => AppValidators.required(v, field: "Full Name"),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Email Address',
                  controller: _emailCtrl,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.email,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Phone Number',
                  controller: _phoneCtrl,
                  hint: '+1 (555) 000-0000',
                  keyboardType: TextInputType.phone,
                  validator: AppValidators.phone,
                ),
                const SizedBox(height: 28),
                buildNavyButton('Next Step', _handleNext),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Already have an account? ', style: TextStyle(fontSize: 14, color: Colors.black54)),
                    Text('Log in', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kNavy)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.black26)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR SIGN UP\nWITH',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.black26)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialBtn(child: Icon(Icons.image_outlined, color: Colors.black54, size: 22), color: Colors.grey.shade300),
                    const SizedBox(width: 16),
                    _socialBtn(child: const Icon(Icons.facebook, color: Colors.white, size: 24), color: const Color(0xFF1877F2)),
                    const SizedBox(width: 16),
                    _socialBtn(
                      child: const Text('X', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoUpload() {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFE8EBF5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
          ),
          child: const Icon(Icons.add_a_photo_outlined, size: 30, color: Colors.grey),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(color: kNavy, shape: BoxShape.circle),
            child: const Icon(Icons.add, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _socialBtn({required Widget child, required Color color}) => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
        child: Center(child: child),
      );
}

// ─────────────────────────────────────────────
// STEP 2 — PERSONAL DETAILS
// ─────────────────────────────────────────────
class PersonalDetailsStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final SignupModel data;
  const PersonalDetailsStep({super.key, required this.onNext, required this.onBack, required this.data});

  @override
  State<PersonalDetailsStep> createState() => _PersonalDetailsStepState();
}

class _PersonalDetailsStepState extends State<PersonalDetailsStep> {
  late final _dobCtrl = TextEditingController(text: widget.data.dob);
  late String? _selectedGender = widget.data.gender;

  final List<Map<String, dynamic>> _genders = [
    {'label': 'Male', 'icon': Icons.male},
    {'label': 'Female', 'icon': Icons.female},
    {'label': 'Non-binary', 'icon': Icons.transgender},
    {'label': 'Other', 'icon': Icons.visibility_off_outlined},
  ];

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: kNavy)),
        child: child!,
      ),
    );
    if (d != null) {
      setState(() {
        _dobCtrl.text = '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
      });
    }
  }

  void _handleNext() {
    widget.data.dob = _dobCtrl.text;
    widget.data.gender = _selectedGender;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      header: StepHeader(stepNumber: 2, onBack: widget.onBack),
      content: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about yourself',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black, height: 1.2),
            ),
            const SizedBox(height: 16),
            const Text(
              'Providing accurate personal details helps us verify your identity and ensures the safety of our community.',
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Date of Birth',
              controller: _dobCtrl,
              hint: 'mm/dd/yyyy',
              readOnly: true,
              onTap: _pickDate,
              suffix: const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text('Gender', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.8,
              children: _genders.map((g) {
                final selected = _selectedGender == g['label'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedGender = g['label']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? kNavy.withOpacity(0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selected ? kNavy : Colors.grey.shade300, width: selected ? 1.5 : 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(g['icon'] as IconData, size: 18, color: selected ? kNavy : Colors.black54),
                        const SizedBox(width: 8),
                        Text(
                          g['label'] as String,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: selected ? kNavy : Colors.black87),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFEEF1F8), borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.shield_outlined, size: 18, color: kNavy),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your data is encrypted and stored securely. We only use this information to comply with local regulations and ensure institutional trust.',
                      style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            buildNavyButton('Continue', _handleNext),
            const SizedBox(height: 12),
            buildBackButton('Back', widget.onBack),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STEP 3 — SECURE ACCOUNT (Password)
// ─────────────────────────────────────────────
class SecureAccountStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final SignupModel data;
  const SecureAccountStep({super.key, required this.onNext, required this.onBack, required this.data});

  @override
  State<SecureAccountStep> createState() => _SecureAccountStepState();
}

class _SecureAccountStepState extends State<SecureAccountStep> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool get _has8 => _passCtrl.text.length >= 8;
  bool get _hasUpper => _passCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _passCtrl.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

  void _handleNext() {
    widget.data.password = _passCtrl.text;
    widget.data.confirmPassword = _confirmCtrl.text;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      header: StepHeader(stepNumber: 3, onBack: widget.onBack),
      content: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Secure your\naccount',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black, height: 1.2),
              ),
            ),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'Set a strong password to protect your information and connections.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
            ),
            const SizedBox(height: 28),
            AppPasswordField(
              label: 'Password',
              controller: _passCtrl,
              onChanged: (_) => setState(() {}),
              validator: AppValidators.strongPassword,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _req('8+ characters', _has8)),
                Expanded(child: _req('Uppercase letter', _hasUpper)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(child: _req('One number', _hasNumber)),
                Expanded(child: _req('Special character', _hasSpecial)),
              ],
            ),
            const SizedBox(height: 20),
            AppPasswordField(
              label: 'Confirm Password',
              controller: _confirmCtrl,
              validator: (v) => AppValidators.confirmPassword(v, _passCtrl.text),
            ),
            const SizedBox(height: 28),
            buildNavyButton('Create Account', _handleNext),
            const SizedBox(height: 12),
            buildBackButton('Back', widget.onBack),
          ],
        ),
      ),
    );
  }

  Widget _req(String label, bool met) => Row(
        children: [
          Icon(met ? Icons.check_circle_outline : Icons.radio_button_unchecked, size: 16, color: met ? kNavy : Colors.black38),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: met ? Colors.black87 : Colors.black38)),
        ],
      );
}

// ─────────────────────────────────────────────
// OTP VERIFICATION
// ─────────────────────────────────────────────
class OtpVerificationStep extends StatefulWidget {
  final VoidCallback onBack;
  const OtpVerificationStep({super.key, required this.onBack});

  @override
  State<OtpVerificationStep> createState() => _OtpVerificationStepState();
}

class _OtpVerificationStepState extends State<OtpVerificationStep> {
  final List<TextEditingController> _otpCtrls = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendSeconds = 57;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpCtrls) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      // stepNumber 0 hides the progress bar — OTP isn't part of the 1-3 flow.
      header: StepHeader(stepNumber: 0, onBack: widget.onBack),
      content: AppCard(
        child: Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(color: Color(0xFFE8EBF5), shape: BoxShape.circle),
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(color: kNavy, shape: BoxShape.circle),
                  child: const Icon(Icons.verified_user_outlined, color: Colors.white, size: 34),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Verify your phone\nnumber',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black, height: 1.2),
            ),
            const SizedBox(height: 14),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                children: [
                  TextSpan(text: "We've sent a 6-digit verification\ncode to "),
                  TextSpan(text: '+1 (•••) •••-4298', style: TextStyle(color: kNavy, fontWeight: FontWeight.w700)),
                  TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 44,
                  height: 54,
                  child: TextField(
                    controller: _otpCtrls[i],
                    focusNode: _focusNodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: _decoration('').copyWith(counterText: '', contentPadding: EdgeInsets.zero),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5) {
                        _focusNodes[i + 1].requestFocus();
                      } else if (v.isEmpty && i > 0) {
                        _focusNodes[i - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
            buildNavyButton('Verify', () {}),
            const SizedBox(height: 24),
            const Text("Didn't receive the code?", style: TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _resendSeconds == 0
                  ? () {
                      setState(() => _resendSeconds = 60);
                      _startTimer();
                    }
                  : null,
              child: Text(
                _resendSeconds > 0 ? 'Resend Code (${_resendSeconds}s)' : 'Resend Code',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _resendSeconds > 0 ? kNavy : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}