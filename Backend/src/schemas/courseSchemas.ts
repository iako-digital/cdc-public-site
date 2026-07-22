import { z } from 'zod';

export const lessonSchema = z.object({
  title: z.string().min(3).max(200),
  content: z.string().min(10),
  durationMinutes: z.number().min(1),
  resources: z.array(z.string().url()).optional()
});

export const courseCreateSchema = z.object({
  title: z.string().min(3).max(200),
  description: z.string().min(20),
  category: z.string().min(2).max(100),
  lessons: z.array(lessonSchema).min(1),
  price: z.number().int().min(0),
  published: z.boolean().optional().default(false)
});

export const courseUpdateSchema = courseCreateSchema.partial().extend({
  published: z.boolean().optional()
});
