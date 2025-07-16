import 'package:cashsyncapp/my_app.dart';
import 'package:cashsyncapp/providers/current_user_provider.dart';
import 'package:cashsyncapp/viewModels/auth_view_model.dart';
import 'package:cashsyncapp/viewModels/profile_view_model.dart';
import 'package:cashsyncapp/viewModels/strategy_view_model.dart';
import 'package:cashsyncapp/viewModels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CurrentUserProvider()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => StrategyViewModel()),
      ],
      child: const MyApp(),
    ),
  ); // Start the app with MyApp widget
}
