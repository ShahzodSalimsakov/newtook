import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newtook/provider/locale_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)!.settings.toUpperCase(),
            style: const TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //choose brands  and route to brands page
            ListTile(
              title: Text(AppLocalizations.of(context)!.choose_brand),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.router.pushNamed('/brands');
              },
            ),

            const Spacer(),
            Text(AppLocalizations.of(context)!.choose_lang.toUpperCase(),
                style: const TextStyle(color: Colors.black)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[200]),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .read<LocaleProvider>()
                            .setLocale(const Locale('uz'));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'icons/flags/png/uz.png',
                          package: 'country_icons',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context
                            .read<LocaleProvider>()
                            .setLocale(const Locale('ru'));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset('icons/flags/png/ru.png',
                            package: 'country_icons',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context
                            .read<LocaleProvider>()
                            .setLocale(const Locale('en'));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset('icons/flags/png/us.png',
                            package: 'country_icons',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      )),
    );
  }
}
