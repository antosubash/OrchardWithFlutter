import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openid_client/openid_client.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../constants.dart';

class AuthService {
  String clientId = Constants.clientId; // = 'client1';
  late String issuer = Constants.apiUrl; // = 'https://5e0f-84-113-156-160.ngrok.io';
  late FlutterSecureStorage storage;
  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access',
  ];

  AuthService() {
    storage = const FlutterSecureStorage();
  }

  Future<String?> login() async {
    var tokenInfo = await authenticate(Uri.parse(issuer), clientId, _scopes);
    return tokenInfo.accessToken;
  }

  Future<void> resetTokens() async {
    await storage.write(key: Constants.accessToken, value: null);
    await storage.write(key: Constants.refreshToken, value: null);
    await storage.write(key: Constants.accessTokenExpiration, value: null);
  }

  Future updateTokens(
      String accessToken, String refreshToken, String expiration) async {
    await storage.write(key: Constants.accessToken, value: accessToken);
    await storage.write(key: Constants.refreshToken, value: refreshToken);
    await storage.write(
        key: Constants.accessTokenExpiration, value: expiration);
  }

  Future<TokenResponse> authenticate(
      Uri uri, String clientId, List<String> scopes) async {
    // create the client
    var issuer = await Issuer.discover(uri);
    var client = Client(issuer, clientId);

    // create a function to open a browser with an url
    urlLauncher(String url) async {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true, enableJavaScript: true);
      } else {
        throw 'Could not launch $url';
      }
    }

    // create an authenticator
    var authenticator = Authenticator(
      client,
      scopes: scopes,
      urlLancher: urlLauncher,
      port: 3000,
    );

    // starts the authentication
    var c = await authenticator.authorize();
    // close the webview when finished
    closeWebView();

    var res = await c.getTokenResponse();
    return res;
  }

  Future<void> logout(String logoutUrl) async {
    if (await canLaunch(logoutUrl)) {
      await launch(logoutUrl, forceWebView: true);
    } else {
      throw 'Could not launch $logoutUrl';
    }
    await Future.delayed(const Duration(seconds: 2));
    closeWebView();
  }
}
