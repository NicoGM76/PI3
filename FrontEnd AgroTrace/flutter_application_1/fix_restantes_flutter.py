from pathlib import Path
import re

def save(path: Path, text: str):
    path.write_text(text, encoding="utf-8", newline="")

# 1. lote_controller.dart
path = Path("lib/controller/lote/lote_controller.dart")
if path.exists():
    text = path.read_text(encoding="utf-8", errors="replace")
    text = re.sub(r"'Ma[^']*'", "'Maiz'", text)
    save(path, text)
    print("Corregido:", path)

# 2. app_validators.dart
path = Path("lib/core/utils/app_validators.dart")
if path.exists():
    text = path.read_text(encoding="utf-8", errors="replace")
    text = re.sub(r"return\s+'[^']*2 caracteres';", "return 'Minimo 2 caracteres';", text)
    text = re.sub(r"return\s+'[^']*8 caracteres';", "return 'Minimo 8 caracteres';", text)
    text = re.sub(r"return\s+'[^']*correo[^']*';", "return 'Ingresa un correo valido';", text)
    text = re.sub(r"return\s+'[^']*may[^']*scula[^']*';", "return 'Debe contener al menos una mayuscula';", text)
    text = re.sub(r"return\s+'[^']*numero[^']*';", "return 'Debe contener al menos un numero';", text)
    save(path, text)
    print("Corregido:", path)

# 3. login_screen.dart
path = Path("lib/view/auth/login_screen.dart")
if path.exists():
    text = path.read_text(encoding="utf-8", errors="replace")
    text = re.sub(r"text:\s*'Reg[^']*'", "text: 'Registrate'", text)
    save(path, text)
    print("Corregido:", path)

# 4. register_screen.dart
path = Path("lib/view/auth/register_screen.dart")
if path.exists():
    text = path.read_text(encoding="utf-8", errors="replace")
    text = re.sub(r"hint:\s*'Ej\. Mar[^']*'", "hint: 'Ej. Maria'", text)
    text = re.sub(r"hint:\s*'Ej\. G[^']*mez'", "hint: 'Ej. Gomez'", text)
    save(path, text)
    print("Corregido:", path)

# 5. merma_screen.dart
path = Path("lib/view/merma/merma_screen.dart")
if path.exists():
    text = path.read_text(encoding="utf-8", errors="replace")
    text = re.sub(r"'Vencimiento'\s*=>\s*'[^']*'", "'Vencimiento' => ''", text)
    text = re.sub(r"'Transporte'\s*=>\s*'[^']*'", "'Transporte' => ''", text)
    text = re.sub(r"'Clima'\s*=>\s*'[^']*'", "'Clima' => ''", text)
    save(path, text)
    print("Corregido:", path)

# 6. profile_screen.dart
path = Path("lib/view/profile/profile_screen.dart")
if path.exists():
    text = path.read_text(encoding="utf-8", errors="replace")
    text = re.sub(
        r"const Text\('[^']*seguro[^']*cerrar sesion\?'\)",
        "const Text('Estas seguro que deseas cerrar sesion?')",
        text
    )
    save(path, text)
    print("Corregido:", path)

# 7. agro_drawer.dart
path = Path("lib/view/widgets/agro_drawer.dart")
if path.exists():
    text = path.read_text(encoding="utf-8", errors="replace")
    text = re.sub(r"'Trazabilidad agr[^']*cola'", "'Trazabilidad agricola'", text)
    save(path, text)
    print("Corregido:", path)

print("Parche puntual terminado.")
