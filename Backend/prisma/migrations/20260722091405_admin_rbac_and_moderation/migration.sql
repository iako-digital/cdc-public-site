-- CreateEnum
CREATE TYPE "AdminRole" AS ENUM ('SUPER_ADMIN', 'ADMIN', 'MODERATOR');

-- CreateEnum
CREATE TYPE "ListingModerationStatus" AS ENUM ('approved', 'removed');

-- AlterTable
ALTER TABLE "gigs" ADD COLUMN     "moderatedAt" TIMESTAMP(3),
ADD COLUMN     "moderationReason" TEXT,
ADD COLUMN     "moderationStatus" "ListingModerationStatus" NOT NULL DEFAULT 'approved';

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "adminRole" "AdminRole",
ADD COLUMN     "banReason" TEXT,
ADD COLUMN     "bannedAt" TIMESTAMP(3),
ADD COLUMN     "isBanned" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "vacancies" ADD COLUMN     "moderatedAt" TIMESTAMP(3),
ADD COLUMN     "moderationReason" TEXT,
ADD COLUMN     "moderationStatus" "ListingModerationStatus" NOT NULL DEFAULT 'approved';

-- CreateIndex
CREATE INDEX "gigs_moderationStatus_idx" ON "gigs"("moderationStatus");

-- CreateIndex
CREATE INDEX "vacancies_moderationStatus_idx" ON "vacancies"("moderationStatus");
