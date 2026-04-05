import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vinho/theme/ov_theme.dart';

class OVDialog extends StatelessWidget {
  OVDialog( {required this.isFullscreen,super.key, required this.content});
  final Widget content;
  final ScrollController _scrollController = ScrollController();
  bool isFullscreen = false;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: OVTheme.backgroundColor,
        surfaceTintColor: OVTheme.backgroundColor,
        insetPadding: EdgeInsets.zero,
        title: Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: const Icon(
              Icons.cancel_outlined,
              color: OVTheme.primaryRed,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height:
                MediaQuery.of(context).size.height * (isFullscreen ? 1 : 0.8),
            child: Column(
              children: [
                Expanded(
                  child: RawScrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    //  radius: Radius.circular(8),
                    thumbColor: OVTheme.primaryRed,
                    thickness: 3,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: content,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
