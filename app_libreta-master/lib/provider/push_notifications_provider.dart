import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsProvider{

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  var token="";

  Future<String> getToken(){
    _firebaseMessaging.requestNotificationPermissions();
    return _firebaseMessaging.getToken();
  }


  initNotifications(){
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token){
      print("======FCM Token==========");
      print(token);
      this.token = token;
    });
    //APA91bH5rnZ33woedXtdvYQL1M2PvCwnBB9M8JHbbKrOG9171H0burznQU6UsNICo_hvEy4HXRUauFC_7FXAgogLf3A0TkQtPG_2BVEINvvesQhbMJJtkWFihjQdawBH3tBNuYKGpan6

    _firebaseMessaging.configure(
        onMessage: (info){
          print('====== On Message ========');
          print(info);
        },
        onLaunch: (info){
          print('====== On Launch ========');
          print(info);
        },
        onResume: (info){
          print('====== On Resume ========');
          print(info);
        }
    );

  }

}