import 'package:get_it/get_it.dart';
import 'package:smart_grocery/features/login/bloc/login_bloc.dart';
import 'package:smart_grocery/features/product/bloc/product_bloc.dart';
import '../core/api_helper/api_helper.dart';
import '../features/login/auth/auth_repository.dart';
import '../features/product/repository/product_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // LoginBloc injections
  sl.registerLazySingleton(() => LoginBloc(sl()));

  sl.registerLazySingleton(() => AuthRepository());

  // ProductBloc injections
  sl.registerLazySingleton(() => ProductBloc(productRepository: sl()));

  sl.registerLazySingleton(() => ProductRepository(sl()));

  sl.registerLazySingleton(() => ApiHelper());
}
