import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs/jobs_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_page_value_notify.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';



class LandingPage extends StatelessWidget {
  static const id = 'landing_page';

  const LandingPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final authBase = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
        stream: authBase.authStateChanges(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.active) {
            final User? user = snapShot.data;
            if (user == null) {
             // return SignInPage.create(context);
              return SignInValueNotifierPage.create(context);
            }
            return Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: const JobsPage());
          }
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        });
  }
}
