import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ProviderObserver, ProviderScope;
import 'package:video_demo/_features.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: kDebugMode ? const <ProviderObserver>[AppObserver()] : null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Video Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(title: 'Video Player'),
      ),
    );
  }
}
