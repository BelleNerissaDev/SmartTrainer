import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/sections/icons_feedback.dart';
import 'package:SmartTrainer_Personal/fonts.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/realizacao_treino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FeedbackCard extends StatelessWidget {
  final ColorFamily colorTheme;
  final String userName;
  final String? userImage;
  final String trainingPlan;
  final String timeAgo;
  final String comment;
  final int selectedIconIndex;

  const FeedbackCard({
    Key? key,
    required this.userName,
    required this.userImage,
    required this.trainingPlan,
    required this.timeAgo,
    required this.comment,
    required this.selectedIconIndex,
    required this.colorTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorTheme.white_onPrimary_100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        userImage != null ? NetworkImage(userImage!) : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.body16px!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorTheme.black_onSecondary_100,
                              ),
                        ),
                        Text(
                          trainingPlan,
                          style:
                              Theme.of(context).textTheme.label14px!.copyWith(
                                    color: colorTheme.grey_font_700,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: Theme.of(context).textTheme.label14px!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              IconsFeedback(
                colorTheme: colorTheme,
                selectedIndex: selectedIconIndex,
              ),
              const SizedBox(height: 12),
              Text(
                comment,
                style: Theme.of(context).textTheme.body12px!.copyWith(
                      color: colorTheme.black_onSecondary_100,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackCarousel extends StatelessWidget {
  final ColorFamily colorTheme;
  final List<RealizacaoTreino> realizacoes;
  final Aluno? aluno;

  const FeedbackCarousel({
    Key? key,
    required this.colorTheme,
    required this.realizacoes,
    this.aluno,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider.builder(
        itemCount: realizacoes.length,
        itemBuilder: (context, index, realIndex) {
          final realizacao = realizacoes[index];
          return FeedbackCard(
            colorTheme: colorTheme,
            userName: aluno != null ? aluno!.nome : realizacao.aluno!.nome,
            userImage: aluno != null ? aluno!.imagem : realizacao.aluno!.imagem,
            trainingPlan: realizacao.treino.nome,
            timeAgo:
                '''há ${DateTime.now().difference(realizacao.data).inDays.abs()} dias''',
            comment: realizacao.feedback!.observacao,
            selectedIconIndex: realizacao.feedback!.nivelEsforco.value,
          );
        },
        options: CarouselOptions(
          viewportFraction: 0.9,
          height: 200,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
