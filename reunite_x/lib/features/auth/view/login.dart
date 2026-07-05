// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:reunite_x/core/validators/app_validators.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   final _formKey = GlobalKey<FormState>();
//   bool _obscurePassword = true;
//   bool _rememberMe = false;
//   bool _submitted = false;
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _handleSignIn() {
//     // FocusScope.of(context).unfocus();

//     setState(() => _submitted = true);

//     final isValid = _formKey.currentState?.validate() ?? false;
//     if (!isValid) return;

//     // TODO: replace with real authentication call once the backend is wired up.
//     context.go('/map');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FB),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // App Bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Color(0xFF1A3A8F),
//                     ),
//                     onPressed: () => Navigator.maybePop(context),
//                   ),
//                   const Expanded(
//                     child: Center(
//                       child: Text(
//                         'ReuniteX',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1A3A8F),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 48),
//                 ],
//               ),
//             ),

//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Form(
//                   key: _formKey,
//                   // Validate as the user types after the first failed submit,
//                   // so errors clear the moment they're fixed instead of only
//                   // re-checking on the next "Sign In" tap.
//                   autovalidateMode: _submitted
//                       ? AutovalidateMode.onUserInteraction
//                       : AutovalidateMode.disabled,
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 12),

//                       // Hero image
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Container(
//                           height: 200,
//                           width: double.infinity,
//                           decoration: const BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [Color(0xFF2196C4), Color(0xFF1565A8)],
//                             ),
//                           ),
//                           child: Stack(
//                             children: [
//                               Positioned.fill(
//                                 child: CustomPaint(painter: _MapGridPainter()),
//                               ),
//                               const Positioned(
//                                 top: 48,
//                                 left: 80,
//                                 child: _LocationPin(size: 28),
//                               ),
//                               const Positioned(
//                                 top: 36,
//                                 right: 100,
//                                 child: _LocationPin(size: 24),
//                               ),
//                               const Positioned(
//                                 top: 80,
//                                 left: 130,
//                                 child: _LocationPin(size: 22),
//                               ),
//                               const Positioned(
//                                 top: 100,
//                                 right: 70,
//                                 child: _LocationPin(size: 26),
//                               ),
//                               const Positioned(
//                                 top: 60,
//                                 left: 50,
//                                 child: _LocationPin(size: 20),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 28),

//                       const Text(
//                         'Welcome back!',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w800,
//                           color: Color(0xFF111827),
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Sign in to help reunite families and stay\nupdated on local alerts.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF6B7280),
//                           height: 1.5,
//                         ),
//                       ),

//                       const SizedBox(height: 32),

//                       _buildLabel('Email'),
//                       const SizedBox(height: 6),
//                       _buildTextField(
//                         controller: _emailController,
//                         hint: 'Enter your email',
//                         keyboardType: TextInputType.emailAddress,
//                         validator: AppValidators.email,
//                       ),

//                       const SizedBox(height: 16),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildLabel('Password'),
//                           GestureDetector(
//                             onTap: () {},
//                             child: const Text(
//                               'Forgot password?',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Color(0xFF1A3A8F),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       _buildPasswordField(),

//                       const SizedBox(height: 14),

//                       Row(
//                         children: [
//                           SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: Checkbox(
//                               value: _rememberMe,
//                               onChanged: (v) =>
//                                   setState(() => _rememberMe = v ?? false),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               side: const BorderSide(
//                                 color: Color(0xFFD1D5DB),
//                                 width: 1.5,
//                               ),
//                               activeColor: const Color(0xFF1A3A8F),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           const Text(
//                             'Remember me',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Color(0xFF374151),
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 24),

//                       SizedBox(
//                         width: double.infinity,
//                         height: 54,
//                         child: ElevatedButton(
//                           onPressed: _handleSignIn,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF1A3ABF),
//                             foregroundColor: Colors.white,
//                             elevation: 3,
//                             shadowColor: const Color(
//                               0xFF1A3ABF,
//                             ).withOpacity(0.4),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                           ),
//                           child: const Text(
//                             'Sign In',
//                             style: TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w700,
//                               letterSpacing: 0.3,
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 28),

//                       Row(
//                         children: [
//                           Expanded(child: Divider(color: Colors.grey.shade300)),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 14),
//                             child: Text(
//                               'Or Login with',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey.shade500,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ),
//                           Expanded(child: Divider(color: Colors.grey.shade300)),
//                         ],
//                       ),

