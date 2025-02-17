import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:posbinduptm/features/auth/presentation/pages/signup_page.dart';
import 'package:posbinduptm/features/auth/presentation/widgets/auth_field.dart';
import 'package:posbinduptm/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:posbinduptm/features/blog/presentation/pages/blog_page.dart';

/// Halaman Login untuk pengguna
class LoginPage extends StatefulWidget {
  /// Fungsi statis untuk membuat route halaman login
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Controller untuk input email
  final emailController = TextEditingController();

  /// Controller untuk input password
  final passwordController = TextEditingController();

  /// Kunci untuk validasi form
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    /// Membersihkan controller saat widget dihapus dari tree
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masuk'),
        centerTitle: true,
        leading:
            const SizedBox(), // Menghilangkan ikon kembali dengan widget kosong
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          /// Listener menangani perubahan state terkait autentikasi
          listener: (context, state) {
            if (state is AuthFailure) {
              /// Menampilkan pesan error jika login gagal
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              /// Jika login berhasil, navigasi ke halaman Blog dan menghapus semua halaman sebelumnya
              context.read<AppUserCubit>().updateUser(state.user);
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },

          /// Builder menangani tampilan berdasarkan state autentikasi
          builder: (context, state) {
            if (state is AuthLoading) {
              /// Menampilkan loader saat proses login sedang berjalan
              return const Loader();
            }
            return Center(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Menampilkan nama aplikasi dengan warna gradient
                      RichText(
                        text: TextSpan(
                          text: 'Posbindu ',
                          style: Theme.of(context).textTheme.displayMedium,
                          children: [
                            TextSpan(
                              text: 'PTM',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color: AppPallete.gradientGreen2,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Input field untuk email
                      AuthField(
                        controller: emailController,
                        labelText: 'Email',
                        hintText: 'ketik email Anda di sini',
                      ),
                      const SizedBox(height: 15),

                      /// Input field untuk password
                      AuthField(
                        controller: passwordController,
                        labelText: 'Password',
                        hintText: 'ketik password Anda di sini',
                        isObsecureText: true,
                      ),
                      const SizedBox(height: 20),

                      /// Tombol login
                      AuthGradientButton(
                        buttonText: 'Masuk',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            /// Memanggil event login menggunakan Bloc
                            context.read<AuthBloc>().add(
                                  AuthLogIn(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      /// Navigasi ke halaman signup jika belum punya akun
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            SignUpPage.route(),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Belum punya akun? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: 'Daftar',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppPallete.gradientGreen2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
