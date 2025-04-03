
import 'package:SmartTrainer/components/header/header.dart';
import 'package:SmartTrainer/components/menu.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:provider/provider.dart';

class ContatoPage extends StatefulWidget {
  const ContatoPage({Key? key}) : super(key: key);
  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  @override
  Widget build(BuildContext context) {
    final colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: Header(colorTheme: colorTheme),
      drawer: Menu(colorTheme: colorTheme),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              colorTheme.white_onPrimary_100,
              colorTheme.indigo_primary_400,
              colorTheme.white_onPrimary_100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                Transform.translate(
                  offset: Offset(0, (screenWidth * 0.5) / 2),
                  child: Container(
                    width: screenWidth,
                    padding: EdgeInsets.only(top: (screenWidth * 0.6) / 2),
                    decoration: BoxDecoration(
                      color: colorTheme.white_onPrimary_100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Text(
                            'Aline Duarte',
                            style: TextStyle(
                              color: colorTheme.black_onSecondary_100,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Personal Trainer',
                            style: TextStyle(
                              color: colorTheme.indigo_primary_500,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Divider(
                            color: colorTheme.black_onSecondary_100,
                            thickness: 1,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(
                                Mdi.phone,
                                color: colorTheme.indigo_primary_700,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '(31) 99737-8272',
                                style: TextStyle(
                                  color: colorTheme.black_onSecondary_100,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(
                                Mdi.emailOutline,
                                color: colorTheme.indigo_primary_700,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'aline.dpsjo@yahoo.com.br',
                                style: TextStyle(
                                  color: colorTheme.black_onSecondary_100,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: colorTheme.white_onPrimary_100,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: screenWidth * 0.25,
                      child: ClipOval(
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/images/foto_personal.png',
                          fit: BoxFit.cover,
                          width: screenWidth * 0.5,
                          height: screenWidth * 0.5,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
