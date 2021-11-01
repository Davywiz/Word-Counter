import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:splash_screen_view/TyperAnimatedText.dart';

import './screens/main_screen.dart';
import './models/app_provider.dart';
import 'models/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: LaunchThemes.light(),
      dark: LaunchThemes.dark(),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => ChangeNotifierProvider(
        create: (ctx) => AppProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Word Counter',
          theme: theme,
          darkTheme: darkTheme,
          home: SplashScreenView(
            navigateRoute: const MainScreen(),
            duration: 3000,
            imageSize: 130,
            imageSrc: "images/TextSpeech.png",
            text: "Word Counter",
            textType: TextType.ScaleAnimatedText,
            textStyle: const TextStyle(fontSize: 30.0, color: Colors.cyan),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
