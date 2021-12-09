import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:orcharddemo/services/auth.dart';

class Languages extends StatefulWidget {
  const Languages({Key? key}) : super(key: key);

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  var auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var languagesQuery = gql("""
    query languages {
      language {
        code
        displayText
      }
    }
  """);
    return Query(
      options: QueryOptions(document: languagesQuery),
      builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          auth.resetTokens();
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        }
        if (result.isLoading) {
          return const Text('Loading');
        }

        return ListView.builder(
          itemCount: result.data?['language'].length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(result.data?['language'][index]['displayText']),
            );
          },
        );
      },
    );
  }
}
