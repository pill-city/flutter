import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

final url = Uri.parse('https://httpbin.org/ip');
final httpClient = HttpClient();

Future<String> getIPAddress() async {
  final request = await httpClient.getUrl(url);
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  final String ip = jsonDecode(responseBody)['origin'];
  return ip;
}

class IpAddressPage extends StatelessWidget {
  const IpAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: IpAddressWidget()
    );
  }
}


class IpAddressWidget extends StatefulWidget {
  const IpAddressWidget({super.key});

  @override
  State<IpAddressWidget> createState() => _IpAddressWidgetState();
}

class _IpAddressWidgetState extends State<IpAddressWidget> {
  bool _loading = true;
  String _ip = 'Unknown';

  void updateLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  void updateIp(String ip) {
    setState(() {
      _ip = ip;
    });
  }

  @override
  void initState() {
    getIPAddress().then((value) {
      updateLoading(false);
      updateIp(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _loading ? const Text("Just loading la...") : Column(
        children: [
          const Text("Your IP address is:"),
          Text(_ip),
          ElevatedButton(
            onPressed: () async {
              updateLoading(true);
              updateIp(await getIPAddress());
              updateLoading(false);
            },
            child: const Text("Go!"),
          )
        ]
      )
    );
  }
}