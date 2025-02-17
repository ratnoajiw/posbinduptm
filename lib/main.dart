import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/theme/theme.dart';
import 'package:posbinduptm/features/periksa_antropometri/presentation/bloc/antropometri_bloc.dart';
import 'package:posbinduptm/features/periksa_antropometri/presentation/pages/antropometri_page.dart';
import 'package:posbinduptm/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:posbinduptm/features/auth/presentation/pages/login_page.dart';
import 'package:posbinduptm/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:posbinduptm/features/blog/presentation/pages/blog_page.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/bloc/gula_darah_bloc.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/pages/gula_darah_page.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/bloc/tekanan_darah_bloc.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/pages/tekanan_darah_page.dart';
import 'package:posbinduptm/init_dependencies.dart';

/// Fungsi utama aplikasi
void main() async {
  // Pastikan binding widget telah diinisialisasi
  // sebelum memanggil kode async
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi dependency injection
  // (untuk service locator seperti get_it)
  await initDependencies();

  // Menjalankan aplikasi dengan MultiBlocProvider
  // untuk mengelola state management menggunakan Bloc
  runApp(MultiBlocProvider(
    providers: [
      // Mengelola data user yang login
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
      // Mengelola proses autentikasi
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      // Mengelola data blog
      BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
      //mengelola data antropometri
      BlocProvider(create: (_) => serviceLocator<AntropometriBloc>()),
      //mengelola data gula darah
      BlocProvider(create: (_) => serviceLocator<GulaDarahBloc>()),
      //mengelola data tekanan darah
      BlocProvider(create: (_) => serviceLocator<TekananDarahBloc>()),
    ],
    child: const MainApp(),
    // Menjalankan widget utama aplikasi
  ));
}

/// Widget utama aplikasi
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // Mengecek apakah user sudah login
    // saat aplikasi pertama kali dijalankan
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        ///memastikan user login saat aplikasi dijalankan
        ///jika user tidak login, maka arahkan ke halaman login
        // BlocListener untuk mendengarkan perubahan state AuthBloc
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              // Mencegah navigasi sebelum frame dirender
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Jika halaman ini masih menjadi halaman utama,
                // navigasikan ke halaman login
                if (ModalRoute.of(context)?.isCurrent == true) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login', // Pindah ke halaman login
                    (route) => false, // Hapus semua halaman sebelumnya
                  );
                }
              });
            }
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Posbindu PTM',
        theme: AppTheme.lightThemeMode, // Menggunakan tema dari AppTheme
        home: BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, state) {
            if (state is AppUserLoggedIn) {
              return const BlogPage(); // Langsung ke HomePage
            } else {
              return const LoginPage();
            }
          },
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/blog': (context) => const BlogPage(),
          '/antropometri': (context) => const AntropometriPage(),
          '/periksa_gula_darah': (context) => const GulaDarahPage(),
          '/periksa_tekanan_darah': (context) => const TekananDarahPage(),
        },
      ),
    );
  }
}
