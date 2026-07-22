import { z } from 'zod';

export const postGigSchema = z.object({
  title: z.string().trim().min(5, 'Title must be at least 5 characters.').max(150),
  description: z.string().trim().min(20, 'Description must be at least 20 characters.').max(5000),
  budgetType: z.enum(['fixed', 'hourly']),
  budgetAmount: z.number().int('Budget must be a whole number of minor units.').positive(),
  currency: z.string().length(3).toUpperCase(),
  skillsRequired: z.array(z.string().trim().min(1)).min(1, 'At least one skill is required.'),
  deadline: z.string().datetime().nullable().optional(),
});

export const applyToGigSchema = z.object({
  proposalNote: z.string().trim().min(10, 'Proposal must be at least 10 characters.').max(3000),
  bidAmount: z.number().int('Bid must be a whole number of minor units.').positive(),
  deliveryDays: z.number().int('Delivery timeframe must be a whole number of days.').positive().max(365),
});

export const submitGigWorkSchema = z.object({
  comment: z.string().trim().min(10, 'Comment must be at least 10 characters.').max(3000),
  files: z.array(z.string().url()).max(10).optional().default([]),
  links: z.array(z.string().url()).max(10).optional().default([]),
});