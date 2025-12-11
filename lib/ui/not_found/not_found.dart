import 'package:flutter/material.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

class NotFoundPage extends StatefulWidget {
  final String address;

  const NotFoundPage(this.address, {super.key});

  @override
  NotFoundPageState createState() => NotFoundPageState();
}

class NotFoundPageState extends State<NotFoundPage> {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("404 Not Found", textDirection: TextDirection.ltr),
            const SizedBox(height: 15),
            Text(
              "Address: ${widget.address}",
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Use go_router to navigate back to a safe entry route
                context.go(YRRoutes.initialLoading);
              },
              child: Text(AppLocalizations.of(context)!.back_to_home),
            ),
          ],
        ),
      ),
    );
  }
}
