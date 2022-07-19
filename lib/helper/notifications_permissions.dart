// import 'package:flutter/material.dart';
// import 'package:notification_permissions/notification_permissions.dart';
//
// var permGranted = "granted";
// var permDenied = "denied";
// var permUnknown = "unknown";
// var permProvisional = "provisional";
//
// Future<String?> getCheckNotificationPermStatus() {
//   return NotificationPermissions.getNotificationPermissionStatus()
//       .then((status) {
//     switch (status) {
//       case PermissionStatus.denied:
//         return permDenied;
//       case PermissionStatus.granted:
//         return permGranted;
//       case PermissionStatus.unknown:
//         return permUnknown;
//       case PermissionStatus.provisional:
//         return permProvisional;
//       default:
//         return null;
//     }
//   });
// }