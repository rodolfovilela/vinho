import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vinho/theme/ov_theme.dart';

class OVDialog extends StatelessWidget {
  const OVDialog({super.key, required this.content});
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.transparent,
        surfaceTintColor: OVTheme.backgroundColor,
        insetPadding: EdgeInsets.zero,
        title: Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: const Icon(
              Icons.cancel_outlined,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [content],
            )),
      ),
    );
  }
}
