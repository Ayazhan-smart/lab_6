import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  bool _hidePass = true;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final List<String> _countries = ['Kazakhstan','Russia', 'Ukraine', 'Germany', 'France', 'Turkey', 'USA', ];
   String _selectedCountry = 'Kazakhstan';

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();

    super.dispose();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(60), 
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple[200],
          border: Border(
            bottom: BorderSide(
              color: Colors.purple[400]!,
              width: 2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'Register Form',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [

        TextFormField(
  focusNode: _nameFocus,
  autofocus: true,
  onFieldSubmitted: (_) {
    _fieldFocusChange(context, _nameFocus, _phoneFocus);
  },
  controller: _nameController,
  decoration: InputDecoration(
    labelText: 'Full Name *',
    hintText: 'What do people call you?',
    prefixIcon: const Icon(Icons.person),
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear, color: Colors.red),
      onPressed: () => _nameController.clear(),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  validator: validateName,
),
const SizedBox(height: 10),

TextFormField(
  controller: _dobController,
  decoration: InputDecoration(
    labelText: 'Date of Birth *',
    hintText: 'DD/MM/YYYY',
    prefixIcon: const Icon(Icons.calendar_today),
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear, color: Colors.red),
      onPressed: () => _dobController.clear(),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  onTap: () async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  },
),
const SizedBox(height: 10),

TextFormField(
  focusNode: _phoneFocus,
  onFieldSubmitted: (_) {
    _fieldFocusChange(context, _phoneFocus, _passFocus);
  },
  controller: _phoneController,
  decoration: InputDecoration(
    labelText: 'Phone Number *',
    hintText: '(XXX)XXX-XXXX',
    prefixIcon: const Icon(Icons.call),
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear, color: Colors.red),
      onPressed: () => _phoneController.clear(),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  keyboardType: TextInputType.phone,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^[()\d -]{1,15}$')),
  ],
  validator: (value) => validatePhoneNumber(value!)
      ? null
      : 'Phone number must be (###)###-####',
),
const SizedBox(height: 10),

TextFormField(
  controller: _emailController,
  decoration: InputDecoration(
    labelText: 'Email Address *',
    hintText: 'Enter your email',
    prefixIcon: const Icon(Icons.mail),
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear, color: Colors.red),
      onPressed: () => _emailController.clear(),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  keyboardType: TextInputType.emailAddress,
),
const SizedBox(height: 10),

DropdownButtonFormField(
  decoration: InputDecoration(
    labelText: 'Country *',
    prefixIcon: const Icon(Icons.map),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  items: _countries.map((country) {
    return DropdownMenuItem(
      value: country,
      child: Text(country),
    );
  }).toList(),
  onChanged: (country) {
    setState(() {
      _selectedCountry = country as String;
    });
  },
  value: _selectedCountry,
),
const SizedBox(height: 20),

TextFormField(
  focusNode: _passFocus,
  controller: _passController,
  obscureText: _hidePass,
  decoration: InputDecoration(
    labelText: 'Password *',
    hintText: 'Enter your password',
    prefixIcon: const Icon(Icons.security),
    suffixIcon: IconButton(
      icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
      onPressed: () {
        setState(() {
          _hidePass = !_hidePass;
        });
      },
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  validator: _validatePassword,
),
const SizedBox(height: 10),

TextFormField(
  controller: _confirmPassController,
  obscureText: _hidePass,
  decoration: InputDecoration(
    labelText: 'Confirm Password *',
    hintText: 'Confirm your password',
    prefixIcon: const Icon(Icons.lock),
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear, color: Colors.red),
      onPressed: () => _confirmPassController.clear(),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  validator: _validatePassword,
),
const SizedBox(height: 15),

              ElevatedButton(
  onPressed: _submitForm,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    textStyle: const TextStyle(color: Colors.white),
  ),
  child: const Text(
    'Register Form', 
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
),

          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Name: ${_nameController.text}');
      print('Date of Birth: ${_dobController.text}');
      print('Phone: ${_phoneController.text}');
      print('Email: ${_emailController.text}');
      print('Country: $_selectedCountry');
    } else {
      _showMessage(message: 'Form is not valid! Please review and correct');
    }
  }

  String? validateName(String? value) {
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (value == null) {
      return 'Name is reqired.';
    } else if (!nameExp.hasMatch(value)) {
      return 'Please enter alphabetical characters.';
    } else {
      return null;
    }
  }

   String? validateDateOfBirth(String? value) {
  final dateExp = RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$');
  if (value == null || value.isEmpty) {
    return 'Date of Birth is required.';
  } else if (!dateExp.hasMatch(value)) {
    return 'Enter date as DD/MM/YYYY.';
  } else {
    return null;
  }
}

  bool validatePhoneNumber(String input) {
    final phoneExp = RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return phoneExp.hasMatch(input);
  }

  String? validateEmail(String? value) {
    if (value == null) {
      return 'Email cannot be empty';
    } else if (!_emailController.text.contains('@')) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (_passController.text.length != 8) {
      return '8 character required for password';
    } else if (_confirmPassController.text != _passController.text) {
      return 'Password does not match';
    } else {
      return null;
    }
  }

  void _showMessage({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}      