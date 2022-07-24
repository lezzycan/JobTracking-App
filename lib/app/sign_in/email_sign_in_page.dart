import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_bloc_based.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_form_change_notifier.dart';


class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Sign in'),
        centerTitle: true,
        elevation: 5.0,
      ),
      body:  SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Card(
           // child: EmailSignInFormStateful(),
          // child: EmailSignInFormBlocBased.create(context),
            child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
    );
  }
}
