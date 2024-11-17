import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart'; // Import the AuthService class

class SettingsPage extends StatefulWidget {
  final AuthService authService;

  SettingsPage({required this.authService});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _roleController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _emailController.text = user.email ?? '';
          _firstNameController.text = userDoc['firstName'];
          _lastNameController.text = userDoc['lastName'];
          _roleController.text = userDoc['role'];
          _dobController.text = userDoc['dob'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (_emailController.text != user.email) {
          await user.updateEmail(_emailController.text);
        }
        if (_passwordController.text.isNotEmpty) {
          await user.updatePassword(_passwordController.text);
        }
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'role': _roleController.text,
          'dob': _dobController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Settings updated successfully')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your role';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserData,
                child: Text('Update Settings'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.authService.signOut();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}