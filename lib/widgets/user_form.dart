import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  final Function(String, String) onSubmit;
  final String? errorMessage;

  UserForm({required this.onSubmit, this.errorMessage});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSubmit(_nameController.text, _emailController.text);
            },
            child: Text('Register'),
          ),
          if (widget.errorMessage != null) ...[
            Text(widget.errorMessage!, style: TextStyle(color: Colors.red)),
          ],
        ],
      ),
    );
  }
}
