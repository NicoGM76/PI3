from pathlib import Path

ROOT = Path("lib")

REPLACEMENTS = {
    "devolviÃƒÂ³": "devolvio",
    "acciÃƒÂ³n": "accion",
    "estÃƒÂ¡": "esta",
    "mÃƒÂ¡s": "mas",
    "OcurriÃƒÂ³": "Ocurrio",
    "detecciÃƒÂ³n": "deteccion",
    "MaÃz": "Maiz",

    "MÃƒÂnimo": "Minimo",
    "vÃƒÂ¡lido": "valido",
    "vÃƒÂ¡lida": "valida",
    "mayÃƒÂºscula": "mayuscula",
    "nÃƒÂºmero": "numero",

    "Ãƒâ€šNo tienes cuenta? ": "No tienes cuenta? ",
    "Ãƒâ€šYa tienes cuenta? ": "Ya tienes cuenta? ",
    "RegÃƒÆ’Ã‚Âstrate": "Registrate",
    "MarÃƒÆ’Ã‚Âa": "Maria",
    "GÃƒÆ’Ã‚Â³mez": "Gomez",

    "GestiÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³n": "Gestion",
    "UbicaciÃƒÂ³n": "Ubicacion",
    "vÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡lida": "valida",
    "DaÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â±o": "Dano",

    "contraseÃƒÂ±a": "contrasena",
    "ContraseÃƒÂ±a": "Contrasena",
    "sesiÃƒÂ³n": "sesion",
    "SesiÃƒÂ³n": "Sesion",
    "TelÃƒÂ©fono": "Telefono",
    "Ã‚Â¿EstÃƒÂ¡s seguro que deseas cerrar sesiÃƒÂ³n?": "Estas seguro que deseas cerrar sesion?",

    "CÃƒÂ¡mara": "Camara",
    "FunciÃ³n": "Funcion",
    "GeneraciÃ³n": "Generacion",
    "CÃ³digo": "Codigo",
    "prÃ³ximamente": "proximamente",

    "Trazabilidad agrÃƒÆ’Ã‚Âcola": "Trazabilidad agricola",
    "Ãƒâ€šEstas seguro que deseas cerrar sesion?": "Estas seguro que deseas cerrar sesion?",

    "nÃƒÂºmero entero": "numero entero",
    "nÃƒÂºmero vÃƒÂ¡lido": "numero valido",

    "ÃƒÆ’Ã‚Â°Ãƒâ€¦Ã‚Â¸Ãƒâ€¦Ã¢â‚¬â„¢Ãƒâ€šÃ‚Â±": "",
    "ÃƒÆ’Ã‚Â¢Ãƒâ€šÃ‚ÂÃƒâ€šÃ‚Â°": "",
    "ÃƒÆ’Ã‚Â°Ãƒâ€¦Ã‚Â¸Ãƒâ€¦Ã‚Â¡Ãƒâ€¦Ã‚Â¡": "",
    "ÃƒÆ’Ã‚Â°Ãƒâ€¦Ã‚Â¸Ãƒâ€¦Ã¢â‚¬â„¢Ãƒâ€šÃ‚Â§ÃƒÆ’Ã‚Â¯Ãƒâ€šÃ‚Â¸Ãƒâ€šÃ‚Â": "",
}

changed = []

for path in ROOT.rglob("*.dart"):
    text = path.read_text(encoding="utf-8", errors="replace")
    original = text

    for old, new in REPLACEMENTS.items():
        text = text.replace(old, new)

    if text != original:
        path.write_text(text, encoding="utf-8", newline="")
        changed.append(str(path))

print("Archivos corregidos:")
for item in changed:
    print(" -", item)

print("Total:", len(changed))
