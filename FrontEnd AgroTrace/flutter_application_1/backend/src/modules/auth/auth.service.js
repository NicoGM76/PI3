const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const prisma = require("../../config/prisma");

exports.register = async ({ name, email, password }) => {
  const hash = await bcrypt.hash(password, 10);

  return prisma.user.create({
    data: { name, email, password: hash }
  });
};

exports.login = async ({ email, password }) => {
  const user = await prisma.user.findUnique({ where: { email } });

  if (!user) throw new Error("Usuario no existe");

  const valid = await bcrypt.compare(password, user.password);
  if (!valid) throw new Error("Password incorrecto");

  const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET);

  return { token, user };
};