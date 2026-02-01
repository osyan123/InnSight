import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../../services/role_router.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _hidePassword = true;
  bool _rememberMe = false;
  bool _busy = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const Color _teal = Color(0xFF0B8F84);
  static const Color _fill = Color(0xFFF3F4F6);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _input({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: _fill,
      prefixIcon: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _loginEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _toast('Please enter email and password');
      return;
    }

    setState(() => _busy = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      await RoleRouter.routeAfterLogin(
        context,
        managerRoute: '/manager-floorplan',
        frontDeskRoute: '/frontdesk',
        loginRoute: '/login',
      );
    } on FirebaseAuthException catch (e) {
      _toast(e.message ?? 'Login failed');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _loginGoogle() async {
    if (_busy) return;

    setState(() => _busy = true);
    try {
      await AuthService.instance.signInWithGoogle();

      if (!mounted) return;

      await RoleRouter.routeAfterLogin(
        context,
        managerRoute: '/manager-floorplan',
        frontDeskRoute: '/frontdesk',
        loginRoute: '/login',
      );
    } on AuthException catch (e) {
      _toast(e.message);
    } catch (e) {
      _toast('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _teal,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Sign in to your account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),

        const _FieldLabel('Email Address'),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _input(
            hint: 'student@aclc.edu.ph',
            icon: Icons.mail_outline_rounded,
          ),
        ),
        const SizedBox(height: 14),

        const _FieldLabel('Password'),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: _hidePassword,
          decoration: _input(
            hint: 'Enter your password',
            icon: Icons.lock_outline_rounded,
            suffix: IconButton(
              icon: Icon(
                _hidePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF9CA3AF),
              ),
              onPressed: () => setState(() => _hidePassword = !_hidePassword),
            ),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (v) => setState(() => _rememberMe = v ?? false),
              activeColor: _teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Text(
              'Remember me',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: _teal, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _busy ? null : _loginEmail,
            child: Text(
              _busy ? 'Signing In…' : 'Sign In',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),

        const SizedBox(height: 24),
        const _DividerWithText(text: 'Or continue with'),
        const SizedBox(height: 20),

        SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: _busy ? null : _loginGoogle,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/google.jpg', height: 22, width: 22),
                const SizedBox(width: 12),
                const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w800,
        color: Color(0xFF111827),
      ),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  final String text;
  const _DividerWithText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1, color: Color(0xFFE5E7EB))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        const Expanded(child: Divider(thickness: 1, color: Color(0xFFE5E7EB))),
      ],
    );
  }
}
