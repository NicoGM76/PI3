const prisma = require("../../config/prisma");

exports.create = async (data) => {
  const inventario = await prisma.inventario.findUnique({
    where: { id: data.inventarioId }
  });

  if (!inventario) {
    throw new Error("Inventario no existe");
  }

  if (data.cantidad <= 0) {
    throw new Error("Cantidad inválida");
  }

  if (inventario.cantidad < data.cantidad) {
    throw new Error("Stock insuficiente para merma");
  }

  const nuevaCantidad = inventario.cantidad - data.cantidad;

  // 🔥 transacción
  return prisma.$transaction([
    prisma.merma.create({
      data: {
        cantidad: data.cantidad,
        motivo: data.motivo,
        inventarioId: data.inventarioId
      }
    }),
    prisma.inventario.update({
      where: { id: data.inventarioId },
      data: { cantidad: nuevaCantidad }
    })
  ]);
};

exports.getAll = () => {
  return prisma.merma.findMany({
    include: {
      inventario: {
        include: { lote: true }
      }
    }
  });
};