//                       const SizedBox(height: 22),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _SocialCircleButton(
//                             onTap: () {},
//                             child: _GoogleLogo(),
//                           ),
//                           const SizedBox(width: 20),
//                           _SocialCircleButton(
//                             onTap: () {},
//                             child: _FacebookLogo(),
//                           ),
//                           const SizedBox(width: 20),
//                           _SocialCircleButton(onTap: () {}, child: _XLogo()),
//                         ],
//                       ),

//                       const SizedBox(height: 32),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "Don't have an account? ",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Color(0xFF6B7280),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => context.go('/register'),
//                             child: const Text(
//                               'Sign up',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color(0xFF1A3A8F),
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 12),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _footerLink('Privacy Policy'),
//                           _footerDot(),
//                           _footerLink('Terms of Service'),
//                           _footerDot(),
//                           _footerLink('Help Center'),
//                         ],
//                       ),

//                       const SizedBox(height: 10),

//                       Text(
//                         '© 2024 ReuniteX Missing Person Finder. All rights reserved.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: Colors.grey.shade400,
//                         ),
//                       ),

//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(String text) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: Color(0xFF374151),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hint,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       validator: validator,
//       style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 15),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 15,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF1A3A8F), width: 1.5),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.redAccent),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
//         ),
//       ),
//     );
//   }

//   Widget _buildPasswordField() {
//     return TextFormField(
//       controller: _passwordController,
//       obscureText: _obscurePassword,
//       validator: AppValidators.loginPassword,
//       style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
//       decoration: InputDecoration(
//         hintText: 'Enter your password',
//         hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 15),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 15,
//         ),
//         suffixIcon: GestureDetector(
//           onTap: () => setState(() => _obscurePassword = !_obscurePassword),
//           child: Icon(
//             _obscurePassword
//                 ? Icons.visibility_outlined
//                 : Icons.visibility_off_outlined,
//             color: const Color(0xFF9CA3AF),
//             size: 22,
//           ),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF1A3A8F), width: 1.5),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.redAccent),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
//         ),
//       ),
//     );
//   }

//   Widget _footerLink(String text) => Text(
//     text,
//     style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
//   );

//   Widget _footerDot() => const Padding(
//     padding: EdgeInsets.symmetric(horizontal: 6),
//     child: Text('·', style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
//   );
// }

// // ── Social circle button ──────────────────────────────────────────────────────

// class _SocialCircleButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final Widget child;

//   const _SocialCircleButton({required this.onTap, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Center(child: child),
//       ),
//     );
//   }
// }

// // ── Google logo (4-color "G") ─────────────────────────────────────────────────

// class _GoogleLogo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(size: const Size(24, 24), painter: _GoogleLogoPainter());
//   }
// }

// class _GoogleLogoPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double cx = size.width / 2;
//     final double cy = size.height / 2;
//     final double r = size.width / 2;

//     final bgPaint = Paint()..color = Colors.white;
//     canvas.drawCircle(Offset(cx, cy), r, bgPaint);

//     final bluePaint = Paint()
//       ..color = const Color(0xFF4285F4)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = size.width * 0.17
//       ..strokeCap = StrokeCap.butt;
//     canvas.drawArc(
//       Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72),
//       -0.52,
//       3.66,
//       false,
//       bluePaint,
//     );

//     _drawArcSegment(
//       canvas,
//       cx,
//       cy,
//       r * 0.72,
//       size.width * 0.17,
//       -0.52,
//       1.05,
//       const Color(0xFF4285F4),
//     );
//     _drawArcSegment(
//       canvas,
//       cx,
//       cy,
//       r * 0.72,
//       size.width * 0.17,
//       0.53,
//       1.05,
//       const Color(0xFF34A853),
//     );
//     _drawArcSegment(
//       canvas,
//       cx,
//       cy,
//       r * 0.72,
//       size.width * 0.17,
//       1.58,
//       1.08,
//       const Color(0xFFFBBC05),
//     );
//     _drawArcSegment(
//       canvas,
//       cx,
//       cy,
//       r * 0.72,
//       size.width * 0.17,
//       2.66,
//       1.08,
//       const Color(0xFFEA4335),
//     );

