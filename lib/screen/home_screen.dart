import 'package:firebaseApp/service/firebase/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // ลอง print ดูว่าได้อะไรมาบ้าง วิธีเรียกก็ getUser.email , getUser.isAnonymous

  @override
  Widget build(BuildContext context) {
    var getUser = FirebaseAuthService.firebaseUserDetail();

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuthService().firebaseLogout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Text('${getUser ?? "..."}'),
            SizedBox(
              height: 50,
            ),
            Text('Email : ${getUser?.email ?? "..."}'),
            Text(
              'Mobile : ${getUser?.phoneNumber ?? "..."}',
            ),
          ],
        ),
      ),
    );
  }
}
