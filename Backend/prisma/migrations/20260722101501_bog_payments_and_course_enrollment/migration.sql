/*
  Warnings:

  - You are about to drop the column `merchantId` on the `bog_settings` table. All the data in the column will be lost.
  - You are about to drop the column `publicKey` on the `bog_settings` table. All the data in the column will be lost.
  - You are about to drop the column `webhookSecret` on the `bog_settings` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "BogPaymentPurpose" AS ENUM ('COURSE', 'MENTORSHIP', 'GIG_ESCROW_FUNDING');

-- CreateEnum
CREATE TYPE "BogPaymentStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED');

-- AlterTable
ALTER TABLE "bog_settings" DROP COLUMN "merchantId",
DROP COLUMN "publicKey",
DROP COLUMN "webhookSecret",
ADD COLUMN     "clientId" TEXT;

-- CreateTable
CREATE TABLE "course_enrollments" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "grantedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "course_enrollments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bog_payments" (
    "id" TEXT NOT NULL,
    "bogOrderId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "purpose" "BogPaymentPurpose" NOT NULL,
    "referenceId" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "currency" CHAR(3) NOT NULL,
    "status" "BogPaymentStatus" NOT NULL DEFAULT 'PENDING',
    "redirectUrl" TEXT,
    "rawCallback" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "bog_payments_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "course_enrollments_userId_courseId_key" ON "course_enrollments"("userId", "courseId");

-- CreateIndex
CREATE UNIQUE INDEX "bog_payments_bogOrderId_key" ON "bog_payments"("bogOrderId");

-- CreateIndex
CREATE INDEX "bog_payments_userId_idx" ON "bog_payments"("userId");

-- CreateIndex
CREATE INDEX "bog_payments_purpose_referenceId_idx" ON "bog_payments"("purpose", "referenceId");

-- AddForeignKey
ALTER TABLE "course_enrollments" ADD CONSTRAINT "course_enrollments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_enrollments" ADD CONSTRAINT "course_enrollments_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "courses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bog_payments" ADD CONSTRAINT "bog_payments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
