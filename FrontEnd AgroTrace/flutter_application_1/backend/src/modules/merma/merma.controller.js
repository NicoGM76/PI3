const service = require("./merma.service");

exports.create = async (req, res) => {
  try {
    const data = await service.create(req.body);
    res.json(data);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

exports.getAll = async (req, res) => {
  const data = await service.getAll();
  res.json(data);
};