import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../model/usuario.dart';

class FileHelper {
  static const String _fileName = 'usuarios.txt';

  static Future<void> adicionarUsuario(Usuario usuario) async {
    try {
      // Obtenha o diretório atual do projeto
      String currentDirectory = Directory.current.path;

      // Construa o caminho completo do arquivo
      String dbPath = path.join(currentDirectory, 'db', _fileName);

      // Verifique se o arquivo existe, senão crie
      File file = File(dbPath);
      if (!await file.exists()) {
        await file.create(recursive: true);
      }

      // Converta o usuário para JSON
      String usuarioJson = jsonEncode(usuario.toJson());

      // Abra o arquivo em modo de escrita e adicione o usuário
      IOSink sink = file.openWrite(mode: FileMode.append);
      sink.write('$usuarioJson\n');
      await sink.flush();
      await sink.close();
      
      print('Usuário adicionado com sucesso: $usuario');
    } catch (e) {
      print('Erro ao adicionar usuário: $e');
    }
  }
}
