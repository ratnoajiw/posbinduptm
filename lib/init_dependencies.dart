import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/network/connection_checker.dart';
import 'package:posbinduptm/core/secrets/app_secrets.dart';
import 'package:posbinduptm/features/antropometri/data/datasources/antropometri_remote_data_source.dart';
import 'package:posbinduptm/features/antropometri/data/repositories/antropometri_repository_impl.dart';
import 'package:posbinduptm/features/antropometri/domain/repositories/antropometri_repository.dart';
import 'package:posbinduptm/features/antropometri/domain/usecases/delete_antropometri.dart';
import 'package:posbinduptm/features/antropometri/domain/usecases/get_all_antropometri.dart';
import 'package:posbinduptm/features/antropometri/domain/usecases/update_antropometri.dart';
import 'package:posbinduptm/features/antropometri/domain/usecases/upload_antropometri.dart';
import 'package:posbinduptm/features/antropometri/presentation/bloc/antropometri_bloc.dart';
import 'package:posbinduptm/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:posbinduptm/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:posbinduptm/features/auth/domain/repositories/auth_repository.dart';
import 'package:posbinduptm/features/auth/domain/usecases/current_user.dart';
import 'package:posbinduptm/features/auth/domain/usecases/user_log_in.dart';
import 'package:posbinduptm/features/auth/domain/usecases/user_log_out.dart';
import 'package:posbinduptm/features/auth/domain/usecases/user_sign_up.dart';
import 'package:posbinduptm/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:posbinduptm/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:posbinduptm/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:posbinduptm/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:posbinduptm/features/blog/domain/repositories/blog_repository.dart';
import 'package:posbinduptm/features/blog/domain/usecases/delete_blog.dart';
import 'package:posbinduptm/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:posbinduptm/features/blog/domain/usecases/update_blog.dart';
import 'package:posbinduptm/features/blog/domain/usecases/upload_blog.dart';
import 'package:posbinduptm/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:posbinduptm/features/pasien/data/datasources/pasien_remote_data_source.dart';
import 'package:posbinduptm/features/pasien/data/repositories/pasien_repository_impl.dart';
import 'package:posbinduptm/features/pasien/domain/repositories/pasien_repository.dart';
import 'package:posbinduptm/features/pasien/domain/usecases/create_pasien.dart';
import 'package:posbinduptm/features/pasien/domain/usecases/get_pasien_by_profile_id.dart';
import 'package:posbinduptm/features/pasien/domain/usecases/update_pasien.dart';
import 'package:posbinduptm/features/pasien/presentation/bloc/pasien_bloc.dart';
import 'package:posbinduptm/features/periksa_gula_darah/data/datasource/gula_darah_remote_data_source.dart';
import 'package:posbinduptm/features/periksa_gula_darah/data/repository/gula_darah_repository_impl.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/repository/gula_darah_repository.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/delete_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/get_all_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/update_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/domain/usecases/upload_gula_darah.dart';
import 'package:posbinduptm/features/periksa_gula_darah/presentation/bloc/gula_darah_bloc.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/data/datasources/kolesterol_total_remote_data_source.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/data/repositories/kolesterol_total_repository_impl.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/repositories/kolesterol_total_repository.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/usecases/delete_kolesterol_total.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/usecases/get_all_kolesterol_total.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/usecases/update_kolesterol_total.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/usecases/upload_kolesterol_total.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/presentation/bloc/kolesterol_total_bloc.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/data/datasources/tekanan_darah_remote_data_source.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/data/repositories/tekanan_darah_repository_impl.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/repositories/tekanan_darah_repository.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/usecases/delete_tekanan_darah.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/usecases/get_all_tekanan_darah.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/usecases/get_latest_tekanan_darah.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/usecases/update_tekanan_darah.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/usecases/upload_tekanan_darah.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/presentation/bloc/tekanan_darah_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies.main.dart';
