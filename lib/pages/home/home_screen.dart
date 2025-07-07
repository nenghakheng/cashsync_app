import 'package:cashsyncapp/models/user_model.dart';
import 'package:cashsyncapp/viewModels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(),
      child: Scaffold(
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
