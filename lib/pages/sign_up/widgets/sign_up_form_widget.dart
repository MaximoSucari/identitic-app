import 'package:flutter/material.dart';

import 'package:identitic/utils/validator.dart';

class SignUpFormWidget extends StatefulWidget {
  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            validator: (value) => Validator.validateUsername(value),
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          SizedBox(height: 32),
          _signUpButton(),
        ],
      ),
    );
  }

  Widget _signUpButton() {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        onPressed: () {
          //TODO: Metodo para enviar mails a la base de datos?
        },
        color: Colors.pink,
        child: Text('Recibir información'),
      ),
    );
  }
}