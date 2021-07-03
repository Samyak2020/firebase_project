import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  CustomTextField({this.hintText, this.onchanged, this.icon, this.obscureText, this.keyboardType,this.validator});

  final String hintText;
  final IconData icon;
  final Function onchanged;
  final Function validator;
  final bool obscureText;
  final TextInputType keyboardType;


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return TextFormField(
      keyboardType: keyboardType,
      onChanged: onchanged,
      style: theme.textTheme.subtitle2.copyWith(color:Colors.black54),
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon ?? Icons.person_outline, color: Colors.black54,
          size: 22,),
        hintText: hintText ?? 'Hint',
        hintStyle: theme.textTheme.subtitle2.copyWith(color: Colors.black54),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
      ),
      validator: validator,
    );
  }
}
