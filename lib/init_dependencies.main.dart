part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  _initAntropometri();
  _initGulaDarah();
  _initTekananDarah();
  _initKolesterolTotal();
  _initPasien();

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
    ..registerFactory(
      () => UpdateBlog(
        serviceLocator(),
      ),
    )

    //Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
        deleteBlog: serviceLocator(),
        updateBlog: serviceLocator(),
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

void _initGulaDarah() {
  serviceLocator
    ..registerFactory<GulaDarahRemoteDataSource>(
      () => GulaDarahRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<GulaDarahRepository>(
      () => GulaDarahRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadGulaDarah(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateGulaDarah(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllGulaDarah(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteGulaDarah(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => GulaDarahBloc(
        uploadGulaDarah: serviceLocator(),
        getAllGulaDarah: serviceLocator(),
        updateGulaDarah: serviceLocator(),
        deleteGulaDarah: serviceLocator(),
      ),
    );
}

void _initTekananDarah() {
  serviceLocator
    ..registerFactory<TekananDarahRemoteDataSource>(
      () => TekananDarahRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<TekananDarahRepository>(
      () => TekananDarahRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadTekananDarah(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateTekananDarah(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllTekananDarah(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteTekananDarah(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetLatestTekananDarah(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => TekananDarahBloc(
        uploadTekananDarah: serviceLocator(),
        getAllTekananDarah: serviceLocator(),
        updateTekananDarah: serviceLocator(),
        deleteTekananDarah: serviceLocator(),
      ),
    );
}

void _initKolesterolTotal() {
  serviceLocator
    ..registerFactory<KolesterolTotalRemoteDataSource>(
      () => KolesterolTotalRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<KolesterolTotalRepository>(
      () => KolesterolTotalRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadKolesterolTotal(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateKolesterolTotal(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllKolesterolTotal(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteKolesterolTotal(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => KolesterolTotalBloc(
        uploadKolesterolTotal: serviceLocator(),
        getAllKolesterolTotal: serviceLocator(),
        updateKolesterolTotal: serviceLocator(),
        deleteKolesterolTotal: serviceLocator(),
      ),
    );
}

void _initPasien() {
  serviceLocator
    ..registerFactory<PasienRemoteDataSource>(
      () => PasienRemoteDataSourceImpl(
        serviceLocator(), // SupabaseClient
      ),
    )
    ..registerFactory<PasienRepository>(
      () => PasienRepositoryImpl(
        remoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
        appUserCubit: serviceLocator(), // ConnectionChecker
      ),
    )
    ..registerFactory(
      () => GetPasienByProfileId(
        serviceLocator(), // PasienRepository
      ),
    )
    ..registerFactory(
      () => CreatePasien(
        serviceLocator(), // PasienRepository
      ),
    )
    ..registerFactory(
      () => UpdatePasien(
        serviceLocator(), // PasienRepository
      ),
    )
    ..registerLazySingleton(
      () => PasienBloc(
        getPasienByProfileId: serviceLocator(),
        createPasien: serviceLocator(),
        updatePasien: serviceLocator(),
      ),
    );
}
