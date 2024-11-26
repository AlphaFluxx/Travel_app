import 'package:flutter/material.dart';

class Topbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Admin Dashboard'),
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            // Tambahkan aksi logout
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
