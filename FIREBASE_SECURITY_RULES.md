# Firebase Console 보안 규칙 설정 가이드

이 문서는 Thread Clone 앱을 위한 Firebase Console 보안 규칙 설정 방법을 설명합니다.

## 1. Firestore Database 보안 규칙

Firebase Console → Firestore Database → Rules 탭에서 다음 규칙을 적용하세요:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Posts 컬렉션 규칙
    match /posts/{postId} {
      // 모든 사용자가 게시물을 읽을 수 있음
      allow read: if true;
      
      // 인증된 사용자만 게시물을 생성할 수 있음
      allow create: if request.auth != null
        && validatePost(resource.data);
      
      // 게시물 작성자만 수정/삭제 가능
      allow update, delete: if request.auth != null
        && (request.auth.uid == resource.data.userId || request.auth.uid == resource.data.authorId);
    }
    
    // 사용자 관련 문서들 (필요시 추가)
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // 유효성 검증 함수
    function validatePost(data) {
      return data.keys().hasAll(['text', 'createdAt', 'updatedAt'])
        && data.text is string
        && data.text.size() > 0
        && data.text.size() <= 500; // 게시물 최대 길이 제한
    }
  }
}
```

## 2. Firebase Storage 보안 규칙

Firebase Console → Storage → Rules 탭에서 다음 규칙을 적용하세요:

```javascript
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {
    // posts 폴더 - 인증된 사용자만 업로드 가능, 모든 사용자가 읽기 가능
    match /posts/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null
        && validateImageFile(request.resource);
    }
    
    // profile 폴더 - 사용자 자신만 접근 가능 (미래 확장용)
    match /profile/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null 
        && request.auth.uid == userId
        && validateImageFile(request.resource);
    }
    
    // 이미지 파일 유효성 검증
    function validateImageFile(resource) {
      return resource.size < 5 * 1024 * 1024 // 5MB 제한
        && resource.contentType.matches('image/.*'); // 이미지 파일만 허용
    }
  }
}
```

## 3. Firebase Authentication 설정

Firebase Console → Authentication → Settings → Authorized domains에서 다음을 확인하세요:

1. `localhost` (개발용)
2. 실제 앱의 도메인 (배포시)

## 4. 보안 규칙 적용 방법

1. **Firebase Console**에 접속하세요 (https://console.firebase.google.com)
2. 프로젝트를 선택하세요
3. **Firestore Database** 섹션으로 이동
4. **Rules** 탭을 클릭
5. 위의 Firestore 규칙을 복사해서 붙여넣기
6. **게시** 버튼을 클릭하여 적용
7. **Storage** 섹션으로 이동
8. **Rules** 탭을 클릭  
9. 위의 Storage 규칙을 복사해서 붙여넣기
10. **게시** 버튼을 클릭하여 적용

## 5. 규칙 테스트

Firebase Console에서 **Rules Simulator**를 사용하여 규칙을 테스트할 수 있습니다:

### Firestore 테스트 예시:
```
Operation: get
Path: /posts/testPostId
Authenticated: Yes/No
UID: test-user-id
```

### Storage 테스트 예시:
```
Operation: create
Path: /posts/test-image.jpg
Authenticated: Yes
File size: 2MB
Content type: image/jpeg
```

## 6. 주의사항

- **개발 중에는 더 관대한 규칙**을 사용할 수 있지만, **배포 전에는 반드시 엄격한 규칙**을 적용하세요
- 규칙 변경 후 **최대 1분 정도**의 적용 시간이 소요될 수 있습니다
- 규칙에 오류가 있으면 **모든 요청이 거부**되므로 신중하게 테스트하세요

## 7. 개발용 임시 규칙 (테스트 목적)

만약 개발 중 문제가 발생하면 임시로 다음과 같은 관대한 규칙을 사용할 수 있습니다:

### Firestore (개발용):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // 모든 접근 허용 (개발용)
    }
  }
}
```

### Storage (개발용):
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true; // 모든 접근 허용 (개발용)
    }
  }
}
```

**⚠️ 주의: 개발용 규칙은 보안상 매우 위험하므로 배포 전에 반드시 적절한 규칙으로 변경해야 합니다.**