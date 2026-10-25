import 'package:flutter/material.dart';
import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/core/widgets/custom_svg_widget.dart';
import 'package:try_shared_preferences/core/widgets/custom_text_form_field.dart';
import 'package:try_shared_preferences/features/navigator/main_bottom_navigation_bar.dart';

class WelcomScreen extends StatelessWidget {
  WelcomScreen({super.key});
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomSvgWidget.withoutColor(path: "assets/images/logo.svg"),
                    SizedBox(width: 16),
                    Text(
                      "Tasky",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                SizedBox(height: 116),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome To Tasky ",
                      style:Theme.of(context).textTheme.displaySmall,
                    ),
                   CustomSvgWidget.withoutColor(path: "assets/images/hand.svg"),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Your productivity journey starts here.",
                  style:Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16),
                ),
                SizedBox(height: 24),
                CustomSvgWidget.withoutColor(path:"assets/images/pana.svg",height: 206,width: 215, ),
                SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your Full Name";
                          }
                          return null;
                        },
                        taskNameController: controller,
                        hintText: "e.g. Sarah Khalid",
                        title: "Full Name",
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            MediaQuery.of(context).size.width,
                            40,
                          ),
                        ),
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            
                            await PrefernecesManager().setString("username", controller.text);
                        

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext) {
                                  return MainBottomNavigationBar();
                                },
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Let’s Get Started",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
