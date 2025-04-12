import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/user.dart';
import 'home_screen.dart';

class RegisterScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final db = DBHelper();

  void _register(BuildContext context) async {
    final user = User(
      name: _nameController.text,
      address: _addressController.text,
      password: _passwordController.text,
    );
    await db.insertUser(user);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
          TextField(controller: _addressController, decoration: InputDecoration(labelText: 'Address')),
          TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () => _register(context), child: Text('Register')),
        ]),
      ),
    );
  }
}
