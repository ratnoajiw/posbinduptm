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

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =
      TextEditingController(); // Tambahan konfirmasi password
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              context.read<AppUserCubit>().updateUser(state.user);
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return Center(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      AuthField(
                        controller: nameController,
                        labelText: 'Nama',
                        hintText: 'Ketik nama Anda di sini',
                      ),
                      const SizedBox(height: 15),
                      AuthField(
                        controller: emailController,
                        labelText: 'Email',
                        hintText: 'Ketik email Anda di sini',
                      ),
                      const SizedBox(height: 15),
                      AuthField(
                        controller: passwordController,
                        labelText: 'Password',
                        hintText: 'Ketik password Anda di sini',
                        isObsecureText: true,
                      ),
                      const SizedBox(height: 15),
                      AuthField(
                        controller: confirmPasswordController,
                        labelText: 'Konfirmasi Password',
                        hintText: 'Ketik ulang password Anda',
                        isObsecureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Konfirmasi password harus diisi";
                          }
                          if (value != passwordController.text) {
                            return "Password tidak cocok";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      AuthGradientButton(
                        buttonText: 'Daftar',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
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
                      const SizedBox(height: 20),
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
