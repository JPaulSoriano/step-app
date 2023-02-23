import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:step/services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Map<String, dynamic>? _notificationsData;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final data = await getNotifications();
    setState(() {
      _notificationsData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_notificationsData == null) {
      return Center(child: CircularProgressIndicator());
    }

    final notificationsCount = _notificationsData?['notifications_count'];
    final notifications = _notificationsData?['notifications'];

    return Column(
      children: [
        ListTile(
          title: Text(
            '$notificationsCount Unread Notifications.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (BuildContext context, int index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(notification['data']['type'],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Text(notification['data']['title']),
                trailing: Text(
                    'Due: ${DateFormat.yMMMMd().format(DateTime.parse(notification['data']['due_date']))}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
