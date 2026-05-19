import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _nextStep() => setState(() => _currentStep++);
  void _prevStep() => setState(() {
    if (_currentStep > 0) _currentStep--;
  });

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return PersonalIdentityStep(onNext: _nextStep);
      case 1:
        return PersonalDetailsStep(onNext: _nextStep, onBack: _prevStep);
      case 2:
        return SecureAccountStep(onNext: _nextStep, onBack: _prevStep);
      case 3:
        return OtpVerificationStep(onBack: _prevStep);
      default:
        return PersonalIdentityStep(onNext: _nextStep);
    }
  }
}

// ─────────────────────────────────────────────
// SHARED CONSTANTS & WIDGETS
// ─────────────────────────────────────────────
const Color kNavy = Color(0xFF0D2B6E);
const Color kBg = Color(0xFFEEF1F8);
const Color kBackBtn = Color(0xFFD6DDE8);

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
  style: const TextStyle(
    fontSize: 12,
    color: Colors.black54,
    fontWeight: FontWeight.w500,
  ),
);

Widget buildNavBar({
  required String title,
  VoidCallback? onBack,
  Widget? trailing,
}) {
  return Padding(
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
                  Text(
                    'Back',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        Text(
          title,
          style: const TextStyle(
            color: kNavy,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        if (trailing != null)
          Align(alignment: Alignment.centerRight, child: trailing),
      ],
    ),
  );
}

InputDecoration buildInputDecoration(String hint, {Widget? suffix}) =>
    InputDecoration(
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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
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
    child: Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
);

// ─────────────────────────────────────────────
// STEP 1 — PERSONAL IDENTITY
// ─────────────────────────────────────────────
class PersonalIdentityStep extends StatefulWidget {
  final VoidCallback onNext;
  const PersonalIdentityStep({super.key, required this.onNext});

  @override
  State<PersonalIdentityStep> createState() => _PersonalIdentityStepState();
}

class _PersonalIdentityStepState extends State<PersonalIdentityStep> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
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
              const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kNavy,
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
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl,
    String hint,
    TextInputType type,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: type,
          decoration: buildInputDecoration(hint),
        ),
      ],
    );
  }

  Widget _socialBtn({required Widget child, required Color color}) => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Center(child: child),
  );
}

// ─────────────────────────────────────────────
// STEP 2 — PERSONAL DETAILS
// ─────────────────────────────────────────────
class PersonalDetailsStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const PersonalDetailsStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<PersonalDetailsStep> createState() => _PersonalDetailsStepState();
}

class _PersonalDetailsStepState extends State<PersonalDetailsStep> {
  final _dobCtrl = TextEditingController();
  String? _selectedGender;

