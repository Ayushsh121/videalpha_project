import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'State.dart';
class AuthCubit extends Cubit<AuthState>{
  String? _verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCubit() : super(AuthInitialState());
void sendOtp(String phoneNumber) async {
  emit(AuthLoadindState());
  await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    codeSent:(verificationId , forceResendingToken){
      emit(AuthCodeSentState());
      _verificationId=verificationId;
    },
    verificationCompleted: (PhoneAuthCredential){
      signinWithPhone(PhoneAuthCredential);
    },
    verificationFailed: (error){
      emit(AuthErrorState(error.message.toString()));
    },
    codeAutoRetrievalTimeout: (verificationId){
      _verificationId = verificationId;
    }
    );
}
  void verifyOtp(String otp) async {
    emit(AuthLoadindState());
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!, smsCode: otp);
  signinWithPhone(credential);
  }
  void signinWithPhone(PhoneAuthCredential credential) async {
  try{
    UserCredential userCredential  = await _auth.signInWithCredential(credential);
    if(userCredential.user != null){
      emit(AuthLoggedInState(userCredential.user!));
    }
  }on FirebaseAuthException catch(ex){
    emit(AuthErrorState(ex.message.toString()));
  }
  }
}