import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Amqp {
  static final ConnectionSettings _settings = ConnectionSettings(
    host: dotenv.env['AMQP_HOST']!,
    port: int.parse(dotenv.env['AMQP_PORT']!),
    virtualHost: dotenv.env['AMQP_VIRTUAL_HOST']!,
    authProvider: PlainAuthenticator(
      dotenv.env['AMQP_USER']!,
      dotenv.env['AMQP_PASSWORD']!,
    ),
    connectionName: dotenv.env['AMQP_CONNECTION_NAME'],
    maxConnectionAttempts: dotenv.env['AMQP_MAX_CONNECTION_ATTEMPTS'] != null
        ? int.parse(dotenv.env['AMQP_MAX_CONNECTION_ATTEMPTS']!)
        : 10,
  );

  static Future<void> publishMessage(
    String exchangeName,
    Object message,
  ) async {
    if (_settings.connectionName == 'SmartTrainer') {
      final Client client = Client(settings: _settings);
      final channel = await client.channel();
      final exchange = await channel.exchange(
        exchangeName,
        ExchangeType.FANOUT,
        durable: true,
      );
      exchange.publish(
        message,
        '',
        properties: MessageProperties.persistentMessage(),
      );
      client.close();
    }
  }

  static Future<void> startListening(
    String exchangeName,
    void Function(Map<dynamic, dynamic>) onMessage,
  ) async {
    if (_settings.connectionName == 'SmartTrainer') {
      final Client client = Client(settings: _settings);
      final channel = await client.channel();
      final queue = await channel.queue('', exclusive: true);
      final exchange = await channel.exchange(
        exchangeName,
        ExchangeType.FANOUT,
        durable: true,
      );

      await queue.bind(exchange, '');

      queue.consume().then((consumer) {
        consumer.listen((AmqpMessage message) {
          onMessage(message.payloadAsJson);
        });
      });
    }
  }
}
