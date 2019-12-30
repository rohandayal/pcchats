import 'package:flutter/material.dart';
import 'package:pcchatz/screens/home_screen.dart';
import 'package:pcchatz/screens/signup_page.dart';
import 'package:pcchatz/screens/splash_page.dart';
import 'package:pcchatz/screens/login_page.dart';
import 'package:theme_provider/theme_provider.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      themes: [
        AppTheme(
          id: 'default',
          description: "Default theme",
          data: ThemeData(
            primaryColor: Colors.red,
            accentColor: Colors.amber[50],
          ),
        ),
        AppTheme.dark(),
        AppTheme.light(),
      ],
      child: MaterialApp(
        title: 'PC Chats',
        debugShowCheckedModeBanner: true,
        home: ThemeConsumer(child: SplashPage()),
        routes: <String, WidgetBuilder> {
          '/home': (BuildContext context) => ThemeConsumer(child: HomeScreen()),
          '/login': (BuildContext context) => ThemeConsumer(child: LoginPage()),
          '/register': (BuildContext context) => ThemeConsumer(child: SignupPage()),
        }
      ),
    );
  }
}