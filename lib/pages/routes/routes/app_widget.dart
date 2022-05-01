import 'package:flutter/material.dart';
import 'package:lista_de_tarefa_app/pages/home.dart';
import 'package:lista_de_tarefa_app/pages/login.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
