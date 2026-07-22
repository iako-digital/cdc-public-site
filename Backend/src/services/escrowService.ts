import { prisma } from '../lib/prisma';
// Kept in sync with the 10% shown in the frontend Proposal Calculator (ProposalModal.tsx).
const PLATFORM_COMMISSION_RATE = 0.1;
export async function captureEscrow(params: {
  gigId: string;
  gigApplicationId: string;
  clientId: string;
  freelancerId: string;
  grossAmount: number;
  currency: string;
  providerRef: string;
}) {
  const commissionAmount = Math.round(params.grossAmount * PLATFORM_COMMISSION_RATE);
  const netAmount = params.grossAmount - commissionAmount;
  return prisma.gigTransaction.create({
    data: {
      gigId: params.gigId,
      gigApplicationId: params.gigApplicationId,
      clientId: params.clientId,
      freelancerId: params.freelancerId,
      grossAmount: params.grossAmount,
      currency: params.currency,
      providerRef: params.providerRef,
      commissionRate: PLATFORM_COMMISSION_RATE,
      commissionAmount,
      netAmount,
      status: 'HELD_IN_ESCROW',
      capturedAt: new Date(),
    },
  });
}
export async function releaseEscrow(gigId: string) {
  return prisma.$transaction(async (tx) => {
    const transaction = await tx.gigTransaction.findUnique({ where: { gigId } });
    if (!transaction) throw new Error('No escrow transaction found for this gig.');
    if (transaction.status !== 'HELD_IN_ESCROW') {
      throw new Error('Funds are not currently held in escrow.');
    }
    const updatedTransaction = await tx.gigTransaction.update({
      where: { id: transaction.id },
      data: { status: 'RELEASED', releasedAt: new Date() },
    });
    const freelancer = await tx.user.findUnique({ where: { id: transaction.freelancerId } });
    if (!freelancer) throw new Error('Freelancer account not found.');
    const newBalance = freelancer.earningsBalance + transaction.netAmount;
    await tx.user.update({
      where: { id: freelancer.id },
      data: { earningsBalance: newBalance },
    });
    await tx.walletEntry.create({
      data: {
        userId: freelancer.id,
        type: 'ESCROW_RELEASE_CREDIT',
        amount: transaction.netAmount,
        relatedGigTransactionId: transaction.id,
        balanceAfter: newBalance,
      },
    });
    await tx.gig.update({
      where: { id: gigId },
      data: { status: 'completed' },
    });
    return updatedTransaction;
  });
}
