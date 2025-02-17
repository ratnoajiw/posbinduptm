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
              leading:
                  const Icon(Icons.article_outlined, color: Colors.black54),
              title: const Text('Blog'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/blog');
              },
            ),
            ListTile(
              leading: const Icon(Icons.monitor_weight_outlined,
                  color: Colors.black54),
              title: const Text('Antropometri'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/antropometri');
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.bloodtype_outlined, color: Colors.black54),
              title: const Text('Gula Darah'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/periksa_gula_darah');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border, color: Colors.black54),
              title: const Text('Tekanan Darah'),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, '/periksa_tekanan_darah');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bubble_chart, color: Colors.black54),
              title: const Text('Kolesterol Total'),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, '/periksa_kolesterol_total');
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
