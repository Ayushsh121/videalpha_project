import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Cubit/State.dart';
import '../Cubit/auth_cubit.dart';
import 'User Profile.dart';
class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}
class _OtpScreenState extends State<OtpScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(

          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 80,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Login/Register",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Otp",border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 24,right: 50,left: 50),
                  width: MediaQuery.of(context).size.width,
                  child: BlocConsumer<AuthCubit , AuthState>(
                              listener: (context , state){
                                if(state is AuthLoggedInState){
                                  Navigator.popUntil(context, (route) =>
                                  route.isFirst);
                                  Navigator.pushReplacement(context,
                                      CupertinoPageRoute(builder: (context)=>
                                          User_Profile()));
                                }
                                else if(state is AuthErrorState){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.error),
                                      backgroundColor: Colors.red,
                                      duration: Duration(milliseconds: 2000),
                                    ),
                                  );
                                }
                              },
                              builder: (context , state) {
                                if(state is AuthLoadindState){
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor:
                                  Colors.orange),
                                  onPressed: () {
                                    BlocProvider.of<AuthCubit>(context)
                                        .verifyOtp(otpController.text);
                                  },
                                  child: Text("LOGIN",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),),
                                );
                              }
                          ),
                          )],
                      ),
                           )));
  }
}
