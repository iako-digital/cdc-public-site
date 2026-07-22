-- AlterTable
ALTER TABLE "gigs" ADD COLUMN     "deliveryComment" TEXT,
ADD COLUMN     "deliveryFiles" TEXT[] DEFAULT ARRAY[]::TEXT[],
ADD COLUMN     "deliveryLinks" TEXT[] DEFAULT ARRAY[]::TEXT[],
ADD COLUMN     "submittedAt" TIMESTAMP(3);
