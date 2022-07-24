import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs/jobs_page.dart';
import 'package:time_tracker/app/landing_page.dart';
import 'package:time_tracker/services/auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
        //  final bloc = Provider.of<SignInBloc>(context, listen: false);
          return Provider<AuthBase>(
            create: (context) => Auth(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.brown,
              ),
              initialRoute: LandingPage.id,
              routes: {
                // SignInPage.id: (context) => SignInPage(
                //       bloc: bloc,
                //     ),
                LandingPage.id: (context) => const LandingPage(),
                JobsPage.id: (context) => const JobsPage()
              },
            ),
          );
        });
  }
}
