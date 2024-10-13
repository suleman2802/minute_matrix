import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import '../general/single_item.dart';

class DarkThemeToggleWidget extends StatefulWidget {
  static late bool isDarkMode;

  @override
  State<DarkThemeToggleWidget> createState() => _DarkThemeToggleWidgetState();
}

class _DarkThemeToggleWidgetState extends State<DarkThemeToggleWidget> {
  
  void _toggleTheme(bool enableDark) {
  
    if (enableDark) {
      setState(() {
        AdaptiveTheme.of(context).setDark();
        DarkThemeToggleWidget.isDarkMode = true;
      });
    } else {
      setState(() {
        AdaptiveTheme.of(context).setLight();
        DarkThemeToggleWidget.isDarkMode = false;
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    //bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleItem(DarkThemeToggleWidget.isDarkMode? Icons.dark_mode_outlined : Icons.dark_mode_rounded, "Dark Mode"),
        Switch.adaptive(
          value: DarkThemeToggleWidget.isDarkMode,
          onChanged: (_) {
          
            DarkThemeToggleWidget.isDarkMode
                ? _toggleTheme(false)
                : _toggleTheme(true);
          },
        ),
      ],
    );
  }
}
