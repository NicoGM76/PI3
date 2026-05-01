const router = require("express").Router();
const controller = require("./lote.controller");
const auth = require("../../middlewares/auth.middleware");

router.post("/", auth, controller.create);
router.get("/", auth, controller.getAll);

module.exports = router;