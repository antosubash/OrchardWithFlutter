import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:orcharddemo/constants.dart';
import 'package:orcharddemo/pages/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  await initHiveForFlutter();
  runApp(const MyApp());
}

const storage = FlutterSecureStorage();
const graphqlEndpoint = '${Constants.apiUrl}/api/graphql';

final HttpLink httpLink = HttpLink(graphqlEndpoint);
final AuthLink authLink = AuthLink(
  getToken: () async =>
      'Bearer ${await storage.read(key: Constants.accessToken)}',
);
final Link link = authLink.concat(httpLink);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    link: link,
    // The default store is the InMemoryStore, which does NOT persist to disk
    cache: GraphQLCache(store: HiveStore()),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
