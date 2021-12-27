import 'package:daniel_test/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  final Function toggleScreen;

  const Register({Key? key, required this.toggleScreen}) : super(key: key);
  @override
  Register_State createState() => Register_State();
}

class Register_State extends State<Register> {
  late TextEditingController _emailControolr;
  late TextEditingController _passwordControler;
  late TextEditingController _conformationControler;
  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    _emailControolr = TextEditingController();
    _passwordControler = TextEditingController();
    _conformationControler = TextEditingController();
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
    final regiserProvider = Provider.of<AuthServices>(context);
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              const Text(
                'Wellcome',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Register here',
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
              TextFormField(
                controller: _conformationControler,
                validator: (val) => val != _passwordControler.text
                    ? "Password are not match"
                    : null,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Confirm password',
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
                    regiserProvider.register(_emailControolr.text.trim(),
                        _passwordControler.text.trim());
                  }
                },
                height: 70,
                minWidth: //regiserProvider.isLoading ? null :
                    double.infinity,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: //regiserProvider.isLoading
                    //? CircularProgressIndicator()
                    const Text(
                  'Register',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Allready have an account?"),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () => widget.toggleScreen(),
                      child: const Text('Sign in'))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // ignore: unnecessary_null_comparison
              if (regiserProvider.errorMessage != "")
                Container(
                  color: Colors.amberAccent,
                  child: ListTile(
                    title: Text(regiserProvider.errorMessage),
                    leading: Icon(Icons.error),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => regiserProvider.setMessage(null),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    ));
  }
}