//     final barPaint = Paint()
//       ..color = const Color(0xFF4285F4)
//       ..strokeWidth = size.width * 0.17
//       ..strokeCap = StrokeCap.square;
//     canvas.drawLine(
//       Offset(cx, cy - size.width * 0.085),
//       Offset(cx + r * 0.72, cy - size.width * 0.085),
//       barPaint,
//     );
//   }

//   void _drawArcSegment(
//     Canvas canvas,
//     double cx,
//     double cy,
//     double radius,
//     double strokeW,
//     double startAngle,
//     double sweep,
//     Color color,
//   ) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeW
//       ..strokeCap = StrokeCap.butt;
//     canvas.drawArc(
//       Rect.fromCircle(center: Offset(cx, cy), radius: radius),
//       startAngle,
//       sweep,
//       false,
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // ── Facebook logo ─────────────────────────────────────────────────────────────

// class _FacebookLogo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 26,
//       height: 26,
//       decoration: const BoxDecoration(
//         color: Color(0xFF1877F2),
//         shape: BoxShape.circle,
//       ),
//       child: const Center(
//         child: Text(
//           'f',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 17,
//             fontWeight: FontWeight.w800,
//             height: 1.1,
//             fontFamily: 'serif',
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── X (Twitter) logo ──────────────────────────────────────────────────────────

// class _XLogo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(size: const Size(22, 22), painter: _XLogoPainter());
//   }
// }

// class _XLogoPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFF0F0F0F)
//       ..strokeWidth = size.width * 0.12
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke;

//     canvas.drawLine(
//       Offset(size.width * 0.08, size.height * 0.08),
//       Offset(size.width * 0.92, size.height * 0.92),
//       paint,
//     );
//     canvas.drawLine(
//       Offset(size.width * 0.92, size.height * 0.08),
//       Offset(size.width * 0.08, size.height * 0.92),
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // ── Map grid hero painter ─────────────────────────────────────────────────────

// class _MapGridPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.12)
//       ..strokeWidth = 1.0;

//     for (double y = 20; y < size.height; y += 28) {
//       canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
//     }
//     for (double x = 20; x < size.width; x += 32) {
//       canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
//     }

//     final roadPaint = Paint()
//       ..color = Colors.white.withOpacity(0.18)
//       ..strokeWidth = 3.0;
//     canvas.drawLine(
//       Offset(0, size.height * 0.45),
//       Offset(size.width, size.height * 0.45),
//       roadPaint,
//     );
//     canvas.drawLine(
//       Offset(size.width * 0.38, 0),
//       Offset(size.width * 0.38, size.height),
//       roadPaint,
//     );

//     final blockPaint = Paint()
//       ..color = Colors.white.withOpacity(0.07)
//       ..style = PaintingStyle.fill;
//     canvas.drawRect(
//       Rect.fromLTWH(size.width * 0.08, size.height * 0.1, 80, 48),
//       blockPaint,
//     );
//     canvas.drawRect(
//       Rect.fromLTWH(size.width * 0.5, size.height * 0.55, 72, 44),
//       blockPaint,
//     );
//     canvas.drawRect(
//       Rect.fromLTWH(size.width * 0.6, size.height * 0.15, 56, 36),
//       blockPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // ── Location pin widget ───────────────────────────────────────────────────────

// class _LocationPin extends StatelessWidget {
//   final double size;
//   const _LocationPin({required this.size});

