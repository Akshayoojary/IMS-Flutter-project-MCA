import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLoggedIn;
  final VoidCallback? onLogout;
  final List<Widget>? actions;

  const TopAppBar({
    Key? key,
    required this.title,
    required this.isLoggedIn,
    this.onLogout,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: _buildActions(context),
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (isLoggedIn) {
      return [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            if (onLogout != null) {
              onLogout!();
            }
          },
        ),
        ...(actions ?? []),
      ];
    } else {
      return actions;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
