from pathlib import Path
import re

path = Path("lib/controller/home/home_controller.dart")
text = path.read_text(encoding="utf-8", errors="replace")

# Mantener AuthSession si ya existe.
if "auth_session.dart" not in text:
    text = text.replace(
        "import 'package:flutter/foundation.dart';",
        "import 'package:flutter/foundation.dart';\n\nimport '../../core/session/auth_session.dart';"
    )

# Quitar cualquier emoji corrupto en opciones del dashboard.
text = re.sub(r"emoji:\s*'[^']*'", "emoji: ''", text)

# Quitar iconos/símbolos del saludo si existen.
text = re.sub(
    r"String\s+get\s+greetingEmoji\s*=>\s*'[^']*';",
    "String get greetingEmoji => '';",
    text
)

text = re.sub(
    r"String\s+get\s+greetingIcon\s*=>\s*'[^']*';",
    "String get greetingIcon => '';",
    text
)

text = re.sub(
    r"String\s+get\s+iconoSaludo\s*=>\s*'[^']*';",
    "String get iconoSaludo => '';",
    text
)

# Si hay métodos que retornan emojis corruptos, devolver string vacío.
text = re.sub(r"return\s+'[^']*(?:ð|Ã|Â|â|�)[^']*';", "return '';", text)

# Asegurar que userName siga saliendo de AuthSession y no de Daniel.
text = re.sub(
    r"final\s+String\s+_userName\s*=\s*'[^']*';[^\n]*\n\s*String\s+get\s+userName\s*=>\s*_userName;",
    "String get userName {\n    final user = AuthSession.instance.currentUser;\n    if (user != null && user.firstName.isNotEmpty) {\n      return user.firstName;\n    }\n    return 'Usuario';\n  }",
    text
)

text = re.sub(
    r"String\s+get\s+userName\s*=>\s*'[^']*';",
    "String get userName {\n    final user = AuthSession.instance.currentUser;\n    if (user != null && user.firstName.isNotEmpty) {\n      return user.firstName;\n    }\n    return 'Usuario';\n  }",
    text
)

# Corregir nombres visibles si quedaron raros.
replacements = {
    "Mermas": "Merma",
    "Codigo QR": "Generar QR",
    "Consultar trazabilidad por codigo QR": "Escanear QR",
}

for old, new in replacements.items():
    text = text.replace(old, new)

path.write_text(text, encoding="utf-8", newline="")
print("home_controller.dart limpiado visualmente sin romper AuthSession")
