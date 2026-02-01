import 'dart:ui';
import 'package:flutter/material.dart';
import 'sign_in_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const double _cardInnerFixedHeight = 520;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF7FBFA), Color(0xFFF4F7F7), Color(0xFFF9F5F7)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 980;
                final contentMaxWidth = isWide
                    ? 1100.0
                    : (size.width < 560 ? size.width : 560.0);

                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Expanded(child: _LeftSection()),
                            SizedBox(width: 48),
                            _AuthCard(fixedInnerHeight: _cardInnerFixedHeight),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _LeftSection(compact: true),
                            SizedBox(height: 18),
                            _AuthCard(fixedInnerHeight: _cardInnerFixedHeight),
                          ],
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== LEFT SECTION ===================== */

class _LeftSection extends StatelessWidget {
  final bool compact;
  const _LeftSection({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: compact ? 18 : 0),
        Image.asset(
          'assets/assets/logo.png',
          height: compact ? 130 : 170,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 18),
        const Text(
          'Welcome to DHM Portal',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            height: 1.1,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0B8F84),
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: const Text(
            'Access your hospitality management resources, courses, and\n'
            'connect with the ACLC College community.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.5,
              height: 1.6,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/* ===================== AUTH CARD ===================== */

enum _PresencePhase { idle, entering }

class _AuthCard extends StatefulWidget {
  final double fixedInnerHeight;
  const _AuthCard({required this.fixedInnerHeight});

  @override
  State<_AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<_AuthCard>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 360);

  late final AnimationController _ctrl;
  _PresencePhase _phase = _PresencePhase.idle;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _duration);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      setState(() => _phase = _PresencePhase.entering);
      await _ctrl.forward(from: 0);
      if (!mounted) return;
      setState(() => _phase = _PresencePhase.idle);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 980;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 460, minWidth: wide ? 460 : 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF0B8F84), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: SizedBox(
          height: widget.fixedInnerHeight,
          width: double.infinity,
          child: ClipRect(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                final t = Curves.easeInOut.transform(_ctrl.value);
                final opacity = (_phase == _PresencePhase.entering) ? t : 1.0;
                final x = (_phase == _PresencePhase.entering)
                    ? lerpDouble(-20, 0, t)!
                    : 0.0;

                return Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(x, 0),
                    child: const _InnerScroll(child: SignInForm()),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== INNER SCROLL ===================== */

class _InnerScroll extends StatelessWidget {
  final Widget child;
  const _InnerScroll({required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: child,
      ),
    );
  }
}
