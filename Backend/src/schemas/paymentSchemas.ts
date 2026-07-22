import { z } from 'zod';

export const checkoutMentorshipSchema = z.object({
  mentorId: z.string().uuid(),
  amount: z.number().int().positive(),
  currency: z.enum(['GEL', 'USD', 'EUR', 'GBP']).default('GEL'),
  note: z.string().trim().max(500).optional(),
});
