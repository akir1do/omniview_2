import 'package:flutter/material.dart';

// ThemeNotifier for theme switching
typedef ThemeToggle = void Function();

class ThemeNotifier extends ValueNotifier<bool> {
  ThemeNotifier(bool value) : super(value);
  void toggle() => value = !value;
}

final themeNotifier = ThemeNotifier(false);

class Frontend extends StatelessWidget {
  const Frontend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: isDark ? Brightness.dark : Brightness.light,
            primarySwatch: Colors.deepPurple,
          ),
          home: Scaffold(
            body: Center(
              child: Text(
                'Welcome to OmniView+',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(const Frontend());
}
