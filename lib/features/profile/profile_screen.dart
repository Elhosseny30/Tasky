import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/core/theme/theme_controller.dart';
import 'package:try_shared_preferences/core/widgets/custom_svg_widget.dart';
import 'package:try_shared_preferences/features/profile/user_profile_details.dart';
import 'package:try_shared_preferences/features/welcome/welcom_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Guest";
  String userMotivationQuote = "";

  String? userImagePath;
  @override
  void initState() {
    super.initState();
    getUserName();
    getUserQuote();
  }

  void getUserQuote() {
    setState(() {
      userMotivationQuote =
          PrefernecesManager().getString("motivationQuote") ?? "";
    });
  }

  void getUserName() {
    setState(() {
      userName = PrefernecesManager().getString("username") ?? "Guest";
      userImagePath = PrefernecesManager().getString("userImagePath");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Profile",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),

            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundImage: userImagePath == null
                            ? AssetImage("assets/images/profilephoto.png")
                            : FileImage(File(userImagePath!)),
                        radius: 85,
                        backgroundColor: Colors.transparent,
                      ),
                      GestureDetector(
                        onTap: () {
                          /// TODO
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(100),
                          ),

                          child: GestureDetector(
                            onTap: () async {
                              showImageSource(context, (XFile file) {
                                saveImage(file);
                                setState(() {
                                  userImagePath = file.path;
                                });
                              });
                            },
                            child: Icon(
                              Icons.camera_alt_outlined,
                              //color: Color(0xffFFFCFC),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  Text(
                    userMotivationQuote,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),

            Text(
              "Profile Info",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final bool? res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext) {
                      return UserProfileDetails(
                        userName: userName,
                        quote: userMotivationQuote,
                      );
                    },
                  ),
                );
                if (res != null && res) {
                  getUserName();
                  getUserQuote();
                }
              },
              title: Text("User Details"),
              leading: CustomSvgWidget(
                path: "assets/images/profilepersonicon.svg",
              ),

              trailing: CustomSvgWidget(path: "assets/images/arrowicon.svg"),
            ),
            Divider(color: Color(0xff6E6E6E), thickness: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,

              title: Text("Dark Mode"),
              leading: CustomSvgWidget(path: "assets/images/darkmodeicon.svg"),
              trailing: ValueListenableBuilder(
                valueListenable: ThemeController.themeNotifier,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Switch(
                    padding: EdgeInsets.zero,
                    value: value == ThemeMode.dark,
                    onChanged: (value) {
                      ThemeController.toggleTheme(value);
                    },
                  );
                },
              ),
            ),
            Divider(color: Color(0xff6E6E6E), thickness: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                await PrefernecesManager().remove("username");
                await PrefernecesManager().remove("motivationQuote");
                await PrefernecesManager().remove("tasks");

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext) {
                      return WelcomScreen();
                    },
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              title: Text("Log Out"),
              leading: CustomSvgWidget(
                path: "assets/images/profilepersonicon.svg",
              ),
              trailing: CustomSvgWidget(path: "assets/images/arrowicon.svg"),
            ),
          ],
        ),
      ),
    );
  }

  void saveImage(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newPath = await File(file.path).copy('${appDir.path}/${file.name}');

    await PrefernecesManager().setString("userImagePath", newPath.path);
  }

  void showImageSource(
    BuildContext context,
    void Function(XFile) selectedFile,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            "Choose Image Source",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  selectedFile(image);
                } 
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.camera_alt_outlined),
                  SizedBox(width: 8),
                  Text("Camera", style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  selectedFile(image);
                }
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.photo),
                  SizedBox(width: 8),
                  Text(
                    "Gallery",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
