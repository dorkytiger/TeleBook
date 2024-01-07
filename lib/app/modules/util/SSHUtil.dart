import 'package:dartssh2/dartssh2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSHUtil {


  Future<SSHClient> initClient() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return SSHClient(
        await SSHSocket.connect(sharedPreferences.getString('host') ?? "",
            int.parse(sharedPreferences.getString('port') ?? "")),
        username: sharedPreferences.getString('user') ?? "",
        onPasswordRequest: () => sharedPreferences.getString("pass"));
  }

  Future<SftpClient> initSftp() async {
    SSHClient sshClient = await initClient();
    return await sshClient.sftp();
  }
}
