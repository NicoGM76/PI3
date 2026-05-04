from pathlib import Path

replacements = {
    "TelÃ©fono": "Telefono",
    "TelÃƒÂ©fono": "Telefono",
    "contraseÃ±a": "contrasena",
    "ContraseÃ±a": "Contrasena",
    "contraseÃƒÂ±a": "contrasena",
    "ContraseÃƒÂ±a": "Contrasena",
    "sesiÃ³n": "sesion",
    "SesiÃ³n": "Sesion",
    "sesiÃƒÂ³n": "sesion",
    "SesiÃƒÂ³n": "Sesion",
    "Â¿No tienes cuenta? ": "No tienes cuenta? ",
    "Â¿Ya tienes cuenta? ": "Ya tienes cuenta? ",
    "RegÃstrate": "Registrate",
    "RegÃƒÆ’Ã‚Âstrate": "Registrate",
    "MarÃa": "Maria",
    "GÃ³mez": "Gomez",
    "MÃnimo": "Minimo",
    "MÃƒÂnimo": "Minimo",
    "vÃ¡lido": "valido",
    "vÃƒÂ¡lido": "valido",
    "vÃ¡lida": "valida",
    "vÃƒÂ¡lida": "valida",
    "mayÃºscula": "mayuscula",
    "mayÃƒÂºscula": "mayuscula",
    "nÃºmero": "numero",
    "nÃƒÂºmero": "numero",
    "GestiÃƒÂ³n del Lote": "Gestion del Lote",
    "CÃƒÂ¡mara": "Camara",
    "FunciÃ³n compartir prÃ³ximamente": "Funcion compartir proximamente",
    "GeneraciÃ³n QR": "Generacion QR",
    "CÃ³digo QR generado": "Codigo QR generado",
    "Trazabilidad agrÃƒÆ’Ã‚Âcola": "Trazabilidad agricola",
    "Ãƒâ€šEstas seguro que deseas cerrar sesion?": "Estas seguro que deseas cerrar sesion?",
    "Â¿EstÃ¡s seguro que deseas cerrar sesion?": "Estas seguro que deseas cerrar sesion?",
}

targets = [
    Path("lib/core/utils/app_validators.dart"),
    Path("lib/view/auth/login_screen.dart"),
    Path("lib/view/auth/register_screen.dart"),
    Path("lib/view/profile/profile_screen.dart"),
    Path("lib/view/qr/escanear_qr_screen.dart"),
    Path("lib/view/qr/generacion_qr_screen.dart"),
    Path("lib/view/salida/salida_screen.dart"),
    Path("lib/view/empaque/empaque_screen.dart"),
    Path("lib/view/inventario/inventario_screen.dart"),
    Path("lib/view/widgets/agro_drawer.dart"),
]

for path in targets:
    if not path.exists():
        continue

    text = path.read_text(encoding="utf-8", errors="replace")
    original = text

    for old, new in replacements.items():
        text = text.replace(old, new)

    if text != original:
        path.write_text(text, encoding="utf-8", newline="")
        print("Corregido:", path)

print("Limpieza visual puntual terminada.")
