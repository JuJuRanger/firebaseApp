import 'dart:convert';

import 'package:firebaseApp/widget/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class FirebaseAuthService {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();
  static FacebookLogin _facebookSignIn = FacebookLogin();
  static Stream<User> firebaseListener = _firebaseAuth.authStateChanges();

  /* =============================================== */
  // สร้างฟังก์ชันสำหรับเข้าระบบด้วย Google Gmail
  /* =============================================== */
  Future signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential _credential = GoogleAuthProvider.credential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );

    _firebaseAuth
        .signInWithCredential(_credential)
        .then((UserCredential result) {
      Navigator.of(context).pushReplacementNamed('/home');
    }).catchError((e) {
      // return "error";
      BottomSheetWidget()
          .bottomSheet(context, "มีข้อผิดพลาด", "ข้อมูลการ Sign In ไม่ถูกต้อง");
    });
  }

  /* =============================================== */
  // สร้างฟังชั่นสำหรับการสมัครสมาชิกด้วยเบอร์โทรและยืนยัน SMS OTP
  /* =============================================== */
  Future createUserWithPhone(String phone, BuildContext context) async {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 0),
        verificationCompleted: (AuthCredential authCredential) {
          _firebaseAuth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {
            Navigator.of(context).pop(); // to pop the dialog box
            Navigator.of(context).pushReplacementNamed('/home');
          }).catchError((e) {
            print("Error complete");
            return "error";
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          return "error";
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          final _codeController = TextEditingController();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text("ป้อนรหัส OTP ที่ได้รับ"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("ยืนยัน"),
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () {
                    var _credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: _codeController.text.trim());
                    _firebaseAuth
                        .signInWithCredential(_credential)
                        .then((UserCredential result) {
                      Navigator.of(context).pop(); // to pop the dialog box
                      Navigator.of(context).pushReplacementNamed('/home');
                    }).catchError((e) {
                      // return "error";
                      BottomSheetWidget().bottomSheet(
                          context, "มีข้อผิดพลาด", "ป้อนรหัส OTP ไม่ถูกต้อง");
                    });
                  },
                )
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        });
  }

  /* =============================================== */
  // สร้างฟังชั่นสำหรับการ Login ด้วย Email
  /* =============================================== */
  Future firebaseSignIn(
      BuildContext context, String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacementNamed(context, '/home');
      // print(_userCredential.user.email);
    } on FirebaseAuthException catch (e) {
      // print(e);
      if (e.code == 'invalid-email') {
        print('Invalid-email');
        BottomSheetWidget().bottomSheet(
            context, "มีข้อผิดพลาด", "รูปแบบเบอร์โทรศัพท์ไม่ถูกต้อง");
      } else if (e.code == 'user-not-found') {
        BottomSheetWidget()
            .bottomSheet(context, "มีข้อผิดพลาด", "ไม่พบอีเมล์นี้ในระบบ");
      } else if (e.code == 'wrong-password') {
        BottomSheetWidget()
            .bottomSheet(context, "มีข้อผิดพลาด", "รหัสผ่านไม่ถูกต้อง");
      } else {
        print(e.code);
      }
    }
  }

  // ==============================================================================
  // สร้างฟังก์ชันสำหรับเข้าระบบด้วย Facebook
  // ==============================================================================
  Future signInWithFacebook(BuildContext context) async {
    final FacebookLoginResult result = await _facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:

        // final FacebookAccessToken accessToken = result.accessToken;
        // BottomSheetWidget().bottomSheet(context,"เข้าสู่ระบบสำเร็จ","Token: ${accessToken.token}\nUser id: ${accessToken.userId}\nExpires: ${accessToken.expires}\nPermissions: ${accessToken.permissions}\nDeclined permissions: ${accessToken.declinedPermissions}");
        
        final String token = result.accessToken.token;
        final response = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
        final profile = jsonDecode(response.body);
        print(profile);

        Navigator.pushReplacementNamed(context, '/home');
        break;
      case FacebookLoginStatus.cancelledByUser:
        BottomSheetWidget().bottomSheet(context,"มีข้อผิดพลาด","ผู้ใช้ยกเลิกการเข้าใช้งาน");
        break;
      case FacebookLoginStatus.error:
        BottomSheetWidget().bottomSheet(context,"มีข้อผิดพลาด","มีข้อผิดพลาด ${result.errorMessage} ในระหว่างการเข้าใช้งาน");
        break;
    }
  }


  // สร้างฟังชั่นสำหรับการ Register
  Future firebaseRegister(
      BuildContext context, String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // ถ้ามี error thown แล้วเปิดคู่มือดู google firebase ดู
      // error เกิดจาก libary เก่าที่ยังมี bug บางส่วน ใส่อันนี้ใหม่แล้ว
      // print(e);
      if (e.code == 'weak-password') {
        print('weak-password');
        BottomSheetWidget().bottomSheet(
          context,
          "มีข้อผิดพลาด",
          "รหัสผ่านสั้นหรือง่ายเกินไป ไม่ปลอดภัย",
        );
      } else if (e.code == 'email-already-in-use') {
        BottomSheetWidget().bottomSheet(
          context,
          "มีข้อผิดพลาด",
          "มีบัญชีนี้อยู่แล้วในระบบ ลองใช้อีเมล์อื่น",
        );
      } else if (e.code == 'invalid-email') {
        BottomSheetWidget().bottomSheet(
          context,
          "มีข้อผิดพลาด",
          "รูปแบบอีเมล์ไม่ถูกต้อง",
        );
      } else {
        // print(e.code);
      }

      // Fluttertoast.showToast(
      //     msg: e.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      // print(e);
    }
  }

  /* =============================================== */
  // สร้างฟังชั่นสำหรับการดึงข้อมูล User ออกมาใช้
  /* =============================================== */
  static firebaseUserDetail() {
    final User user = _firebaseAuth.currentUser;
    return user;
  }

  // สร้างฟังชั่นสำหรับการ Logout
  Future firebaseLogout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
