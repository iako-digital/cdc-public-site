import { Request, Response, NextFunction } from 'express';

export function errorHandler(err: any, req: Request, res: Response, next: NextFunction) {
  console.error(err);
  const status = err.status || 500;
  // Only errors that explicitly set `.status` are intentional, safe-to-show
  // application errors. Anything else (e.g. a raw Prisma/db error) falls back
  // to a generic message — its real content (file paths, internals) still
  // reaches the server log above, just not the client response.
  const message = err.status ? err.message : 'Server error';
  res.status(status).json({ message, details: err.details ?? undefined });
}
