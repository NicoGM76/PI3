const service = require("./empaque.service");

exports.create = async (req, res) => {
  const data = await service.create(req.body);
  res.json(data);
};