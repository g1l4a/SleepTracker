import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/achievements_provider.dart';
import 'nothern_lights.dart';

// TODO: add nothern_lights as background
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    const headerStyle = TextStyle(
      color: Colors.white,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      shadows: [
        Shadow(
          blurRadius: 5.0,
          color: Colors.white,
        ),
      ],
    );
    final normalStyle = TextStyle(
      color: Colors.grey.shade200,
      fontSize: 24,
      fontFamily: 'Montserrat'
    );
    final normalStyleGlow = TextStyle(
      color: Colors.grey.shade200,
      fontSize: 24,
      fontFamily: 'Montserrat',
      shadows: [
        Shadow(
          blurRadius: 5.0,
          color: Colors.grey.shade200,
        ),
      ],
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 0, 6, 88), 
          ),
          const Center(
            child: NorthernLights(beginDirection: Alignment.topLeft, endDirection: Alignment.bottomRight,),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only  (left: 8, right: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text('Achievements', textAlign: TextAlign.center, style: headerStyle),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Current consecutive days tracked', softWrap: true, style: normalStyle),
                        const Expanded(child: Divider(color: Colors.blueGrey, indent: 16, endIndent: 16)),
                        Text('0', softWrap: true, style: normalStyleGlow),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Maximum consecutive days tracked', softWrap: true, style: normalStyle),
                        const Expanded(child: Divider(color: Colors.blueGrey, indent: 16, endIndent: 16)),
                        Text('0', softWrap: true, style: normalStyleGlow),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Total days tracked', softWrap: true, style: normalStyle),
                        const Expanded(child: Divider(color: Colors.blueGrey, indent: 16, endIndent: 16)),
                        Text('0', softWrap: true, style: normalStyleGlow),
                      ],
                    ),
                  ]
                )
              ),
              
                          /*
                          TextButton(onPressed: () => {
                            ref.read(achievementsProvider.notifier).complete(0)
                          }, child: const Text('TEST BUTTON: obtain achievement')),*/

              // const Divider(height: 4, color: Colors.blueGrey),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8),
                  children: achievements.map(
                    (s) => Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.emoji_events,
                            size: 56,
                            color: s.isObtained? Colors.amber : Colors.grey,
                            shadows: s.isObtained? [
                              const Shadow(
                                blurRadius: 8.0,
                                color: Colors.amber,
                                offset: Offset(0, 2),
                              ),
                            ] : [])
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.name,
                                softWrap: true,
                                style: TextStyle(
                                  color: s.isObtained? Colors.grey.shade200 : Colors.blueGrey,
                                  fontSize: 24,
                                  fontFamily: 'Montserrat'
                                )
                              ),
                              Text(
                                softWrap: true,
                                s.description,
                                style: TextStyle(
                                  color: s.isObtained? Colors.grey.shade400 : Colors.blueGrey,
                                  fontSize: 18,
                                  fontFamily: 'Montserrat'
                                )
                              )
                            ],
                          )
                        )
                      ],
                    )
                  ).toList()
                )
              ),

              TextButton(
                child: Text('Reset achievements', style: normalStyle.copyWith(fontSize: 16, color: Colors.grey)),
                onPressed: () async {
                  bool? confirmed = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Wait a second!"),
                        content: const Text("Are you sure you want to reset achievements?"),
                        actions: [
                          TextButton(
                            onPressed: () { Navigator.of(context).pop(false); },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () { Navigator.of(context).pop(true); },
                            child: const Text("Confirm"),
                          ),
                        ],
                      );
                    },
                  );
                  
                  if (confirmed == true) ref.read(achievementsProvider.notifier).reset();
                },
              ),
            ],
          ),
        ],
      ), 
    );
  }
}
