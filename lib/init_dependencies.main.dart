part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  _initAntropometri();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonkey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  //database remote supabase
  serviceLocator.registerLazySingleton(() => supabase.client);
  // //database lokal hive
  // serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  //datasource remote supabase
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    //repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogIn(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(serviceLocator()),
    )
    ..registerFactory(
      // Register the UserLogOut use case
      () => UserLogOut(serviceLocator()),
    )
    //bloc
    ..registerLazySingleton(
      () => AuthBloc(
        appUserCubit: serviceLocator(),
        currentUser: serviceLocator(),
        userSignUp: serviceLocator(),
        userLogIn: serviceLocator(),
        userLogOut: serviceLocator(),
      ),
    );
}

void _initBlog() {
  //Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    //datasource lokal hive
    // ..registerFactory<BlogLocalDataSource>(
    //   () => BlogLocalDataSourceImpl(
    //     serviceLocator(),
    //   ),
    // )
    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        // serviceLocator(),
      ),
    )
    //Usecase
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteBlog(
        serviceLocator(),
      ),
    )

    //Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
        deleteBlog: serviceLocator(),
      ),
    );
}

void _initAntropometri() {
  // Data Source
  serviceLocator
    ..registerFactory<AntropometriRemoteDataSource>(
      () => AntropometriRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )

    // Repository
    ..registerFactory<AntropometriRepository>(
      () => AntropometriRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )

    // UseCases
    ..registerFactory(
      () => UploadAntropometri(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllAntropometri(
        serviceLocator(),
        posterId: '',
      ),
    )
    ..registerFactory(
      () => DeleteAntropometri(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateAntropometri(
        serviceLocator(),
      ),
    )

    // Bloc
    ..registerLazySingleton(
      () => AntropometriBloc(
        uploadAntropometri: serviceLocator(),
        getAllAntropometri: serviceLocator(),
        deleteAntropometri: serviceLocator(),
        updateAntropometri: serviceLocator(),
      ),
    );
}