//   @override
//   Widget build(BuildContext context) {
//     return Icon(
//       Icons.location_on,
//       color: Colors.white,
//       size: size,
//       shadows: [Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 6)],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:reunite_x/core/validators/app_validators.dart';
import 'package:reunite_x/features/auth/service/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isSubmitting = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSubmitting = true);

    try {
      // AuthService is a mock backed by assets/data/users.json for now —
      // every account there logs in with AuthService.demoPassword until a
      // real backend replaces this call.
      await AuthService.instance.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      context.go('/map');
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A8F)),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'ReuniteX',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3A8F),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  // Validate as the user types after the first failed submit,
                  // so errors clear the moment they're fixed instead of only
                  // re-checking on the next "Sign In" tap.
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // Hero image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2196C4), Color(0xFF1565A8)],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CustomPaint(painter: _MapGridPainter()),
                              ),
                              const Positioned(
                                top: 48, left: 80,
                                child: _LocationPin(size: 28),
                              ),
                              const Positioned(
                                top: 36, right: 100,
                                child: _LocationPin(size: 24),
                              ),
                              const Positioned(
                                top: 80, left: 130,
                                child: _LocationPin(size: 22),
                              ),
                              const Positioned(
                                top: 100, right: 70,
                                child: _LocationPin(size: 26),
                              ),
                              const Positioned(
                                top: 60, left: 50,
                                child: _LocationPin(size: 20),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to help reunite families and stay\nupdated on local alerts.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      _buildLabel('Email'),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: _emailController,
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.email,
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLabel('Password'),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1A3A8F),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _buildPasswordField(),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (v) => setState(() => _rememberMe = v ?? false),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
                              activeColor: const Color(0xFF1A3A8F),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Remember me',
                            style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _handleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A3ABF),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF1A3ABF).withOpacity(0.6),
                            elevation: 3,
                            shadowColor: const Color(0xFF1A3ABF).withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'Or Login with',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialCircleButton(onTap: () {}, child: _GoogleLogo()),
                          const SizedBox(width: 20),
                          _SocialCircleButton(onTap: () {}, child: _FacebookLogo()),
                          const SizedBox(width: 20),
                          _SocialCircleButton(onTap: () {}, child: _XLogo()),
                        ],
                      ),

                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1A3A8F),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _footerLink('Privacy Policy'),
                          _footerDot(),
                          _footerLink('Terms of Service'),
                          _footerDot(),
                          _footerLink('Help Center'),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        '© 2024 ReuniteX Missing Person Finder. All rights reserved.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A3A8F), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      validator: AppValidators.loginPassword,
      style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscurePassword = !_obscurePassword),
          child: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFF9CA3AF),
            size: 22,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A3A8F), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _footerLink(String text) => Text(
        text,
        style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
      );

  Widget _footerDot() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text('·', style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
      );
}

// ── Social circle button ──────────────────────────────────────────────────────

class _SocialCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _SocialCircleButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ── Google logo (4-color "G") ─────────────────────────────────────────────────

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(24, 24), painter: _GoogleLogoPainter());
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.17
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72),
      -0.52,
      3.66,
      false,
      bluePaint,
    );

    _drawArcSegment(canvas, cx, cy, r * 0.72, size.width * 0.17,
        -0.52, 1.05, const Color(0xFF4285F4));
    _drawArcSegment(canvas, cx, cy, r * 0.72, size.width * 0.17,
        0.53, 1.05, const Color(0xFF34A853));
    _drawArcSegment(canvas, cx, cy, r * 0.72, size.width * 0.17,
        1.58, 1.08, const Color(0xFFFBBC05));
    _drawArcSegment(canvas, cx, cy, r * 0.72, size.width * 0.17,
        2.66, 1.08, const Color(0xFFEA4335));

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = size.width * 0.17
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(
      Offset(cx, cy - size.width * 0.085),
      Offset(cx + r * 0.72, cy - size.width * 0.085),
      barPaint,
    );
  }

  void _drawArcSegment(Canvas canvas, double cx, double cy, double radius,
      double strokeW, double startAngle, double sweep, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      startAngle,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Facebook logo ─────────────────────────────────────────────────────────────

class _FacebookLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            height: 1.1,
            fontFamily: 'serif',
          ),
        ),
      ),
    );
  }
}

// ── X (Twitter) logo ──────────────────────────────────────────────────────────

class _XLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(22, 22), painter: _XLogoPainter());
  }
}

class _XLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F0F0F)
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.08),
      Offset(size.width * 0.92, size.height * 0.92),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.92, size.height * 0.08),
      Offset(size.width * 0.08, size.height * 0.92),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Map grid hero painter ─────────────────────────────────────────────────────

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..strokeWidth = 1.0;

    for (double y = 20; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 20; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..strokeWidth = 3.0;
    canvas.drawLine(
        Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.45), roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.38, 0), Offset(size.width * 0.38, size.height), roadPaint);

    final blockPaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.08, size.height * 0.1, 80, 48), blockPaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.5, size.height * 0.55, 72, 44), blockPaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.6, size.height * 0.15, 56, 36), blockPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Location pin widget ───────────────────────────────────────────────────────

class _LocationPin extends StatelessWidget {
  final double size;
  const _LocationPin({required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.location_on, color: Colors.white, size: size, shadows: [
      Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 6),
    ]);
  }
}