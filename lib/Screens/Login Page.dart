import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Cubit/State.dart';
import '../Cubit/auth_cubit.dart';
import 'Otp Screen.dart';
class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  void validate(){
    if(formkey.currentState!.validate()) {
      print("ok");
    } else{
      print("Error");
    }
  }
  bool shouldCheck = false;
  bool shouldCheckDefault = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 80, 10, 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all
                    (Radius.circular(50)),color: Colors.white),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 0, top: 20),
                              child: Text("Login to account",style: TextStyle(fontWeight: FontWeight.bold
                                  ,fontSize: 30,color: Colors.red),),
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(autofocus: false,

                              validator: MultiValidator([
                                RequiredValidator(errorText: "Required"),
                                MinLengthValidator(6, errorText: "More than 6 chars")
                              ]),
                              initialValue: "Ayush Sharma",
                              showCursor: false,
                              decoration: InputDecoration(labelText: "NAME",labelStyle:
                              TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                                  suffixIcon:Icon(Icons.person,color: Colors.red,size:30,)),
                            )
                        ),
                        SizedBox(height: 10,),
                        Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              validator: MultiValidator([
                                RequiredValidator(errorText: "Required"),
                                MinLengthValidator(6, errorText: "More than 6 chars")
                              ]),
                              initialValue: "aayusharma.121@gmail.com",
                              showCursor: false,
                              decoration: InputDecoration(labelText: "EMAIL",labelStyle:
                              TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                                  suffixIcon:Icon(Icons.email,color: Colors.red,size:30,)),
                            )
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: const EdgeInsets.only(),
                              child: Text("contact no.",style: TextStyle(fontSize: 20,
                                  fontWeight:FontWeight.bold ),)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IntlPhoneField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',labelStyle: TextStyle(),
                              suffixIcon: Icon(Icons.call,color: Colors.red,),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
                          ),
                        ),
                        BlocConsumer<AuthCubit , AuthState>(
                            listener: (context , state){
                              if(state is AuthCodeSentState){
                                Get.to(OtpScreen());
                              }
                            },
                            builder: (context , state){
                              if(state is AuthLoadindState){
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor:
                                  Colors.orange),
                                  onPressed: (){
                                    String phoneNumber = '+91${phoneController.text.trim()}';
                                    BlocProvider.of<AuthCubit>(context).sendOtp(phoneNumber);
                                  },
                                  child: Text("Submit",style: TextStyle(fontSize: 25),)
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
