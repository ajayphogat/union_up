import 'package:flutter/material.dart';

import 'connectivity_checker.dart';



class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Image.asset(Assets.delete),
                // ),
                const SizedBox(height: 80),
                InkWell(
                  onTap: (){
                    initNoInternetListener(context);
                  },
                  child: const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No internet connection found. Check your \n connection or try again!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}