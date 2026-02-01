import 'package:flutter/material.dart';
import '../services/role_service.dart';

class RoleGate extends StatelessWidget {
  const RoleGate({
    super.key,
    required this.allowed,
    required this.child,
    required this.redirectRoute,
  });

  final Set<UserRole> allowed;
  final Widget child;
  final String redirectRoute;

  @override
  Widget build(BuildContext context) {
    final roleService = RoleService();

    return FutureBuilder<UserRole>(
      future: roleService.getCurrentRole(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final role = snap.data ?? UserRole.unknown;

        if (!allowed.contains(role)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              redirectRoute,
              (_) => false,
            );
          });
          return const Scaffold(body: SizedBox.shrink());
        }

        return child;
      },
    );
  }
}
