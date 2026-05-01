const router = require("express").Router();
const controller = require("./empaque.controller");

router.post("/", controller.create);

module.exports = router;