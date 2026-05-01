const prisma = require("../../config/prisma");

exports.create = async (data, userId) => {
  return await prisma.lote.create({
    data: {
      nombre: data.nombre,
      userId: userId,
    },
  });
};

exports.getAll = async (userId) => {
  return await prisma.lote.findMany({
    where: { userId },
  });
};