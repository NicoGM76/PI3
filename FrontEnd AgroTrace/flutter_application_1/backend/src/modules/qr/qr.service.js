const prisma = require("../../config/prisma");

exports.create = async (data) => {
  // validar que exista referencia
  const inventario = await prisma.inventario.findUnique({
    where: { id: data.referenciaId }
  });

  if (!inventario) {
    throw new Error("Referencia no válida");
  }

  return prisma.qR.create({
    data: {
      codigo: data.codigo,
      tipo: data.tipo,
      referenciaId: data.referenciaId
    }
  });
};

exports.getAll = () => {
  return prisma.qR.findMany();
};