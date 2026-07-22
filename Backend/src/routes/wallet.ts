import { Router, Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { authenticate, requireRole } from '../middleware/auth';
const router = Router();
router.get('/me', authenticate, requireRole('Student'), async (req: Request, res: Response) => {
  const page = Math.max(1, parseInt(String(req.query.page ?? '1'), 10));
  const pageSize = Math.min(50, Math.max(1, parseInt(String(req.query.pageSize ?? '20'), 10)));
  const user = await prisma.user.findUnique({
    where: { id: req.user!.id },
    select: { earningsBalance: true },
  });
  if (!user) return res.status(404).json({ message: 'User not found.' });
  const [entries, totalCount] = await prisma.$transaction([
    prisma.walletEntry.findMany({
      where: { userId: req.user!.id },
      orderBy: { createdAt: 'desc' },
      skip: (page - 1) * pageSize,
      take: pageSize,
    }),
    prisma.walletEntry.count({ where: { userId: req.user!.id } }),
  ]);
  res.json({
    earningsBalance: user.earningsBalance,
    history: { items: entries, totalCount, page, pageSize },
  });
});
export default router;
