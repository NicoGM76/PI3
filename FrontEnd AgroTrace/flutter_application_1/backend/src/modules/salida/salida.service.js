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
    throw new Error("Stock insuficiente");
  }

  const nuevaCantidad = inventario.cantidad - data.cantidad;

  return prisma.$transaction([
    prisma.salida.create({
      data: {
        destino: data.destino,
        cantidad: data.cantidad,
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
  return prisma.salida.findMany({
    include: {
      inventario: {
        include: { lote: true }
      }
    }
  });
};