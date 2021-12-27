import 'package:daniel_test/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final Function toggleScreen;

  const Login({Key? key, required this.toggleScreen}) : super(key: key);
  @override
  Login_State createState() => Login_State();
}

class Login_State extends State<Login> {
  late TextEditingController _emailControolr;
  late TextEditingController _passwordControler;
  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    _emailControolr = TextEditingController();
    _passwordControler = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailControolr.dispose();
    _passwordControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(height: 40),
              const Text(
                'Wellcome Back',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'sign in to continue',
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailControolr,
                validator: (val) =>
                    val!.isEmpty ? "Please enter a valid email address" : null,
                decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordControler,
                validator: (val) =>
                    val!.length < 6 ? "Enter more thean 6 char" : null,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    print("Email: ${_emailControolr.text}");
                    print("Password: ${_passwordControler.text}");
                    await loginProvider.login(_emailControolr.text.trim(),
                        _passwordControler.text.trim());
                  }
                },
                height: 70,
                minWidth: double.infinity,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () => widget.toggleScreen(),
                      child: Text('Register'))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
