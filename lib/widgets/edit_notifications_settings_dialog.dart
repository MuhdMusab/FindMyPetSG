import 'dart:ui';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/helper/settings_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNotificationsSettingsDialog extends StatefulWidget {

  const EditNotificationsSettingsDialog({
    Key? key,
  }) : super(key: key);

  @override
  _EditNotificationsSettingsDialogState createState() => _EditNotificationsSettingsDialogState();
}

class _EditNotificationsSettingsDialogState extends State<EditNotificationsSettingsDialog> {
  bool notificationsEnabled = true;

  Future<bool> _getNotificationsPreferences() async {
    return settingsPrefs.getNotificationsEnabled();
  }

  Future<bool> _getLookoutNotificationsPreferences() async {
    return settingsPrefs.getLookoutNotificationsEnabled();
  }

  Future<bool> _getChatNotificationsPreferences() async {
    return settingsPrefs.getChatNotificationsEnabled();
  }

  Future<int> _getLookoutDistancePreferences() async {
    return settingsPrefs.getLookoutDistance();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                const BoxShadow(
                    color: Colors.black, offset: const Offset(0, 10), blurRadius: 10),
              ]),
          child: FutureBuilder(
              future: _getNotificationsPreferences(),
              builder: (context, snapshot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Notifications',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, ),
                        ),
                        snapshot.hasData
                            ? Switch(
                          value: snapshot.data as bool,
                          onChanged: (newVal) async {
                            if (!newVal) {
                              settingsPrefs.setNotificationsEnabled(newVal);
                              settingsPrefs.setLookoutNotificationsEnabled(newVal);
                              settingsPrefs.setChatNotificationsEnabled(newVal);
                              settingsPrefs.setLookoutDistance(1000);
                              FlutterBackgroundService service = FlutterBackgroundService();
                              service.invoke('stopService');
                              setState(() {

                              });
                            } else {
                              settingsPrefs.setNotificationsEnabled(newVal);
                              setState(() {

                              });
                            }

                          },
                          activeColor: pink(),
                        )
                            : Switch(
                          value: true,
                          onChanged: (newVal) {
                            setState(() {
                              notificationsEnabled = newVal;
                            });
                          },
                          activeColor: pink(),
                        ),
                      ],
                    ),
                    snapshot.hasData && snapshot.data == true
                        ? FutureBuilder(
                      future: _getLookoutNotificationsPreferences(),
                      builder: (context, lookoutSnapshot) {
                        if (lookoutSnapshot.hasData) {
                          return Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Lookout Notifications',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, ),
                                    ),
                                    Switch(
                                      value: lookoutSnapshot.data as bool,
                                      onChanged: (newVal) async {
                                        settingsPrefs.setLookoutNotificationsEnabled(newVal);
                                        setState(() {

                                        });
                                      },
                                      activeColor: pink(),
                                    )
                                  ]
                              ),
                              lookoutSnapshot.hasData && lookoutSnapshot.data == true
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0,),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                'New Lookout Post Distance: ',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, ),
                              ),
                                    ),
                                  )
                                  : Container(),
                              lookoutSnapshot.hasData && lookoutSnapshot.data == true
                                  ? FutureBuilder(
                                  future: _getLookoutDistancePreferences(),
                                  builder: (context, distanceSnapshot) {
                                    if (distanceSnapshot.hasData) {
                                      return SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          valueIndicatorColor: lightPink(),
                                          valueIndicatorTextStyle: TextStyle(
                                            color: foundTextColor(),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        child: Slider(
                                          activeColor: Color(0xFFf6b9c2),
                                          inactiveColor: Colors.grey,
                                          value: (distanceSnapshot.data! as int) / 1.0, //_currentSliderValue!,
                                          label: distanceSnapshot.data!.toString(), //_currentSliderValue!.round().toString(),
                                          thumbColor: pink(),
                                          onChanged: (double newvalue) async {
                                            settingsPrefs.setLookoutDistance(newvalue.round());
                                            setState(() {

                                            });
                                          },
                                          min: 0,
                                          max: 10000,
                                          divisions: 20,
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }

                                  }
                              )
                                  : Container(),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                        :  Container(),
                    snapshot.hasData && snapshot.data == true
                        ? FutureBuilder(
                      future: _getChatNotificationsPreferences(),
                      builder: (context, chatSnapshot) {
                        if (chatSnapshot.hasData) {
                          return Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Chat Notifications',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, ),
                                    ),
                                    Switch(
                                      value: chatSnapshot.data as bool,
                                      onChanged: (newVal) async {
                                        settingsPrefs.setChatNotificationsEnabled(newVal);
                                        setState(() {

                                        });
                                      },
                                      activeColor: pink(),
                                    )
                                  ]
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                        :  Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Restart.restartApp();
                          },
                          child: Text(
                            'Apply',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
