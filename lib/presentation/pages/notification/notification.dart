import 'package:flutter/material.dart';
import 'package:vouchee/model/notification.dart';
import 'package:vouchee/networking/api_request.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<NotificationReceiver>> futureNoti;
  ApiServices apiServices = ApiServices();
  @override
  void initState() {
    super.initState();
    futureNoti = apiServices.getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Thông báo'),
        ),
        body: FutureBuilder<List<NotificationReceiver>>(
          future: futureNoti,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No items'));
            } else {
              // Safely access the message list and its length
              List<NotificationReceiver> messages = snapshot.data!;

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  NotificationReceiver message = messages[index];
                  return ListTile(
                    leading: Icon(Icons.notifications, color: Colors.blue),
                    title: Text(
                      message.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(message.body),
                  );
                },
              );
            }
          },
        ));
  }
}
