-- CreateTable
CREATE TABLE "bog_settings" (
    "id" TEXT NOT NULL,
    "merchantId" TEXT,
    "publicKey" TEXT,
    "secretKey" TEXT,
    "webhookSecret" TEXT,
    "isLiveMode" BOOLEAN NOT NULL DEFAULT false,
    "updatedByEmail" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "bog_settings_pkey" PRIMARY KEY ("id")
);
