import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:newtook/provider/locale_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return // toggle notification with text
        Scaffold(
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
            Text(AppLocalizations.of(context)!.choose_lang.toUpperCase(),
                style: const TextStyle(color: Colors.black)),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).primaryColor),
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
