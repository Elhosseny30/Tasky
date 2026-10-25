import 'package:flutter/material.dart';
import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/core/widgets/custom_text_form_field.dart';

class UserProfileDetails extends StatefulWidget {
  UserProfileDetails({super.key, required this.userName, required this.quote});
  final String userName;
  final String? quote;
  @override
  State<UserProfileDetails> createState() => _UserProfileDetailsState();
}

class _UserProfileDetailsState extends State<UserProfileDetails> {
  TextEditingController userNameController = TextEditingController();

  TextEditingController userQuoteMotivationController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameController.text = widget.userName;
    userQuoteMotivationController.text = widget.quote ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              CustomTextFormField(
                title: "User Name",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter User Name";
                  }
                  return null;
                },

                taskNameController: userNameController,
                hintText: "user Name Controller.text",
              ),

              SizedBox(height: 20),

              CustomTextFormField(
                title: "Motivation Quote",
                maxLines: 5,

                taskNameController: userQuoteMotivationController,
                hintText: "One task at a time. One step closer.",
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 40),
                  ),
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      await PrefernecesManager().setString(
                        "username",
                        userNameController.text,
                      );
                      await PrefernecesManager().setString(
                        "motivationQuote",
                        userQuoteMotivationController.text,
                      );

                      Navigator.of(context).pop(true);
                    }
                  },
                  child: Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
