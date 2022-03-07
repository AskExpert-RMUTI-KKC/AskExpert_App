import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class GoogleSingIn extends StatefulWidget {
  const GoogleSingIn({Key? key}) : super(key: key);

  @override
  _GoogleSingInState createState() => _GoogleSingInState();
}

class _GoogleSingInState extends State<GoogleSingIn> {

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Google Sign in'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: _buildWidget(),
      ),
    );
  }

  Widget _buildWidget(){
    GoogleSignInAccount? user = _currentUser;
    if(user != null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
        child: Column(
          children: [
            ListTile(
              leading: GoogleUserCircleAvatar(identity: user),
              title:  Text(user.displayName ?? '', style: TextStyle(fontSize: 22),),
              subtitle: Text('${user.email}\n G-ID : ${user.id}', style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 20,),
            const Text(
              'Signed in successfully',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: signOut,
                child: const Text('Sign out')
            )
          ],
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text(
              'You are not signed in',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: signIn,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Sign in', style: TextStyle(fontSize: 30)),
                )
            ),
          ],
        ),
      );
    }
  }

  void signOut(){
    _googleSignIn.disconnect();
  }

  Future<void> signIn() async {
    try{
      await _googleSignIn.signIn();
    }catch (e){
      print('Error signing in $e');
    }
  }

}