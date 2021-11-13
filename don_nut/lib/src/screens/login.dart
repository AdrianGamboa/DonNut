import 'package:flutter/material.dart';
import 'home_page.dart';
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
    
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
     body: Center(child: Column(
       children: <Widget>[
        const SizedBox(height: 100 ),
        Image.network("https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=200&height=150"),
          const SizedBox(height: 25),
          SizedBox(
            width: 300,
            child: TextField(
              controller: emailTextController,
              keyboardType: TextInputType.emailAddress,
              decoration:const InputDecoration(
                labelText:"Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                  color: Color(0xff707070),
                  width: 1.0, ),
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
              decoration:const InputDecoration(
                labelText:"Contraseña",
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
            child:const Text("Ingresar"),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: const Color(0xffAD53AE), 
              onPrimary: Colors.white,
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              textStyle: const TextStyle(
                fontSize:18, 
                fontWeight: FontWeight.w700
              ),
            ),
          ),
        ),
        const Text.rich(
          TextSpan(text: "¿Has olvidado tu contraseña? ",
          style: TextStyle(color: Color(0xff707070)),
          ),
        ),
        const SizedBox(height: 15),
        const Text.rich(
          TextSpan(text: "¿Aún no tiene cuenta? ",
          style: TextStyle(color: Color(0xff707070)),
            children: <TextSpan>[
              TextSpan(text: "Registrate",
              style: TextStyle(color: Color(0xffad53ae),fontWeight: FontWeight.bold))
            ],
          ),
        )
      ],
     )),//bottomNavigationBar: const NavBar(), //Barra de navegacion inferior 
      bottomNavigationBar: const NavBar(),
    );
  }
  @override
  void initState() {
    super.initState();
    emailTextController.addListener(_printEmail);
    passwordTextController.addListener(_printPassword);
  }

  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
  }

  void _printEmail() {
    // ignore: avoid_print
    print('email: ${emailTextController.text}');
  }
  void _printPassword() {
    // ignore: avoid_print
    print('contra: ${passwordTextController.text}');
  }
}
