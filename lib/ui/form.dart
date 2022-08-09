import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

renderTextFormField({
  required String label,
  required FormFieldSetter onSaved,
  required FormFieldValidator validator,
}) {
  assert(onSaved != null);
  assert(validator != null);

  return Column(
    children: [
      Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'NanumBarunGothicLight',
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: Colors.grey
            ),
          ),
        ],
      ),
      TextFormField(
        onSaved: onSaved,
        validator: validator,
      ),
    ],
  );
}