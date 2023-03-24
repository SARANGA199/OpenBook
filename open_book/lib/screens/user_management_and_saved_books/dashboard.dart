import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:open_book/screens/user_management_and_saved_books/UserProfile/ProfileDetails.dart';

class Dashboard extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  // Dashboard(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    print(user?.email);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome ${user?.email}'),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     FirebaseAuth.instance.signOut();
            //   },
            //   child: const Text('Logout'),
            //   //navigate to login screen
            // ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //logout
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserDetailsScreen()),
                  );
                },
                child: Text('Add New Recipe'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //logout
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserDetailsScreen()),
                  );
                },
                child: Text('Recipe Recipe List'),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
