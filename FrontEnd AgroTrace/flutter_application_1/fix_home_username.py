from pathlib import Path

path = Path("lib/controller/home/home_controller.dart")
text = path.read_text(encoding="utf-8", errors="replace")

# Asegurar import de AuthSession
if "auth_session.dart" not in text:
    text = text.replace(
        "import 'package:flutter/foundation.dart';",
        "import 'package:flutter/foundation.dart';\n\nimport '../../core/session/auth_session.dart';"
    )

lines = text.splitlines()
new_lines = []
inserted_getter = False

for line in lines:
    # Eliminar variable quemada de Daniel
    if "final String _userName" in line:
        if not inserted_getter:
            new_lines.append("  String get userName {")
            new_lines.append("    final user = AuthSession.instance.currentUser;")
            new_lines.append("    if (user != null && user.firstName.isNotEmpty) {")
            new_lines.append("      return user.firstName;")
            new_lines.append("    }")
            new_lines.append("    return 'Usuario';")
            new_lines.append("  }")
            inserted_getter = True
        continue

    # Eliminar getter viejo que devolvia _userName
    if "String get userName => _userName" in line:
        continue

    new_lines.append(line)

# Si por alguna razon no existia el bloque viejo, insertar el getter dentro de HomeController
if not inserted_getter:
    final_text = "\n".join(new_lines)
    marker = "class HomeController extends ChangeNotifier {"
    final_text = final_text.replace(
        marker,
        marker + "\n  String get userName {\n    final user = AuthSession.instance.currentUser;\n    if (user != null && user.firstName.isNotEmpty) {\n      return user.firstName;\n    }\n    return 'Usuario';\n  }\n"
    )
else:
    final_text = "\n".join(new_lines)

path.write_text(final_text + "\n", encoding="utf-8", newline="")
print("home_controller.dart actualizado: Daniel eliminado y userName usa AuthSession")
