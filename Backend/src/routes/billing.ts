import { Router, Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { authenticate } from '../middleware/auth';

const router = Router();

router.get('/payment-methods', authenticate, async (req: Request, res: Response) => {
  const methods = await prisma.paymentMethod.findMany({
    where: { userId: req.user!.id },
    orderBy: { createdAt: 'desc' },
  });
  res.json(methods);
});

router.delete('/payment-methods/:id', authenticate, async (req: Request, res: Response) => {
  const method = await prisma.paymentMethod.findUnique({ where: { id: req.params.id } });
  if (!method || method.userId !== req.user!.id) {
    return res.status(404).json({ message: 'Payment method not found.' });
  }
  await prisma.paymentMethod.delete({ where: { id: method.id } });
  res.status(204).send();
});

export default router;
