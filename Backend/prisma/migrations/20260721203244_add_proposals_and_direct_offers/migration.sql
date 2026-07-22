-- CreateEnum
CREATE TYPE "DirectOfferStatus" AS ENUM ('pending', 'accepted', 'declined', 'withdrawn');

-- AlterTable
ALTER TABLE "gig_applications" ADD COLUMN     "deliveryDays" INTEGER NOT NULL DEFAULT 7;

-- AlterTable
ALTER TABLE "gigs" ADD COLUMN     "applicationsCount" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "direct_offers" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "freelancerId" TEXT NOT NULL,
    "gigId" TEXT,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "budgetAmount" INTEGER NOT NULL,
    "currency" CHAR(3) NOT NULL,
    "message" TEXT NOT NULL,
    "status" "DirectOfferStatus" NOT NULL DEFAULT 'pending',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "direct_offers_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "direct_offers_freelancerId_idx" ON "direct_offers"("freelancerId");

-- CreateIndex
CREATE INDEX "direct_offers_clientId_idx" ON "direct_offers"("clientId");

-- AddForeignKey
ALTER TABLE "direct_offers" ADD CONSTRAINT "direct_offers_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "direct_offers" ADD CONSTRAINT "direct_offers_freelancerId_fkey" FOREIGN KEY ("freelancerId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "direct_offers" ADD CONSTRAINT "direct_offers_gigId_fkey" FOREIGN KEY ("gigId") REFERENCES "gigs"("id") ON DELETE SET NULL ON UPDATE CASCADE;
