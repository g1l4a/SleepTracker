import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/achievements_provider.dart';
import 'package:sleep_tracker/statistics_provider.dart';
import 'nothern_lights.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    final stats = ref.watch(statisticsProvider);

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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context).achievementScreenTitle, textAlign: TextAlign.center, style: headerStyle),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context).statisticsCurConsDays, softWrap: true, style: normalStyle),
                        const Expanded(child: Divider(color: Colors.blueGrey, indent: 16, endIndent: 16)),
                        Text('${stats.curConsDays}', softWrap: true, style: normalStyleGlow),
                      ],
                    ),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context).statisticsMaxConsDays, softWrap: true, style: normalStyle),
                        const Expanded(child: Divider(color: Colors.blueGrey, indent: 16, endIndent: 16)),
                        Text('${stats.maxConsDays}', softWrap: true, style: normalStyleGlow),
                      ],
                    ),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context).statisticsTotalDays, softWrap: true, style: normalStyle),
                        const Expanded(child: Divider(color: Colors.blueGrey, indent: 16, endIndent: 16)),
                        Text('${stats.total}', softWrap: true, style: normalStyleGlow),
                      ],
                    ),
                  ]
                )
              ),

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
                                _getAchievementName(context, s.id),
                                softWrap: true,
                                style: TextStyle(
                                  color: s.isObtained? Colors.grey.shade200 : Colors.blueGrey,
                                  fontSize: 24,
                                  fontFamily: 'Montserrat'
                                )
                              ),
                              Text(
                                _getAchievementDescription(context, s.id),
                                softWrap: true,
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
            ],
          ),
        ],
      ), 
    );
  }
}

String _getAchievementName(BuildContext context, int id) {
  switch (id) {
    case 0:
      return AppLocalizations.of(context).achievementName0;
    case 1:
      return AppLocalizations.of(context).achievementName1;
    case 2:
      return AppLocalizations.of(context).achievementName2;
    case 3:
      return AppLocalizations.of(context).achievementName3;
    case 4:
      return AppLocalizations.of(context).achievementName4;
    default:
      return "";
  }
}

String _getAchievementDescription(BuildContext context, int id) {
  switch (id) {
    case 0:
      return AppLocalizations.of(context).achievementDescription0;
    case 1:
      return AppLocalizations.of(context).achievementDescription1;
    case 2:
      return AppLocalizations.of(context).achievementDescription2;
    case 3:
      return AppLocalizations.of(context).achievementDescription3;
    case 4:
      return AppLocalizations.of(context).achievementDescription4;
    default:
      return "";
  }
}