import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/custom_logout_dialog.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/features/auth/presentation/bloc/auth_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CustomLogoutDialog(
        onConfirm: () {
          context.read<AuthBloc>().add(AuthLogOut()); // Proses logout
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      },
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **HEADER DRAWER**
            BlocBuilder<AppUserCubit, AppUserState>(
              builder: (context, state) {
                if (state is AppUserLoggedIn) {
                  return _buildUserDrawer(state.user.email);
                }
                return _buildUserDrawer("Pengguna");
              },
            ),

            // **MENU ITEMS**
            ListTile(
              leading: const Icon(Icons.article, color: Colors.black54),
              title: const Text('Blog'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/blog');
              },
            ),
            ListTile(
              leading: const Icon(Icons.monitor_weight, color: Colors.black54),
              title: const Text('Antropometri'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/antropometri');
              },
            ),
            const Divider(),

            // **LOGOUT BUTTON**
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black54),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black54),
              ),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildUserDrawer(String userName) {
  return UserAccountsDrawerHeader(
    decoration: const BoxDecoration(
      color: AppPallete.gradientGreen1,
    ),
    accountName: Text(
      "Halo, $userName! ",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    accountEmail: null,
    currentAccountPicture: CircleAvatar(
      backgroundColor: Colors.white,
      child: Text(
        userName.isNotEmpty ? userName[0].toUpperCase() : "?",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppPallete.gradientGreen1,
        ),
      ),
    ),
  );
}
