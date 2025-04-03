# Smart Trainer - Sistema de Acompanhamento e Treinamento Personalizado

O sistema de Acompanhamento e Treinamento Personalizado é uma solução projetada para uma *personal trainer* que busca aprimorar seus serviços e proporcionar uma experiência excepcional aos seus clientes. Este sistema oferece uma gama completa de funcionalidades que facilitam a gestão de clientes, permitem a customização de treinamentos, disponibilização de avaliações físicas, realização de anamnese e promoção de  uma comunicação eficiente. Além disso, o sistema oferece flexibilidade no acompanhamento dos treinos.

## Alunos integrantes da equipe

* Belle Nerissa Aguiar Elizeu
* Rafael Duarte Pereira

## Professores responsáveis

* Cleiton Silva Tavares
* Danilo Boechat Seufitelli
* João Pedro Oliveira Batisteli
* Marco Rodrigo Costa
  

## Instruções de utilização

Este guia explica como gerar o arquivo APK do aplicativo Flutter para as versões Personal Trainer e Aluno.

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- Flutter SDK (versão mais recente)
- Android Studio ou Visual Studio Code
- Java Development Kit (JDK)
- Git

## Configuração do Ambiente

1. Clone o repositório:
```bash
git clone https://github.com/ICEI-PUC-Minas-PPLES-TI/plf-es-2024-1-tcci-0393100-dev-belle-elizeu-e-rafael-duarte
```

2. Verifique se o ambiente Flutter está corretamente configurado:
```bash
flutter doctor
```

Certifique-se de que não há problemas pendentes no resultado do `flutter doctor`.

## Gerando o APK

### Para o App Personal Trainer

1. Navegue até a pasta do projeto do Personal Trainer:
```bash
cd Codigo/app_personal
```
2. Limpe a build anterior (opcional, mas recomendado):
```bash
flutter clean
```

3. Obtenha as dependências:
```bash
flutter pub get
```

4. Gere o APK:
```bash
flutter build apk --release
```

O APK será gerado em: `build/app/outputs/flutter-apk/app-release.apk`

### Para o App Aluno

1. Navegue até a pasta do projeto do Aluno:
```bash
cd Codigo/app_aluno
```

2. Limpe a build anterior (opcional, mas recomendado):
```bash
flutter clean
```

3. Obtenha as dependências:
```bash
flutter pub get
```

4. Gere o APK:
```bash
flutter build apk --release
```

O APK será gerado em: `build/app/outputs/flutter-apk/app-release.apk`

## Instalação do APK

Para instalar o APK em um dispositivo Android:

1. Transfira o arquivo APK para o dispositivo Android
2. No dispositivo Android, navegue até o local do arquivo APK
3. Toque no arquivo APK para iniciar a instalação
4. Siga as instruções na tela para concluir a instalação

## Observações Importantes

- Certifique-se de que o arquivo `pubspec.yaml` esteja atualizado com todas as dependências necessárias
- Verifique se o arquivo `android/app/build.gradle` está configurado com a versão correta do aplicativo
- Em caso de erros durante a build, verifique os logs para identificar possíveis problemas
- Mantenha o Flutter SDK e as dependências atualizadas para evitar problemas de compatibilidade

## Solução de Problemas

Se encontrar problemas durante a build:

1. Verifique se todas as dependências estão atualizadas:
```bash
flutter pub upgrade
```

2. Limpe a build e cache:
```bash
flutter clean
flutter pub cache repair
```

3. Verifique se o Android SDK está atualizado no Android Studio

Para mais informações ou suporte, consulte a [documentação oficial do Flutter](https://flutter.dev/docs) ou abra uma issue no repositório do projeto.

