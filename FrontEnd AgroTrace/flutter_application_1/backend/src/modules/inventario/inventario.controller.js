const service = require("./inventario.service");

exports.create = async (req, res) => {
  const data = await service.create(req.body);
  res.json(data);
};

exports.getAll = async (req, res) => {
  const data = await service.getAll();
  res.json(data);
};