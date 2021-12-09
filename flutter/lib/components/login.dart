import 'package:flutter/material.dart';
import 'package:orcharddemo/services/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Login'),
        ElevatedButton(
          child: const Text('Login'),
          onPressed: () async {
            await auth.login();
            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
          },
        ),
      ],
    );
  }
}
