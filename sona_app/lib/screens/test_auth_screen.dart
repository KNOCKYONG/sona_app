import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestAuthScreen extends StatefulWidget {
  const TestAuthScreen({super.key});

  @override
  State<TestAuthScreen> createState() => _TestAuthScreenState();
}

class _TestAuthScreenState extends State<TestAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _result = '';

  Future<void> _testSignUp() async {
    setState(() {
      _result = 'Testing sign up...';
    });

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      setState(() {
        _result = 'Success! UID: ${credential.user?.uid}';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _result = 'FirebaseAuthException:\nCode: ${e.code}\nMessage: ${e.message}\nPlugin: ${e.plugin}';
      });
    } catch (e) {
      setState(() {
        _result = 'General Error: $e';
      });
    }
  }

  Future<void> _testSignIn() async {
    setState(() {
      _result = 'Testing sign in...';
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      setState(() {
        _result = 'Success! UID: ${credential.user?.uid}';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _result = 'FirebaseAuthException:\nCode: ${e.code}\nMessage: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _result = 'General Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Auth Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'test@example.com',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'password123',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _testSignUp,
                  child: const Text('Test Sign Up'),
                ),
                ElevatedButton(
                  onPressed: _testSignIn,
                  child: const Text('Test Sign In'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _result,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}