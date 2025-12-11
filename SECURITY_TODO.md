# Security Considerations for Future

This document tracks security improvements to consider for future hardening.

## Security Headers (CSP/COEP/CORP)

**File:** `packages/backend/src/main.ts:124-128`

Currently disabled:
```typescript
await server.register(helmet, {
    crossOriginResourcePolicy: false,
    contentSecurityPolicy: false,
    crossOriginEmbedderPolicy: false
});
```

### Why they're disabled
- **CORP (crossOriginResourcePolicy):** May interfere with serving uploaded files to external sites
- **CSP (contentSecurityPolicy):** Needs careful configuration to not break the frontend
- **COEP (crossOriginEmbedderPolicy):** Can break embedded content

### Recommended CSP when enabling
```typescript
contentSecurityPolicy: {
    directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'", "'unsafe-inline'"],  // May need adjustment for Next.js
        styleSrc: ["'self'", "'unsafe-inline'"],
        imgSrc: ["'self'", "data:", "blob:", SETTINGS.S3PublicUrl].filter(Boolean),
        connectSrc: ["'self'"],
        fontSrc: ["'self'"],
        objectSrc: ["'none'"],
        mediaSrc: ["'self'", SETTINGS.S3PublicUrl].filter(Boolean),
        frameSrc: ["'none'"],
    }
}
```

### When to enable
- When moving to a multi-user public instance
- When handling sensitive user data
- As part of security hardening before wider deployment

## Other Noted Items

### Permissive CORS
Currently allows any origin. Consider restricting to specific domains if needed.

### Error Information Disclosure
`packages/backend/src/routes/links/UpdateLinkCount.ts:43` passes full error to response.
Consider returning generic error message in production.
