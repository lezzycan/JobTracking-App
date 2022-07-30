import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';

import '../services/auth.dart';
class HomePage extends StatelessWidget {
  static const id = 'home_page';

  const HomePage({Key? key}) : super(key: key);

  Future<void> _signOut(context) async {
    try {
      final authbase = Provider.of<AuthBase>(context, listen: false);
      await authbase.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> confirmSignOut(BuildContext context) async {
    final didSignOutRequest = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure that you want to logout?',
        defaultActionText: 'Logout',
        cancelActionText: 'Cancel');
    if (didSignOutRequest == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.green[900],
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () => confirmSignOut(context),

              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
    );
  }
}
