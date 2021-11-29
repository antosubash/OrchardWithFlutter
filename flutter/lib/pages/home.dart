import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:orcharddemo/constants.dart';
import 'package:orcharddemo/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HttpLink httpLink = HttpLink(
    Constants.apiUrl,
  );

  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer ',
  );

  var auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Login"),
              onPressed: () async {
                var tokenInfo = await auth.login();
                print(tokenInfo);
              },
            ),
            ElevatedButton(
              child: const Text("Logout"),
              onPressed: () async {
                //auth.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
