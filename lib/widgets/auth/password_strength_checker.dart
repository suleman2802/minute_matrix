import 'package:flutter/material.dart';

class PasswordStrengthChecker extends StatefulWidget {
  const PasswordStrengthChecker({
    super.key,
    required this.password,
    required this.onStrengthChanged,
  });

  /// Password value: obtained from a text field
  final String password;

  /// Callback that will be called when password strength changes
  final Function(bool isStrong) onStrengthChanged;

  @override
  State<PasswordStrengthChecker> createState() =>
      _PasswordStrengthCheckerState();
}

class _PasswordStrengthCheckerState extends State<PasswordStrengthChecker> {
  final Map<RegExp, String> _validators = {
    RegExp(r'[A-Z]'): 'One uppercase letter',
    RegExp(r'[a-z]'): 'One lowercase letter',
    RegExp(r'[!@#\\$%^&*(),.?":{}|<>]'): 'One special character',
    RegExp("(?=.*[0-9])"): 'One number',
    RegExp(r'^.{8,16}$'): '8-16 characters length',
    //RegExp('(.{8,10})'): '8-20 characters',
  };
  @override
  void didUpdateWidget(covariant PasswordStrengthChecker oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Check if the password has changed
    if (widget.password != oldWidget.password) {
      /// If changed, re-validate the password strength
      final isStrong = _validators.entries.every(
        (entry) => entry.key.hasMatch(widget.password),
      );

      /// Call callback with new value to notify parent widget
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onStrengthChanged(isStrong),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// If the password is empty yet, we'll show validation messages in plain
    /// color, not green or red
    final hasValue = widget.password.isNotEmpty;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(3, 2, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _validators.entries.map(
            (entry) {
              /// Check if the password matches the current validator requirement
              final hasMatch = entry.key.hasMatch(widget.password);
              /// Based on the match, we'll show the validation message in green or red color
              final color = hasValue
                  ? (hasMatch ? Colors.green : Colors.red)
                  : Theme.of(context).primaryColor;

              return Text(
                "\u{2713}" + entry.value,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
