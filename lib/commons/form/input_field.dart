import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.text,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    required this.controller,
  });

  final String? text;
  final String? hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text ?? "",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Color(0xFF5265BE),
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF5164BF)),
            ),
            border: UnderlineInputBorder(),
            hintText: hintText ?? "Enter text here",
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $text';
            }
            return null;
          },
        ),
      ],
    );
  }
}
