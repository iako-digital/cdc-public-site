import { Router, Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { authenticate, requireApproved } from '../middleware/auth';
import { sendMessageSchema } from '../schemas/messageSchemas';
import { sanitizeChatMessage } from '../utils/sanitizeChatMessage';

const router = Router();
const participantSelect = { select: { id: true, name: true, role: true } };

router.post('/', authenticate, requireApproved, async (req: Request, res: Response) => {
  const result = sendMessageSchema.safeParse(req.body);
  if (!result.success) return res.status(400).json({ errors: result.error.errors });
  const { recipientId, content } = result.data;

  if (recipientId === req.user!.id) {
    return res.status(400).json({ message: 'You cannot message yourself.' });
  }
  const recipient = await prisma.user.findUnique({ where: { id: recipientId } });
  if (!recipient) {
    return res.status(404).json({ message: 'Recipient not found.' });
  }

  const { sanitized, wasFiltered } = sanitizeChatMessage(content);

  const message = await prisma.message.create({
    data: {
      senderId: req.user!.id,
      recipientId,
      content: sanitized,
      wasFiltered,
    },
    include: { sender: participantSelect, recipient: participantSelect },
  });
  res.status(201).json({ data: message });
});

router.get('/:otherUserId', authenticate, async (req: Request, res: Response) => {
  const { otherUserId } = req.params;
  const messages = await prisma.message.findMany({
    where: {
      OR: [
        { senderId: req.user!.id, recipientId: otherUserId },
        { senderId: otherUserId, recipientId: req.user!.id },
      ],
    },
    include: { sender: participantSelect, recipient: participantSelect },
    orderBy: { createdAt: 'asc' },
  });
  res.json({ data: messages });
});

export default router;
