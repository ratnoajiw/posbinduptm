import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:posbinduptm/features/auth/presentation/pages/login_page.dart';
import 'package:posbinduptm/features/auth/presentation/widgets/auth_field.dart';
import 'package:posbinduptm/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:posbinduptm/features/blog/presentation/pages/blog_page.dart';

// Widget SignUpPage untuk pendaftaran pengguna baru
class SignUpPage extends StatefulWidget {
  // Fungsi route untuk navigasi ke SignUpPage
  static route() => MaterialPageRoute(
        builder: (contex) => const SignUpPage(),
      );
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controller untuk input email
  final emailController = TextEditingController();
  // Controller untuk input password
  final passwordController = TextEditingController();
  // Controller untuk input nama
  final nameController = TextEditingController();
  // Key untuk form validasi
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Membuang controller untuk menghindari memory leak
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        // BlocConsumer untuk menangani state dari AuthBloc
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            // Menampilkan snackbar jika terjadi error
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              // Navigasi ke BlogPage jika pendaftaran berhasil
              context.read<AppUserCubit>().updateUser(state.user);
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            // Menampilkan loader jika sedang loading
            if (state is AuthLoading) {
              return const Loader();
            }
            // Menampilkan form pendaftaran
            return Center(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Menampilkan nama aplikasi dengan warna gradient
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
                      const SizedBox(
                        height: 30,
                      ),
                      // Input nama
                      AuthField(
                        controller: nameController,
                        labelText: 'Nama',
                        hintText: 'ketik nama Anda di sini',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Input email
                      AuthField(
                        controller: emailController,
                        labelText: 'Email',
                        hintText: 'ketik email Anda di sini',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Input password
                      AuthField(
                        controller: passwordController,
                        labelText: 'Password',
                        hintText: 'ketik password Anda di sini',
                        isObsecureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Tombol daftar
                      AuthGradientButton(
                        buttonText: 'Daftar',
                        onPressed: () {
                          // Validasi form sebelum submit
                          if (formKey.currentState!.validate()) {
                            // Menambahkan event AuthSignUp ke AuthBloc
                            context.read<AuthBloc>().add(
                                  AuthSignUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    name: nameController.text.trim(),
                                  ),
                                );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Link untuk navigasi ke LoginPage
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            LoginPage.route(),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Sudah punya akun? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: 'Masuk',
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
