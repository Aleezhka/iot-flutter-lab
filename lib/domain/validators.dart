class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введіть ім\'я';
    }
    if (value.contains(RegExp(r'[0-9]'))) {
      return 'Ім\'я не може містити цифри';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введіть електронну пошту';
    }
    // Стандартний регулярний вираз для перевірки формату пошти
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Некоректний формат пошти';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введіть пароль';
    }
    if (value.length < 6) {
      return 'Пароль має містити мінімум 6 символів';
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Підтвердіть пароль';
    }
    if (value != originalPassword) {
      return 'Паролі не співпадають';
    }
    return null;
  }
}
