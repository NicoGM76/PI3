const router = require("express").Router();
const controller = require("./inventario.controller");

router.post("/", controller.create);
router.get("/", controller.getAll);

module.exports = router;