import { z } from 'zod';
export const postVacancySchema = z.object({
  title: z.string().trim().min(5, 'Title must be at least 5 characters.').max(150),
  description: z.string().trim().min(20, 'Description must be at least 20 characters.').max(5000),
  employmentType: z.enum(['full_time', 'part_time', 'contract', 'internship']),
  location: z.string().trim().min(1, 'Location is required.'),
  skillsRequired: z.array(z.string().trim().min(1)).min(1, 'At least one skill is required.'),
  salaryMin: z.number().int().positive().nullable().optional(),
  salaryMax: z.number().int().positive().nullable().optional(),
  currency: z.string().length(3).toUpperCase().nullable().optional(),
  applicationDeadline: z.string().datetime().nullable().optional(),
}).refine(
  (data) => !data.salaryMin || !data.salaryMax || data.salaryMin <= data.salaryMax,
  { message: 'Maximum salary must be greater than or equal to minimum salary.', path: ['salaryMax'] }
);
export const applyToVacancySchema = z.object({
  coverNote: z.string().trim().min(10, 'Cover note must be at least 10 characters.').max(3000),
});
export const reviewVacancyApplicationSchema = z.object({
  decision: z.enum(['accepted', 'rejected']),
});
