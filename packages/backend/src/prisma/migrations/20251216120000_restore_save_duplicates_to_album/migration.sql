-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_settings" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "rateLimitWindow" INTEGER NOT NULL,
    "rateLimitMax" INTEGER NOT NULL,
    "secret" TEXT NOT NULL,
    "serviceName" TEXT NOT NULL,
    "chunkSize" TEXT NOT NULL,
    "chunkedUploadsTimeout" INTEGER NOT NULL,
    "maxSize" TEXT NOT NULL,
    "generateZips" BOOLEAN NOT NULL,
    "generateOriginalFileNameWithIdentifier" BOOLEAN NOT NULL DEFAULT false,
    "generatedFilenameLength" INTEGER NOT NULL,
    "generatedAlbumLength" INTEGER NOT NULL,
    "generatedLinksLength" INTEGER NOT NULL DEFAULT 8,
    "saveDuplicatesToAlbum" BOOLEAN NOT NULL DEFAULT false,
    "blockedExtensions" TEXT NOT NULL,
    "blockNoExtension" BOOLEAN NOT NULL,
    "publicMode" BOOLEAN NOT NULL,
    "userAccounts" BOOLEAN NOT NULL,
    "disableStatisticsCron" BOOLEAN NOT NULL,
    "disableUpdateCheck" BOOLEAN NOT NULL DEFAULT false,
    "backgroundImageURL" TEXT NOT NULL,
    "logoURL" TEXT NOT NULL,
    "metaDescription" TEXT NOT NULL,
    "metaKeywords" TEXT NOT NULL,
    "metaTwitterHandle" TEXT NOT NULL,
    "metaDomain" TEXT NOT NULL DEFAULT '',
    "serveUploadsFrom" TEXT NOT NULL DEFAULT '',
    "enableMixedCaseFilenames" BOOLEAN NOT NULL DEFAULT true,
    "usersStorageQuota" TEXT NOT NULL DEFAULT '0',
    "useNetworkStorage" BOOLEAN NOT NULL DEFAULT false,
    "useMinimalHomepage" BOOLEAN NOT NULL DEFAULT false,
    "useUrlShortener" BOOLEAN NOT NULL DEFAULT false,
    "generateThumbnails" BOOLEAN NOT NULL DEFAULT true,
    "privacyPolicyPageContent" TEXT NOT NULL DEFAULT '',
    "termsOfServicePageContent" TEXT NOT NULL DEFAULT '',
    "rulesPageContent" TEXT NOT NULL DEFAULT '',
    "S3Region" TEXT NOT NULL DEFAULT '',
    "S3Bucket" TEXT NOT NULL DEFAULT '',
    "S3AccessKey" TEXT NOT NULL DEFAULT '',
    "S3SecretKey" TEXT NOT NULL DEFAULT '',
    "S3Endpoint" TEXT NOT NULL DEFAULT '',
    "S3PathStyle" BOOLEAN NOT NULL DEFAULT false,
    "S3PublicUrl" TEXT NOT NULL DEFAULT '',
    "defaultSortOrder" TEXT NOT NULL DEFAULT 'createdAt:desc'
);
INSERT INTO "new_settings" ("id", "rateLimitWindow", "rateLimitMax", "secret", "serviceName", "chunkSize", "chunkedUploadsTimeout", "maxSize", "generateZips", "generateOriginalFileNameWithIdentifier", "generatedFilenameLength", "generatedAlbumLength", "generatedLinksLength", "saveDuplicatesToAlbum", "blockedExtensions", "blockNoExtension", "publicMode", "userAccounts", "disableStatisticsCron", "disableUpdateCheck", "backgroundImageURL", "logoURL", "metaDescription", "metaKeywords", "metaTwitterHandle", "metaDomain", "serveUploadsFrom", "enableMixedCaseFilenames", "usersStorageQuota", "useNetworkStorage", "useMinimalHomepage", "useUrlShortener", "generateThumbnails", "privacyPolicyPageContent", "termsOfServicePageContent", "rulesPageContent", "S3Region", "S3Bucket", "S3AccessKey", "S3SecretKey", "S3Endpoint", "S3PathStyle", "S3PublicUrl", "defaultSortOrder") SELECT "id", "rateLimitWindow", "rateLimitMax", "secret", "serviceName", "chunkSize", "chunkedUploadsTimeout", "maxSize", "generateZips", "generateOriginalFileNameWithIdentifier", "generatedFilenameLength", "generatedAlbumLength", "generatedLinksLength", false AS "saveDuplicatesToAlbum", "blockedExtensions", "blockNoExtension", "publicMode", "userAccounts", "disableStatisticsCron", "disableUpdateCheck", "backgroundImageURL", "logoURL", "metaDescription", "metaKeywords", "metaTwitterHandle", "metaDomain", "serveUploadsFrom", "enableMixedCaseFilenames", "usersStorageQuota", "useNetworkStorage", "useMinimalHomepage", "useUrlShortener", "generateThumbnails", "privacyPolicyPageContent", "termsOfServicePageContent", "rulesPageContent", "S3Region", "S3Bucket", "S3AccessKey", "S3SecretKey", "S3Endpoint", "S3PathStyle", "S3PublicUrl", "defaultSortOrder" FROM "settings";
DROP TABLE "settings";
ALTER TABLE "new_settings" RENAME TO "settings";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
