import { z } from 'zod';

export const registerSchema = z.object({
  name: z.string().min(2).max(120),
  email: z.string().email(),
  password: z.string().min(8).max(128),
  // role სპეციალურად ამოღებულია — საჯარო რეგისტრაცია ყოველთვის სტუდენტია
});

export const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).max(128),
});

// Requires ONE of: the user's current password, or the literal text "DELETE"
// — matches the two confirmation methods offered in the frontend modal.
export const deleteAccountSchema = z
  .object({
    password: z.string().min(1).optional(),
    confirmText: z.string().optional(),
  })
  .refine((data) => !!data.password || data.confirmText === 'DELETE', {
    message: 'Provide your current password or type DELETE to confirm.',
  });

export const verifyEmailSchema = z.object({
  token: z.string().min(1),
});

export const googleAuthSchema = z.object({
  idToken: z.string().min(1),
});