import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.taskNameController,
    required this.hintText,
    required this.title,
    this.validator,
    this.maxLines,
  });
  final String title;
  TextEditingController taskNameController = TextEditingController();
  final String hintText;
  final Function(String?)? validator;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16),
        ),

        SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          validator: validator != null
              ? (String? value) => validator!(value)
              : null,
          controller: taskNameController,
          style: Theme.of(context).textTheme.labelSmall,
          cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
          decoration: InputDecoration(
            hintText: hintText
          ),
        ),
      ],
    );
  }
}
