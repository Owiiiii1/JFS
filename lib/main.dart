import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'intro_video_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService('http://178.156.234.23');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: IntroVideoPage(auth: auth),
    );
  }
}
