import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/avatar.dart';

import '../../../common_widgets/platform_alert_dialog.dart';
import '../../../services/auth.dart';

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

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen:false);
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: _buildUserProfile( auth.user)),
      ),


    );
  }

 Widget  _buildUserProfile(  User? user) {
  return Column(
    children: [
      Avatar(
        photoUrl: user?.photoURL, 
        radius: 50,color: Colors.black54,),
       const SizedBox(height: 8.0,),
        if(user?.displayName !=null)
        Text(user!.displayName!,style: const TextStyle(color: Colors.white),),
        const SizedBox(
          height: 8.0,
        ),
    ],
  );
 }


}