import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_book/models/userAccount.dart';
import 'package:open_book/repositories/userRepository.dart';
import '../../../../components/already_have_an_account_acheck.dart';
import '../../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _country;
  late String _mobile;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  //register function
  Future<void> _register() async {
    if (formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (mounted) {
          //add user to firebase
          UserAccount user = UserAccount(
              userCredential.user!.uid,
              _emailController.text.trim(),
              _firstName,
              _lastName,
              _country,
              _mobile);
          UserRepository userRepository = UserRepository();
          userRepository.addUser(user);
        }
        //show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User Registered successfully'),
          ),
        );
        formKey.currentState!.reset();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(e.message!),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (name) {},
              onChanged: (value) {
                setState(() {
                  _firstName = value;
                });
              },
              decoration: InputDecoration(
                hintText: "First Name",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter First Name';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (name) {},
            onChanged: (value) {
              setState(() {
                _lastName = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Last Name",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Last Name';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email Address",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Email Address';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (name) {},
            onChanged: (value) {
              setState(() {
                _mobile = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Mobile Number",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Mobile Number';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onChanged: (value) {
                setState(() {
                  _country = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Country",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.location_city),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Country';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Password';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: _register,
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
