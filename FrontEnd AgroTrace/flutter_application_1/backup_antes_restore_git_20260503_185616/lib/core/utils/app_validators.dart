class AppValidators {
  AppValidators._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.trim().length < 2) {
      return 'Minimo 2 caracteres';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa un correo valido';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Ingresa un correo valido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La Contrasena es obligatoria';
    }
    if (value.length < 8) {
      return 'Minimo 8 caracteres';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Debe contener al menos una mayuscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Debe contener al menos un numero';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu Contrasena';
    }
    if (value != password) {
      return 'Las Contrasenas no coinciden';
    }
    return null;
  }
}