  final List<Map<String, dynamic>> _genders = [
    {'label': 'Male', 'icon': Icons.male},
    {'label': 'Female', 'icon': Icons.female},
    {'label': 'Non-binary', 'icon': Icons.transgender},
    {'label': 'Other', 'icon': Icons.visibility_off_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildNavBar(
                title: 'ReuniteX',
                onBack: widget.onBack,
                trailing: const Text(
                  'Personal Details',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              // Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Step 2 of 3',
                      style: TextStyle(
                        color: kNavy,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 2 / 3,
                        minHeight: 5,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(kNavy),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tell us about yourself',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Providing accurate personal details helps us verify your identity and ensures the safety of our community.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // DOB
                      const Text(
                        'Date of Birth',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _dobCtrl,
                        readOnly: true,
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: DateTime(1990),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (ctx, child) => Theme(
                              data: Theme.of(ctx).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: kNavy,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (d != null) {
                            setState(() {
                              _dobCtrl.text =
                                  '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
                            });
                          }
                        },
                        decoration: buildInputDecoration(
                          'mm/dd/yyyy',
                          suffix: const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Gender
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
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
                            onTap: () =>
                                setState(() => _selectedGender = g['label']),
                            child: Container(
                              decoration: BoxDecoration(
                                color: selected
                                    ? kNavy.withOpacity(0.08)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected
                                      ? kNavy
                                      : Colors.grey.shade300,
                                  width: selected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    g['icon'] as IconData,
                                    size: 18,
                                    color: selected ? kNavy : Colors.black54,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    g['label'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: selected ? kNavy : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      // Privacy note
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF1F8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.shield_outlined, size: 18, color: kNavy),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Your data is encrypted and stored securely. We only use this information to comply with local regulations and ensure institutional trust.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      buildNavyButton('Continue', widget.onNext),
                      const SizedBox(height: 12),
                      buildBackButton('Back', widget.onBack),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              buildFooter(),
            ],
          ),
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
  const SecureAccountStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SecureAccountStep> createState() => _SecureAccountStepState();
}

class _SecureAccountStepState extends State<SecureAccountStep> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPass = false;
  bool _showConfirm = false;

  bool get _has8 => _passCtrl.text.length >= 8;
  bool get _hasUpper => _passCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial =>
      _passCtrl.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildNavBar(
                title: 'ReuniteX',
                onBack: widget.onBack,
                trailing: const Text(
                  'Step 3 of 3',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step dots
                      Row(
                        children: List.generate(
                          3,
                          (i) => Expanded(
                            child: Container(
                              height: 5,
                              margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                              decoration: BoxDecoration(
                                color: kNavy,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Center(
                        child: Text(
                          'Secure your\naccount',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Center(
                        child: Text(
                          'Set a strong password to protect your information and connections.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Password field
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passCtrl,
                        obscureText: !_showPass,
                        onChanged: (_) => setState(() {}),
                        decoration: buildInputDecoration(
                          '••••••••',
                          suffix: GestureDetector(
                            onTap: () => setState(() => _showPass = !_showPass),
                            child: Icon(
                              _showPass
                                  ? Icons.visibility
                                  : Icons.visibility_outlined,
                              color: Colors.black45,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Requirements grid
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
                          Expanded(
                            child: _req('Special character', _hasSpecial),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Confirm password
                      const Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _confirmCtrl,
                        obscureText: !_showConfirm,
                        onChanged: (_) => setState(() {}),
                        decoration: buildInputDecoration(
                          '••••••••',
                          suffix: GestureDetector(
                            onTap: () =>
                                setState(() => _showConfirm = !_showConfirm),
                            child: Icon(
                              _showConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_outlined,
                              color: Colors.black45,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      buildNavyButton('Create Account', widget.onNext),
                      const SizedBox(height: 12),
                      buildBackButton('Back', widget.onBack),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _req(String label, bool met) => Row(
    children: [
      Icon(
        met ? Icons.check_circle_outline : Icons.radio_button_unchecked,
        size: 16,
        color: met ? kNavy : Colors.black38,
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: met ? Colors.black87 : Colors.black38,
        ),
      ),
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
  final List<TextEditingController> _otpCtrls = List.generate(
    6,
    (_) => TextEditingController(),
  );
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
    for (final c in _otpCtrls) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
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
              buildNavBar(title: 'ReuniteX', onBack: widget.onBack),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
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
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      // Shield icon
                      Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8EBF5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: kNavy,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_user_outlined,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Verify your phone\nnumber',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 14),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "We've sent a 6-digit verification\ncode to ",
                            ),
                            TextSpan(
                              text: '+1 (•••) •••-4298',
                              style: TextStyle(
                                color: kNavy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // OTP boxes
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: kNavy,
                                    width: 1.5,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
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
                      Text(
                        "Didn't receive the code?",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: _resendSeconds == 0
                            ? () {
                                setState(() => _resendSeconds = 60);
                                _startTimer();
                              }
                            : null,
                        child: Text(
                          _resendSeconds > 0
                              ? 'Resend Code (${_resendSeconds}s)'
                              : 'Resend Code',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _resendSeconds > 0 ? kNavy : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
