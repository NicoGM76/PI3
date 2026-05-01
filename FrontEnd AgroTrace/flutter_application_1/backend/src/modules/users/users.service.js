const prisma = require("../../config/prisma");

exports.getMe = (userId) => {
  return prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      name: true,
      email: true
    }
  });
};

exports.updateMe = (userId, data) => {
  return prisma.user.update({
    where: { id: userId },
    data: {
      name: data.name,
      email: data.email
    }
  });
};