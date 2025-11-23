import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_maths_expressions/pages/main_page.dart';

import 'Themes/math_theme.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MathsExpressionsApp());
}

class MathsExpressionsApp extends StatelessWidget {
  const MathsExpressionsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.mainPageTitle;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pl'),
      ],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        extensions: <ThemeExtension<dynamic>>[
          MathTheme(
            horizontalPadding: 2.0,
            verticalPadding: 2.0,
            expressionScale: 1.8,
            shrinkableTitleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: Theme.of(context).textTheme.titleMedium?.fontWeight,
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize),
            listItemDecoration: BoxDecoration(
              color: Colors.grey.shade300,
              // Background color of the "card"
              border: Border.all(
                color: Colors.grey.shade400, // Color of the outline
                width: 1.0, // Thickness of the outline
              ),
              borderRadius: BorderRadius.circular(8.0),
              // Rounded corners for the card-like look
              boxShadow: [
                // Optional: Add shadow similar to a Card
                BoxShadow(
                  color: Colors.grey.withAlpha(128),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            headerTextStyle: Theme.of(context).textTheme.bodyLarge,
            dropDownLabelStyle: Theme.of(context).textTheme.headlineSmall?.apply(color: Colors.blue.shade700, fontSizeFactor: 0.75),
            dropDownEntryLabelStyle: Theme.of(context).textTheme.headlineSmall?.apply(color: Colors.blue.shade900, fontSizeFactor: 0.75),
            dropDownMenuStyle: MenuStyle(
              shadowColor: WidgetStateProperty.all(Colors.transparent),
              backgroundColor: WidgetStateProperty.all(Colors.blueGrey.shade200),
              elevation: WidgetStateProperty.all(2),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))
                )
            ),
          ),
        ],
      ),
      home: HomePage(),
    );
  }
}

