import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/pages/controller/grupo_muscular/grupo_muscular_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GruposMuscularesPage extends StatefulWidget {
  const GruposMuscularesPage({Key? key, this.gruposMuscularesOnTest})
      : super(key: key);
  final Future<List<GrupoMuscular>>? gruposMuscularesOnTest;

  @override
  _GruposMuscularesPageState createState() => _GruposMuscularesPageState();
}

class _GruposMuscularesPageState extends State<GruposMuscularesPage> {
  late Future<List<GrupoMuscular>>? _futureGruposMusculares;

  @override
  void initState() {
    super.initState();
    try {
      _futureGruposMusculares =
          GrupoMuscularController().visualizarGruposMusculares();
    } on FirebaseException {
      _futureGruposMusculares =
          widget.gruposMuscularesOnTest ?? Future.value(<GrupoMuscular>[]);
    } catch (e) {
      _futureGruposMusculares = Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    return Scaffold(
      appBar: CustomAppBar(
        colorTheme: colorTheme,
        title: 'LOGO',
      ),
      drawer: Menu(colorTheme: colorTheme),
      endDrawer: NotificationMenu(colorTheme: colorTheme),
      body: Column(
        children: [
          HeaderContainer(
            colorTheme: colorTheme,
            title: 'Grupos Musculares',
          ),
          Expanded(
            child: CardContainer(
              colorTheme: colorTheme,
              child: FutureBuilder<List<GrupoMuscular>>(
                future: _futureGruposMusculares,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          // ignore: lines_longer_than_80_chars
                          'Erro ao carregar grupos musculares: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhum grupo muscular encontrado.'),
                    );
                  }
            
                  final gruposMusculares = snapshot.data!;
            
                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 8.0,
                      mainAxisExtent:
                          MediaQuery.of(context).size.height * 0.15,
                    ),
                    itemCount: gruposMusculares.length,
                    itemBuilder: (context, index) {
                      final grupo = gruposMusculares[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesNames.grupoMuscular.route,
                            arguments: {'grupoMuscular': grupo},
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: colorTheme.light_container_500,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: colorTheme.grey_font_500,
                                offset: const Offset(0, 4),
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/muscles/${grupoMuscularFormatName(grupo.nome)}.svg',
                                color: colorTheme.indigo_primary_500,
                                width: 40.0,
                                height: 40.0,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                grupo.nome,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: colorTheme.indigo_primary_500,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
