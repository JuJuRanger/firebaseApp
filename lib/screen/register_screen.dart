import 'package:firebaseApp/res/style.dart';
import 'package:firebaseApp/service/firebase/firebase_auth_service.dart';
import 'package:firebaseApp/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirmPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก', style: GoogleFonts.kanit()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                // ถ้าเเยอะๆใช้ ListView แทน Column
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(height: 50.0),
                  TextFormField(
                    decoration:
                        styleInputDecoration.copyWith(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    style: styleTextFieldText,
                    onChanged: (value) => _email = value,
                    validator: (value) =>
                        value.trim().isEmpty ? 'Enter email address' : null,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration:
                        styleInputDecoration.copyWith(labelText: 'Password'),
                    keyboardType: TextInputType.text,
                    obscureText: true, // ทำเป็นดอกใจ ไม่ให้เห็น
                    maxLines: 1,
                    style: styleTextFieldText,
                    onChanged: (value) => _password = value,
                    validator: (value) =>
                        value.trim().isEmpty ? 'Enter password' : null,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: styleInputDecoration.copyWith(
                        labelText: 'Confirm Password'),
                    keyboardType: TextInputType.text,
                    obscureText: true, // ทำเป็นดอกใจ ไม่ให้เห็น
                    maxLines: 1,
                    style: styleTextFieldText,
                    onChanged: (value) => _confirmPassword = value,
                    validator: (value) =>
                        value.trim().isEmpty || value.trim() != _password.trim()
                            ? 'Password missmatch'
                            : null,
                  ),
                  SizedBox(height: 20.0),
                  ButtonWidget(
                    buttonText: 'สมัครสมาชิก',
                    onClick: () {
                      print(_email);
                      if (_formKey.currentState.validate()) {
                        // ถ้าตัว formKey มีการ validate ผ่านแล้วให้ทำต่อไปนี้
                        FirebaseAuthService().firebaseRegister(context, _email, _password);
                      }
                    },
                  ),
                  SizedBox(height: 16.0),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "ถ้าเป็นสมาชิกอยู่แล้ว ?",
                        style: styleSmallText,
                        children: [
                          TextSpan(
                            text: " กลับหน้าล็อคอิน",
                            style: styleSmallText.copyWith(
                                color: Theme.of(context).primaryColorDark),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
