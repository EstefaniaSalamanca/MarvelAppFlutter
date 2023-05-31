import 'package:flutter/material.dart';
import 'package:marvelapp/constants/routes.dart';
import 'package:marvelapp/services/auth/auth_service.dart';
import 'package:marvelapp/views/home_view.dart';
import 'package:marvelapp/views/login_view.dart';
import 'package:marvelapp/views/register_view.dart';
import 'package:marvelapp/views/verify_email_view.dart';
import 'package:marvelapp/views/search_view.dart';
import 'package:marvelapp/views/favorites_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        homeRoute: (context) => const HomeView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        searchRoute: (context) => const SearchView(),
        favoritesRoute: (context) => const FavoritesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const HomeView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
