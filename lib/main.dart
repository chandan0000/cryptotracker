import 'package:cryptotracker/constants/Themes.dart';
import 'package:cryptotracker/models/local_storage.dart';
import 'package:cryptotracker/pages/homePage.dart';
import 'package:cryptotracker/constants/Themes.dart';
import 'package:cryptotracker/providers/market_provider.dart';
import 'package:cryptotracker/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String currentTheme = await LocalStorage.getTheme() ?? "light";

  runApp(MyApp(
    theme: currentTheme,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.theme}) : super(key: key);
  final String theme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MarketProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(theme))
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: HomePage(),
          );
        },
      ),
    );
  }
}
