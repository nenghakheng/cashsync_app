import 'package:cashsyncapp/commons/widgets/navigate_button.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:cashsyncapp/pages/profile/local_widgets/profile_picture.dart';
import 'package:cashsyncapp/pages/profile/local_widgets/profile_info.dart';
import 'package:cashsyncapp/providers/current_user_provider.dart';
import 'package:cashsyncapp/viewModels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEdit = false;
  final profileFormKey = GlobalKey<FormState>();
  final profileEmailController = TextEditingController();
  final profileNameController = TextEditingController();

  @override
  void dispose() {
    profileEmailController.dispose();
    profileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrentUserProvider(),
      child: Scaffold(appBar: _buildAppBar(context), body: _buildBody(context)),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      forceMaterialTransparency: true,
      title: const Text(
        "Profile",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leadingWidth: 130,
      leading: _buildBackButton(context),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return NavigateButton(
      icon: Icon(
        Icons.arrow_back,
        size: ConfigConstant.iconSize2,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    final CurrentUserProvider currentUserProvider =
        Provider.of<CurrentUserProvider>(context);
    final UserModel? user = currentUserProvider.currentUser;
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );

    return Center(
      child: Column(
        children: [
          ProfilePicture(
            isEdit: !isEdit,
            imageUrl: user?.imageUrl,
            onImageTap:
                () => changeProfilePicture(context, user, profileViewModel),
          ),
          ConfigConstant.sizedBoxH3,
          ProfileInfo(
            user: user,
            isReadOnly: !isEdit,
            profileFormKey: profileFormKey,
            profileEmailController: profileEmailController,
            profileNameController: profileNameController,
          ),
          ConfigConstant.sizedBoxH6,
          _buildEditButton(context, user, profileViewModel),
        ],
      ),
    );
  }

  Widget _buildEditButton(
    BuildContext context,
    UserModel? user,
    ProfileViewModel? profileViewModel,
  ) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isEdit = !isEdit;

          if (!isEdit) {
            // We're in edit mode, trying to save
            if (profileFormKey.currentState?.validate() ?? false) {
              _saveProfile(context, user, profileViewModel);
            }
          } else {
            // We're not in edit mode, entering edit mode
            _enterEditMode(user);
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5063BF),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius3,
        ),
      ),
      child: Text(
        isEdit ? "Set Profile" : "Edit Profile",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void changeProfilePicture(
    BuildContext context,
    UserModel? user,
    ProfileViewModel? profileViewModel,
  ) {
    final ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        // Call the uploadProfileImage method from ProfileViewModel
        profileViewModel
            ?.uploadProfileImage(user?.id, pickedFile.path)
            .then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Profile picture updated successfully!"),
                ),
              );
            })
            .catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error updating profile picture: $error"),
                ),
              );
            });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No image selected.")));
      }
    });
  }

  void _enterEditMode(UserModel? user) {
    // Set controller values to current user values
    if (user != null) {
      profileEmailController.text = user.email ?? '';
      profileNameController.text = user.name ?? '';
    }

    setState(() {
      isEdit = true;
    });
  }

  Future<void> _saveProfile(
    BuildContext context,
    UserModel? user,
    ProfileViewModel? profileViewModel,
  ) async {
    // Validate if the form has been updated
    if (user?.email == profileEmailController.text &&
        user?.name == profileNameController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No changes made to the profile.")),
      );
      return;
    } else {
      setState(() {
        isEdit = false; // Exit edit mode
      });
    }

    try {
      final updatedUser = UserModel(
        id: user?.id,
        email: profileEmailController.text,
        name: profileNameController.text,
      );

      // Call the API outside of setState
      await profileViewModel?.updateProfile(
        id: updatedUser.id ?? '',
        user: updatedUser,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );

        // Optionally, you can refresh the current user data
        final currentUserProvider = Provider.of<CurrentUserProvider>(
          context,
          listen: false,
        );
        await currentUserProvider.refreshUser();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $error")),
        );
      }
    }
  }
}
