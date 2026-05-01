const router = require("express").Router();
const controller = require("./merma.controller");
const auth = require("../../middlewares/auth.middleware");

router.post("/", auth, controller.create);
router.get("/", auth, controller.getAll);

module.exports = router;