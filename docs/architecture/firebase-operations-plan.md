# Firebase Operations Plan

## Overview
This document outlines the operations needed to update the Firebase data structure to move relationship scores from personas to a separate user-persona relationships collection.

## Current State
- Firebase project: sona-app-89598
- Service account key: Available at C:/Users/yong/sonaapp/firebase-service-account-key.json
- Storage bucket: sona-app-89598.firebasestorage.app

## Required Operations

### 1. Update Existing Personas (Remove relationshipScore field)

#### Persona 001 Update
```javascript
// Document: personas/persona_001
// Remove field: relationshipScore
firestore_update_document({
  collection: "personas",
  document_id: "persona_001",
  updates: {
    // Remove relationshipScore field - this requires a delete operation
  }
})
```

#### Persona 002 Update
```javascript
// Document: personas/persona_002  
// Remove field: relationshipScore
firestore_update_document({
  collection: "personas",
  document_id: "persona_002",
  updates: {
    // Remove relationshipScore field - this requires a delete operation
  }
})
```

### 2. Create User-Persona Relationships Collection

#### Collection Structure: user_persona_relationships
- Document ID format: '{userId}_{personaId}' (e.g., 'user123_persona_001')
- Fields:
  - userId: string
  - personaId: string
  - relationshipScore: number (default: 50)
  - isCasualSpeech: boolean (default: false)
  - lastInteraction: timestamp
  - createdAt: timestamp

### 3. Create Sample Relationship Documents

#### Document 1: user123_persona_001
```javascript
firestore_create_document({
  collection: "user_persona_relationships",
  document_id: "user123_persona_001",
  data: {
    userId: "user123",
    personaId: "persona_001",
    relationshipScore: 75,
    isCasualSpeech: false,
    lastInteraction: new Date(),
    createdAt: new Date()
  }
})
```

#### Document 2: user123_persona_002
```javascript
firestore_create_document({
  collection: "user_persona_relationships", 
  document_id: "user123_persona_002",
  data: {
    userId: "user123",
    personaId: "persona_002", 
    relationshipScore: 60,
    isCasualSpeech: false,
    lastInteraction: new Date(),
    createdAt: new Date()
  }
})
```

#### Document 3: tutorial_user_persona_001
```javascript
firestore_create_document({
  collection: "user_persona_relationships",
  document_id: "tutorial_user_persona_001", 
  data: {
    userId: "tutorial_user",
    personaId: "persona_001",
    relationshipScore: 50,
    isCasualSpeech: false,
    lastInteraction: new Date(),
    createdAt: new Date()
  }
})
```

### 4. Verification Operations

#### Read Updated Personas
```javascript
firestore_get_document({
  collection: "personas",
  document_id: "persona_001"
})

firestore_get_document({
  collection: "personas", 
  document_id: "persona_002"
})
```

#### Read Relationship Documents
```javascript
firestore_get_document({
  collection: "user_persona_relationships",
  document_id: "user123_persona_001"
})

firestore_get_document({
  collection: "user_persona_relationships",
  document_id: "user123_persona_002"  
})

firestore_get_document({
  collection: "user_persona_relationships",
  document_id: "tutorial_user_persona_001"
})
```

#### List Collections (Verify new collection exists)
```javascript
firestore_list_collections()
```

## Notes
- The relationshipScore field needs to be deleted from existing persona documents
- The new collection will track per-user relationships with each persona
- Default relationship score is 50 for new relationships
- All timestamps should use server timestamps for consistency

## Status
- [ ] Remove relationshipScore from persona_001
- [ ] Remove relationshipScore from persona_002  
- [ ] Create user_persona_relationships collection
- [ ] Create sample relationship: user123_persona_001
- [ ] Create sample relationship: user123_persona_002
- [ ] Create sample relationship: tutorial_user_persona_001
- [ ] Verify all operations completed successfully