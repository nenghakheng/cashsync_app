import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:cashsyncapp/pages/layout/side_bar.dart';
import 'package:cashsyncapp/viewModels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(),
      child: Scaffold(
        drawer: SideBar(),
        appBar: _buildAppBar(context),
        body: Consumer<UserViewModel>(
          builder: (context, userViewModel, child) {
            final List<UserModel?> users = userViewModel.users;
            final UserModel? user = userViewModel.user;

            final String userName = user?.name ?? "Guest";

            return _buildUserList(users, userName);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      actionsPadding: EdgeInsets.only(right: ConfigConstant.padding3),
      automaticallyImplyLeading: false,
      leading: Builder(
        // Add this Builder widget
        builder: (BuildContext context) {
          // This context has access to the Scaffold
          return Container(
            margin: EdgeInsets.only(left: ConfigConstant.padding3),
            child: IconButton(
              padding: EdgeInsets.only(right: ConfigConstant.padding3),
              iconSize: ConfigConstant.iconSize3,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Now this works
              },
            ),
          );
        },
      ),
      // Center the title area (can be empty or contain content)
      title: const SizedBox(),
      centerTitle: true,
      // Place notification icon on the right side
      actions: [
        IconButton(
          iconSize: ConfigConstant.iconSize3,
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Notification action
          },
        ),
      ],
    );
  }

  Widget _buildUserList(List<UserModel?> users, String userName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome to CashSync! $userName'),
          const SizedBox(height: 20),
          if (users.isEmpty)
            const Text("No users found.")
          else
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user?.name ?? "Unknown User"),
                    subtitle: Text(user?.email ?? "No Email"),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
