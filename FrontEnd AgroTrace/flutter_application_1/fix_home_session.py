from pathlib import Path
import re

path = Path("lib/controller/home/home_controller.dart")
text = path.read_text(encoding="utf-8", errors="replace")

if "auth_session.dart" not in text:
    text = text.replace(
        "import 'package:flutter/foundation.dart';",
        "import 'package:flutter/foundation.dart';\n\nimport '../../core/session/auth_session.dart';"
    )

# Reemplaza cualquier getter userName quemado.
text = re.sub(
    r"String\s+get\s+userName\s*=>\s*'[^']*';",
    "String get userName => AuthSession.instance.currentUser?.firstName.isNotEmpty == true ? AuthSession.instance.currentUser!.firstName : 'Usuario';",
    text
)

# Reemplaza variable userName quemada si existe.
text = re.sub(
    r"final\s+String\s+userName\s*=\s*'[^']*';",
    "String get userName => AuthSession.instance.currentUser?.firstName.isNotEmpty == true ? AuthSession.instance.currentUser!.firstName : 'Usuario';",
    text
)

text = re.sub(
    r"String\s+userName\s*=\s*'[^']*';",
    "String get userName => AuthSession.instance.currentUser?.firstName.isNotEmpty == true ? AuthSession.instance.currentUser!.firstName : 'Usuario';",
    text
)

# Por si aparece Daniel directo en el greeting.
text = text.replace("Buenas noches, Daniel", "Buenas noches, ${userName}")
text = text.replace("Buenas tardes, Daniel", "Buenas tardes, ${userName}")
text = text.replace("Buenos dias, Daniel", "Buenos dias, ${userName}")

path.write_text(text, encoding="utf-8", newline="")
print("home_controller.dart actualizado para usar AuthSession")
