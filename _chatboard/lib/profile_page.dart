import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _roleController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch the current user's profile information from Firestore
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _firstNameController.text = userDoc['firstName'];
          _lastNameController.text = userDoc['lastName'];
          _roleController.text = userDoc['role'];
          _dobController.text = userDoc['dob'] ?? '';
        });
      }
    }
  }

  // Update the current user's profile information in Firestore
  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'role': _roleController.text,
          'dob': _dobController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
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
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}