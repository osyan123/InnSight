import 'package:flutter/material.dart';

import '../services/role_router.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/manager/floor_plan_editor_screen.dart';
import '../screens/frontdesk/frontdesk_dashboard.dart';

class AppRoutes {
  static const gate = '/gate';
  static const login = '/login';
  static const managerFloorplan = '/manager-floorplan';
  static const frontDesk = '/frontdesk';

  static Map<String, WidgetBuilder> routes = {
    gate: (_) => const AuthGate(),
    login: (_) => const AuthScreen(),
    managerFloorplan: (_) => const FloorPlanEditorScreen(),

    frontDesk: (_) => const FrontDeskDashboard(),
  };
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await RoleRouter.routeOnAppStart(
        context,
        managerRoute: AppRoutes.managerFloorplan,
        frontDeskRoute: AppRoutes.frontDesk,
        loginRoute: AppRoutes.login,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 46,
          height: 46,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
