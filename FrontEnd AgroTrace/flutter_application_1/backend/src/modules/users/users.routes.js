const router = require("express").Router();
const controller = require("./users.controller");
const auth = require("../../middlewares/auth.middleware");

// Obtener perfil del usuario logueado
router.get("/me", auth, controller.getMe);

// Actualizar perfil
router.put("/me", auth, controller.updateMe);

module.exports = router;    