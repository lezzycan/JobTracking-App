import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/platform_alert_dialog.dart';
import '../../../common_widgets/platform_exception_alert_dialog.dart';
import '../../../services/auth.dart';
import '../../../services/database.dart';
import '../job_entries/job_entries_page.dart';
import '../jobs/job_list_tile.dart';
import '../jobs/list_items_builder.dart';
import '../models/jobs.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);
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

  Future<void> _deleteContent(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation Failed', exception: e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
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