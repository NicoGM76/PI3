const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

// rutas
app.use("/api/auth", require("./modules/auth/auth.routes"));
app.use("/api/lotes", require("./modules/lote/lote.routes"));
app.use("/api/inventario", require("./modules/inventario/inventario.routes"));
app.use("/api/empaque", require("./modules/empaque/empaque.routes"));
app.use("/api/merma", require("./modules/merma/merma.routes"));
app.use("/api/salida", require("./modules/salida/salida.routes"));
app.use("/api/qr", require("./modules/qr/qr.routes"));
app.use("/api/users", require("./modules/users/users.routes"));

module.exports = app;