import { z } from 'zod';

export const createDirectOfferSchema = z.object({
  freelancerId: z.string().uuid(),
  // Optional link to one of the client's own open gigs — a "quick custom
  // offer" omits this and just carries its own title/description/budget.
  gigId: z.string().uuid().optional(),
  title: z.string().trim().min(5, 'Title must be at least 5 characters.').max(150),
  description: z.string().trim().min(20, 'Description must be at least 20 characters.').max(5000),
  budgetAmount: z.number().int('Budget must be a whole number of minor units.').positive(),
  currency: z.string().length(3).toUpperCase(),
  message: z.string().trim().min(10, 'Message must be at least 10 characters.').max(2000),
});
