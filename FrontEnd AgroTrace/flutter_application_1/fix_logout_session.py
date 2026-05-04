from pathlib import Path

files = [
    Path("lib/view/profile/profile_screen.dart"),
    Path("lib/view/widgets/agro_drawer.dart"),
]

for path in files:
    if not path.exists():
        continue

    text = path.read_text(encoding="utf-8", errors="replace")

    if "auth_session.dart" not in text:
        marker = "import '../../core/constants/app_text_styles.dart';"
        if marker in text:
            text = text.replace(
                marker,
                marker + "\nimport '../../core/session/auth_session.dart';"
            )
        else:
            # Para archivos con diferente profundidad, intentamos import relativo común.
            if "view/widgets" in str(path).replace("\\", "/"):
                text = text.replace(
                    "import 'package:flutter/material.dart';",
                    "import 'package:flutter/material.dart';\n\nimport '../../core/session/auth_session.dart';"
                )
            else:
                text = text.replace(
                    "import 'package:flutter/material.dart';",
                    "import 'package:flutter/material.dart';\n\nimport '../../core/session/auth_session.dart';"
                )

    if "AuthSession.instance.clear();" not in text:
        text = text.replace(
            "context.read<ProfileController>().limpiar();",
            "AuthSession.instance.clear();\n              context.read<ProfileController>().limpiar();"
        )

    path.write_text(text, encoding="utf-8", newline="")
    print("Actualizado:", path)
