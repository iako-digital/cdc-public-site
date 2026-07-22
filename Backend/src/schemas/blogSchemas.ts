import { z } from 'zod';

export const blogPostCreateSchema = z.object({
  title: z.string().min(3).max(200),
  description: z.string().min(10).max(500),
  category: z.string().min(2).max(100),
  content: z.string().min(20),
  imageUrl: z.string().url().optional().or(z.literal('')),
  published: z.boolean().optional().default(true),
});

export const blogPostUpdateSchema = blogPostCreateSchema.partial();
