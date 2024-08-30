import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:persist_ventures/data/datasource/remote/api_service.dart';
import 'package:persist_ventures/data/repositories/api_repository_impl.dart';
import 'package:persist_ventures/presentation/home_page.dart';
import 'package:persist_ventures/providers/video_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => Dio(),
        ),
        Provider(
          create: (context) => ApiService(dio: context.read<Dio>()),
        ),
        Provider(
            create: (context) =>
                ApiRepositoryImpl(apiService: context.read<ApiService>())),
        ChangeNotifierProvider(
            create: (context) =>
                VideoProvider(apiRepository: context.read<ApiRepositoryImpl>())
                  ..fetchVideos(id: null))
      ],
      child: const MaterialApp(
        home: Scaffold(body: MyWidget()),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                )),
            child: const Text("Start")),
      ),
    );
  }
}
