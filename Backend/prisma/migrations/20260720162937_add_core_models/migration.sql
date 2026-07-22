-- CreateEnum
CREATE TYPE "Role" AS ENUM ('Student', 'Mentor', 'SuperAdmin', 'EnterpriseClient');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('PENDING_APPROVAL', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "GigBudgetType" AS ENUM ('fixed', 'hourly');

-- CreateEnum
CREATE TYPE "GigStatus" AS ENUM ('open', 'assigned', 'submitted', 'completed', 'cancelled');

-- CreateEnum
CREATE TYPE "ApplicationStatus" AS ENUM ('submitted', 'reviewed', 'accepted', 'rejected');

-- CreateEnum
CREATE TYPE "EscrowStatus" AS ENUM ('HELD_IN_ESCROW', 'RELEASED', 'REFUNDED', 'DISPUTED');

-- CreateEnum
CREATE TYPE "WalletEntryType" AS ENUM ('ESCROW_RELEASE_CREDIT', 'PAYOUT_DEBIT', 'ADJUSTMENT');

-- CreateEnum
CREATE TYPE "EmploymentType" AS ENUM ('full_time', 'part_time', 'contract', 'internship');

-- CreateEnum
CREATE TYPE "VacancyStatus" AS ENUM ('open', 'closed', 'filled');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'Student',
    "status" "UserStatus" NOT NULL DEFAULT 'PENDING_APPROVAL',
    "rejectionReason" TEXT,
    "earningsBalance" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gigs" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "postedById" TEXT NOT NULL,
    "budgetType" "GigBudgetType" NOT NULL,
    "budgetAmount" INTEGER NOT NULL,
    "currency" CHAR(3) NOT NULL,
    "skillsRequired" TEXT[],
    "deadline" TIMESTAMP(3),
    "status" "GigStatus" NOT NULL DEFAULT 'open',
    "assignedFreelancerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "gigs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gig_applications" (
    "id" TEXT NOT NULL,
    "gigId" TEXT NOT NULL,
    "applicantId" TEXT NOT NULL,
    "proposalNote" TEXT NOT NULL,
    "bidAmount" INTEGER NOT NULL,
    "status" "ApplicationStatus" NOT NULL DEFAULT 'submitted',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "gig_applications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gig_transactions" (
    "id" TEXT NOT NULL,
    "gigId" TEXT NOT NULL,
    "gigApplicationId" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "freelancerId" TEXT NOT NULL,
    "grossAmount" INTEGER NOT NULL,
    "commissionRate" DOUBLE PRECISION NOT NULL,
    "commissionAmount" INTEGER NOT NULL,
    "netAmount" INTEGER NOT NULL,
    "currency" CHAR(3) NOT NULL,
    "status" "EscrowStatus" NOT NULL DEFAULT 'HELD_IN_ESCROW',
    "providerRef" TEXT NOT NULL,
    "capturedAt" TIMESTAMP(3) NOT NULL,
    "releasedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "gig_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wallet_entries" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "WalletEntryType" NOT NULL,
    "amount" INTEGER NOT NULL,
    "relatedGigTransactionId" TEXT,
    "balanceAfter" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "wallet_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vacancies" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "postedById" TEXT NOT NULL,
    "employmentType" "EmploymentType" NOT NULL,
    "location" TEXT NOT NULL,
    "skillsRequired" TEXT[],
    "salaryMin" INTEGER,
    "salaryMax" INTEGER,
    "currency" CHAR(3),
    "applicationDeadline" TIMESTAMP(3),
    "status" "VacancyStatus" NOT NULL DEFAULT 'open',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vacancies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vacancy_applications" (
    "id" TEXT NOT NULL,
    "vacancyId" TEXT NOT NULL,
    "applicantId" TEXT NOT NULL,
    "coverNote" TEXT NOT NULL,
    "status" "ApplicationStatus" NOT NULL DEFAULT 'submitted',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vacancy_applications_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "gigs_status_idx" ON "gigs"("status");

-- CreateIndex
CREATE INDEX "gigs_status_skillsRequired_idx" ON "gigs"("status", "skillsRequired");

-- CreateIndex
CREATE INDEX "gig_applications_status_idx" ON "gig_applications"("status");

-- CreateIndex
CREATE UNIQUE INDEX "gig_applications_gigId_applicantId_key" ON "gig_applications"("gigId", "applicantId");

-- CreateIndex
CREATE UNIQUE INDEX "gig_transactions_gigId_key" ON "gig_transactions"("gigId");

-- CreateIndex
CREATE UNIQUE INDEX "gig_transactions_gigApplicationId_key" ON "gig_transactions"("gigApplicationId");

-- CreateIndex
CREATE UNIQUE INDEX "gig_transactions_providerRef_key" ON "gig_transactions"("providerRef");

-- CreateIndex
CREATE INDEX "gig_transactions_status_idx" ON "gig_transactions"("status");

-- CreateIndex
CREATE INDEX "wallet_entries_userId_idx" ON "wallet_entries"("userId");

-- CreateIndex
CREATE INDEX "vacancies_status_idx" ON "vacancies"("status");

-- CreateIndex
CREATE INDEX "vacancy_applications_status_idx" ON "vacancy_applications"("status");

-- CreateIndex
CREATE UNIQUE INDEX "vacancy_applications_vacancyId_applicantId_key" ON "vacancy_applications"("vacancyId", "applicantId");

-- AddForeignKey
ALTER TABLE "gigs" ADD CONSTRAINT "gigs_postedById_fkey" FOREIGN KEY ("postedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gigs" ADD CONSTRAINT "gigs_assignedFreelancerId_fkey" FOREIGN KEY ("assignedFreelancerId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gig_applications" ADD CONSTRAINT "gig_applications_gigId_fkey" FOREIGN KEY ("gigId") REFERENCES "gigs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gig_applications" ADD CONSTRAINT "gig_applications_applicantId_fkey" FOREIGN KEY ("applicantId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gig_transactions" ADD CONSTRAINT "gig_transactions_gigId_fkey" FOREIGN KEY ("gigId") REFERENCES "gigs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gig_transactions" ADD CONSTRAINT "gig_transactions_gigApplicationId_fkey" FOREIGN KEY ("gigApplicationId") REFERENCES "gig_applications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gig_transactions" ADD CONSTRAINT "gig_transactions_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gig_transactions" ADD CONSTRAINT "gig_transactions_freelancerId_fkey" FOREIGN KEY ("freelancerId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_entries" ADD CONSTRAINT "wallet_entries_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_entries" ADD CONSTRAINT "wallet_entries_relatedGigTransactionId_fkey" FOREIGN KEY ("relatedGigTransactionId") REFERENCES "gig_transactions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vacancies" ADD CONSTRAINT "vacancies_postedById_fkey" FOREIGN KEY ("postedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vacancy_applications" ADD CONSTRAINT "vacancy_applications_vacancyId_fkey" FOREIGN KEY ("vacancyId") REFERENCES "vacancies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vacancy_applications" ADD CONSTRAINT "vacancy_applications_applicantId_fkey" FOREIGN KEY ("applicantId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
