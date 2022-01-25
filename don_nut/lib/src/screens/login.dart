import 'package:don_nut/src/utils/global.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();

  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        const SizedBox(height: 100),
        Image.network(
            "https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=200&height=150"),
        const SizedBox(height: 25),
        SizedBox(
          width: 300,
          child: TextField(
            controller: emailTextController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff707070),
                  width: 1.0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffAD53AE),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: TextField(
            controller: passwordTextController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: "Contraseña",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff707070),
                  width: 1.0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffAD53AE),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(60),
          width: 400,
          child: ElevatedButton(
            child: const Text("Ingresar"),
            onPressed: login,
            style: ElevatedButton.styleFrom(
              primary: const Color(0xffAD53AE),
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const Text.rich(
          TextSpan(
            text: "¿Has olvidado tu contraseña? ",
            style: TextStyle(color: Color(0xff707070)),
          ),
        ),
        const SizedBox(height: 15),
        Text.rich(
          TextSpan(
            text: "¿Aún no tiene cuenta? ",
            style: const TextStyle(color: Color(0xff707070)),
            children: [
              TextSpan(
                text: "Registrate",
                style: const TextStyle(
                    color: Color(0xffad53ae), fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushNamed("/register");
                  },
              )
            ],
          ),
        ),
      ],
    ));
  }

  void login() async {
    final response = await http.post(
      Uri.parse(url + 'auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": emailTextController.text,
        "password": passwordTextController.text
      }),
    );

    if (response.statusCode == 200) {
      token = json.decode(response.body)['token'];
      GetStorage().write('email', emailTextController.text);
      GetStorage().write('password', passwordTextController.text);
    } else if (response.statusCode == 401) {
      _showMyDialog(context);
    }
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => _buildAlertDialog(),
    );
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: const Text('Error de autenticación'),
      content: const Text("Email o contraseña incorrecto"),
      actions: <Widget>[
        TextButton(
            child: const Text("Aceptar"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
