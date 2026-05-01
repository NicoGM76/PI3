const service = require("./users.service");

exports.getMe = async (req, res) => {
  try {
    const user = await service.getMe(req.userId);
    res.json(user);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

exports.updateMe = async (req, res) => {
  try {
    const user = await service.updateMe(req.userId, req.body);
    res.json(user);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};