import 'package:bitcoin_ticker_flutter/price_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
// 1. Mandatory for async calls before runApp
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Load the file
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Could not load env file: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.white),
      home: PriceScreen(),
    );
  }
}
