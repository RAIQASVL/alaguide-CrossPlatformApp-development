import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/providers/auth_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAccountPage extends ConsumerStatefulWidget {
  const MyAccountPage({super.key});

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends ConsumerState<MyAccountPage> {
  final _formKey = GlobalKey<FormState>();

  late String? _firstName;
  late String? _lastName;
  late String? _email;
  File? _avatar;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider)!;
    _firstName = user.firstName;
    _lastName = user.lastName;
    _email = user.email;
    _avatar = user.avatarUrl != null ? File(user.avatarUrl!) : null;
  }

  Future<void> _pickImage() async {
    print('Pick image called'); // Debug message
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    } else {
      print('No image selected'); // Debug message
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedUser = ref.read(authProvider)!.copyWith(
            firstName: _firstName,
            lastName: _lastName,
            email: _email,
            avatarUrl: _avatar?.path,
          );

      ref.read(authProvider.notifier).updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated)),
      );
    }
  }

  void _logout() {
    ref.read(authProvider.notifier).clearUser();
    ref.read(authStateProvider.notifier).state = false;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.logoutSuccessfully)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myAccount),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatar != null
                        ? FileImage(_avatar!)
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 30),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _firstName,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.firstName,
                ),
                onSaved: (value) => _firstName = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _lastName,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.lastName,
                ),
                onSaved: (value) => _lastName = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                ),
                onSaved: (value) => _email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.email;
                  } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
                    return AppLocalizations.of(context)!.invalidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5AD1E5),
                ),
                child: Text(
                  AppLocalizations.of(context)!.saveChanges,
                  style: TextStyle(
                    color: isDarkMode ? Colors.black : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 44, 207, 196),
                ),
                child: Text(
                  AppLocalizations.of(context)!.logout,
                  style: TextStyle(
                    color: isDarkMode ? Colors.black : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
