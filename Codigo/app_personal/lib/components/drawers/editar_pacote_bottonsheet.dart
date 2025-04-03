import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';
import 'package:SmartTrainer_Personal/components/inputs/dropdown_input.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:flutter/material.dart';

class EditPackageBottomSheet extends StatefulWidget {
  final ColorFamily colorTheme;
  final Future<List<Pacote>> pacotes;

  const EditPackageBottomSheet(
      {Key? key, required this.colorTheme, required this.pacotes})
      : super(key: key);

  @override
  _EditPackageBottomSheetState createState() => _EditPackageBottomSheetState();
}

class _EditPackageBottomSheetState extends State<EditPackageBottomSheet> {
  Pacote? selectedPacote;
  final TextEditingController pacoteDropdownController =
      TextEditingController();
  List<Pacote> pacotesList = [];

  @override
  void initState() {
    super.initState();
    _loadPacotes();
  }

  Future<void> _loadPacotes() async {
    try {
      final pacotes = await widget.pacotes;
      setState(() {
        pacotesList = pacotes;
        if (pacotes.isNotEmpty) {
          selectedPacote = pacotes.first;
          pacoteDropdownController.text = selectedPacote?.toString() ?? '';
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao carregar pacotes: $e');
    }
  }

  void _onSelected(Pacote? newValue) {
    setState(() {
      selectedPacote = newValue;
      if (newValue != null) {
        pacoteDropdownController.text = newValue.toString();
      }
    });
  }

  void _onSave() {
    if (selectedPacote != null) {
      Navigator.pop(context, selectedPacote);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = widget.colorTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Editar Pacote',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Pacote>>(
            future: widget.pacotes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Text('Erro ao carregar pacotes');
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Nenhum pacote disponível');
              }

              // Se ainda não tiver um pacote selecionado, seleciona o primeiro
              selectedPacote ??= snapshot.data!.first;

              return DropdownInput<Pacote>(
                width: MediaQuery.of(context).size.width * 0.9,
                selectedValue: selectedPacote,
                backgroundColor: colorTheme.light_container_500,
                label: 'Pacote de treino',
                items: snapshot.data!,
                onSelected: _onSelected,
                dropdownController: pacoteDropdownController,
              );
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: PrimaryButton(
              verticalPadding: MediaQuery.of(context).size.height * 0.015,
              horizontalPadding: MediaQuery.of(context).size.width * 0.25,
              label: 'Salvar',
              onPressed: _onSave,
              backgroundColor: colorTheme.indigo_primary_500,
            ),
          ),
        ],
      ),
    );
  }
}

void showEditPackageBottomSheet(
  BuildContext context,
  ColorFamily colorTheme,
  Future<List<Pacote>> pacotes,
) {
  showModalBottomSheet<Pacote>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return EditPackageBottomSheet(colorTheme: colorTheme, pacotes: pacotes);
    },
  );
}
