import { Router, Request, Response } from 'express';
import { CRON_SECRET } from '../utils/env';
import { autoApproveOverdueGigs } from '../services/gigApprovalService';
import { cleanupExpiredDeletedAccounts } from '../services/accountCleanupService';

const router = Router();

// No JWT here on purpose — this is called by an external scheduler (Azure
// Logic App / GitHub Actions cron / cron-job.org), not a logged-in user.
// Auth is a shared secret header instead, same shape as a webhook.
function requireCronSecret(req: Request, res: Response, next: () => void) {
  const provided = req.headers['x-cron-secret'];
  if (provided !== CRON_SECRET) {
    return res.status(401).json({ message: 'Invalid or missing cron secret.' });
  }
  next();
}

router.post('/auto-approve', requireCronSecret, async (_req: Request, res: Response) => {
  const result = await autoApproveOverdueGigs();
  res.json({
    message: `Auto-approved ${result.processedGigIds.length} gig(s) submitted more than 7 days ago.`,
    ...result,
  });
});

router.post('/cleanup-deleted-accounts', requireCronSecret, async (_req: Request, res: Response) => {
  const result = await cleanupExpiredDeletedAccounts();
  res.json({
    message: `Cleaned up ${result.hardDeletedUserIds.length + result.anonymizedUserIds.length} account(s) deleted more than 60 days ago (${result.hardDeletedUserIds.length} hard-deleted, ${result.anonymizedUserIds.length} anonymized).`,
    ...result,
  });
});

export default router;
