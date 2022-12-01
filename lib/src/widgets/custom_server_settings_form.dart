import 'package:flutter/material.dart';

typedef CustomServerSettingsAppliedCallback = void Function(
    bool enabled, String address);

class CustomServerSettingsForm extends StatefulWidget {
  const CustomServerSettingsForm({
    super.key,
    required this.onSettingsApplied,
  });

  final CustomServerSettingsAppliedCallback onSettingsApplied;

  @override
  CustomServerSettingsFormState createState() {
    return CustomServerSettingsFormState();
  }
}

class CustomServerSettingsFormState extends State<CustomServerSettingsForm> {
  bool _enable = false;
  bool _useHttps = true;
  final TextEditingController customServerHostController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Switch(
              activeColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.redAccent
                  : Colors.deepOrangeAccent,
              value: _enable,
              onChanged: (bool checked) {
                setState(
                  () {
                    _enable = checked;
                  },
                );
              },
            ),
            const SizedBox(width: 16),
            const Text("Enable custom server"),
          ],
        ),
        if (_enable)
          Row(
            children: [
              DropdownButton(
                items: const [
                  DropdownMenuItem(value: "https", child: Text("https://")),
                  DropdownMenuItem(value: "http", child: Text("http://")),
                ],
                value: _useHttps ? "https" : "http",
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue == null) {
                      return;
                    }
                    _useHttps = newValue == 'https';
                  });
                },
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: customServerHostController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                    labelText: "Custom server host",
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Text("/api")
            ],
          ),
        const SizedBox(height: 4),
        ElevatedButton(
          onPressed: () {
            widget.onSettingsApplied(
              _enable,
              "${_useHttps ? "https://" : "http://"}${customServerHostController.text}/api",
            );
          },
          child: const Text("Apply"),
        ),
      ],
    );
  }
}
