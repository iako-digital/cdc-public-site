import { z } from 'zod';

export const orderCreateSchema = z.object({
  enterprise: z.string().min(3).max(200),
  contactEmail: z.string().email(),
  courseIds: z.array(z.string().uuid()).min(1),
  quantity: z.number().min(1),
  totalPrice: z.number().int().min(0),
  status: z.enum(['Pending', 'Approved', 'Processing', 'Completed', 'Cancelled']).optional().default('Pending')
});

export const orderUpdateSchema = z.object({
  status: z.enum(['Pending', 'Approved', 'Processing', 'Completed', 'Cancelled'])
});
