import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String nombre;
  late String apellido;
  late String email;
  late String telefono;
  late String password;
  late String passwordVerificado;
  GlobalKey formKey = GlobalKey<FormState>();
  bool valuefirst = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 70),
                  Image.network(
                      "https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=160&height=120"),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Nombre:",
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
                      onSaved: (value) {
                        nombre = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Apellido:",
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
                      onSaved: (value) {
                        apellido = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email:",
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
                      onSaved: (value) {
                        email = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Telefono:",
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
                      onSaved: (value) {
                        telefono = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "password:",
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
                      onSaved: (value) {
                        password = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Verifica tu password:",
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
                      onSaved: (value) {
                        passwordVerificado = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const SizedBox(width: 40),
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.greenAccent,
                        value: valuefirst,
                        onChanged: (value) {
                          setState(() {
                            valuefirst = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 5),
                      const Text("Aceptar ",
                          style: TextStyle(color: Color(0xff707070))),
                      const Text("términos y condiciones",
                          style: TextStyle(
                              color: Color(0xffad53ae),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(
                    width: 290,
                    child: ElevatedButton(
                      child: const Text("Registrate"),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffAD53AE),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text.rich(TextSpan(
                      text: '¿Ya tienes cuenta?',
                      style: TextStyle(color: Color(0xff707070)),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Iniciar sesión',
                          style: const TextStyle(
                              color: Color(0xffad53ae),
                              fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushNamed("/login");
                            },
                        )
                      ]))
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
