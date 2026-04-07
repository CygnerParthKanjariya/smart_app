import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/login/bloc/login_bloc.dart';
import 'package:smart_grocery/features/product/bloc/product_bloc.dart';
import 'package:smart_grocery/features/review/bloc/review_bloc.dart';
import 'package:smart_grocery/features/settings/bloc/settings_bloc.dart';
import 'package:smart_grocery/features/splash/splash_screen.dart';
import 'di/dependency_injection.dart';
import 'features/cart/bloc/cart_bloc.dart';
import 'features/settings/bloc/settings_state.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProductBloc>()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => SettingsBloc()),
        BlocProvider(create: (context) => ReviewBloc()),
        BlocProvider(create: (context) => sl<LoginBloc>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (BuildContext context, state) {
        ThemeData themeData = ThemeData.light();
        if (state is SettingsThemeState) {
          themeData = state.themeData;
        }
        return MaterialApp(
          theme: themeData,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
