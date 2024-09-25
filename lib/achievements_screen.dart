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
          offset: Offset(0, 2),
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
                padding: const EdgeInsets.all(16),
                child: const Text('Achievements', textAlign: TextAlign.center, style: headerStyle)
              ),
                          TextButton(onPressed: () => {
                            ref.read(achievementsProvider.notifier).complete(0)
                          }, child: const Text('activate')),
                          TextButton(onPressed: () => {
                            ref.read(achievementsProvider.notifier).reset()
                          }, child: const Text('reset')),
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
              )
            ],
          ),
        ],
      ), 
    );
  }
}
