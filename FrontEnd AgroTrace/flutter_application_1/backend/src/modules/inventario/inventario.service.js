const prisma = require("../../config/prisma");

exports.create = async (data) => {
  return prisma.inventario.create({
    data: {
      cantidad: data.cantidad,
      loteId: data.loteId
    }
  });
};

exports.getAll = () => {
  return prisma.inventario.findMany({
    include: {
      lote: true
    }
  });
};

exports.getById = (id) => {
  return prisma.inventario.findUnique({
    where: { id },
    include: { lote: true }
  });
};

exports.updateStock = (id, nuevaCantidad) => {
  return prisma.inventario.update({
    where: { id },
    data: { cantidad: nuevaCantidad }
  });
};