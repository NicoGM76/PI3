const service = require("./lote.service");

exports.create = async (req, res) => {
  try {
    const lote = await service.create(req.body, req.userId);
    res.json(lote);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

exports.getAll = async (req, res) => {
  const lotes = await service.getAll(req.userId);
  res.json(lotes);
};