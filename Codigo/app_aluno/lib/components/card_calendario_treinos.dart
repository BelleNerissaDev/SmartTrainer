import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';

class CardCalendarioTreinos extends StatefulWidget {
  final DateTime hoje;
  final List<DateTime> diasNaoTreinados;
  final List<DateTime> diasTreinados;
  final MyColorFamily colorTheme;

  CardCalendarioTreinos(
      {required this.hoje,
      required this.diasNaoTreinados,
      required this.diasTreinados,
      required this.colorTheme,
      Key? key})
      : super(key: key);

  @override
  _CardCalendarioTreinosState createState() => _CardCalendarioTreinosState();
}

class _CardCalendarioTreinosState extends State<CardCalendarioTreinos> {
  late PageController _pageController;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.hoje.year, widget.hoje.month);
    _pageController = PageController(initialPage: 2);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentMonth =
          DateTime(widget.hoje.year, widget.hoje.month - (2 - index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Calendário de Treinos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                height: 370,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    DateTime displayMonth = DateTime(
                        widget.hoje.year, widget.hoje.month - (2 - index));
                    return _buildCalendar(displayMonth);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMonth(DateTime date) {
    final months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildCalendar(DateTime month) {
    List<TableRow> rows = [];
    List<String> weekdays = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
    rows.add(TableRow(
      children: weekdays
          .map((day) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ))),
              ))
          .toList(),
    ));

    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    int startWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> cells = [];

    for (int i = 0; i < startWeekday; i++) {
      cells.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      bool isNaoTreinado = widget.diasNaoTreinados.any((markedDay) =>
          markedDay.year == month.year &&
          markedDay.month == month.month &&
          markedDay.day == day);

      bool isTreinado = widget.diasTreinados.any((markedDay) =>
          markedDay.year == month.year &&
          markedDay.month == month.month &&
          markedDay.day == day);

      bool isHoje = widget.hoje.year == month.year &&
          widget.hoje.month == month.month &&
          widget.hoje.day == day;

      cells.add(
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: SizedBox(
            height: 40,
            width: 40,
            child: Container(
              decoration: BoxDecoration(
                color: isHoje ? widget.colorTheme.lemon_secondary_500 : null,
                shape: BoxShape.circle,
                border: isNaoTreinado && !isHoje
                    ? Border.all(color: widget.colorTheme.red_error_500)
                    : isTreinado && !isHoje
                        ? Border.all(
                            color: widget.colorTheme.indigo_primary_800)
                        : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                ),
              ),
            ),
          ),
        ),
      );
    }

    while (cells.length % 7 != 0) {
      cells.add(Container());
    }

    for (int i = 0; i < cells.length; i += 7) {
      rows.add(TableRow(children: cells.sublist(i, i + 7)));
    }

    return Card(
      color: widget.colorTheme.white_onPrimary_100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                _formatMonth(_currentMonth),
              ),
            ),
            Table(
              children: rows,
            ),
          ],
        ),
      ),
    );
  }
}
