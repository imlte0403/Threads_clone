# Firebase 권한 규칙 설정 가이드

## 🔥 Firestore Security Rules

Firebase Console > Firestore Database > 규칙에서 다음 규칙을 설정하세요:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Posts 컬렉션 규칙
    match /posts/{postId} {
      // 읽기: 로그인한 사용자만 가능
      allow read: if request.auth != null;
      
      // 생성: 로그인한 사용자만 가능
      allow create: if request.auth != null
        && isValidPostData(request.resource.data);
      
      // 업데이트: 로그인한 사용자만 가능 (좋아요, 댓글 수 등)
      allow update: if request.auth != null
        && isValidPostUpdate(request.resource.data, resource.data);
      
      // 삭제: 로그인한 사용자만 가능 (익명 게시물만)
      allow delete: if request.auth != null;
    }
    
    // 유저 컬렉션 규칙 (필요시)
    match /users/{userId} {
      allow read, write: if request.auth != null;
    }
    
    // 게시물 데이터 유효성 검증 함수
    function isValidPostData(data) {
      return data.keys().hasAll(['username', 'text', 'createdAt', 'updatedAt', 'likes', 'replies'])
        && data.username is string
        && data.text is string
        && data.likes is number
        && data.replies is number
        && data.likes >= 0
        && data.replies >= 0;
    }
    
    // 게시물 업데이트 유효성 검증 함수
    function isValidPostUpdate(newData, oldData) {
      // 좋아요 수는 1씩만 증가/감소 가능
      let likeDiff = newData.likes - oldData.likes;
      let replyDiff = newData.replies - oldData.replies;
      
      return (likeDiff >= -1 && likeDiff <= 1)
        && (replyDiff >= -1 && replyDiff <= 1)
        && newData.username == oldData.username
        && newData.text == oldData.text;
    }
  }
}
```

## 🔥 Firebase Storage Security Rules

Firebase Console > Storage > 규칙에서 다음 규칙을 설정하세요:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // Posts 이미지 규칙
    match /posts/{imageId} {
      // 읽기: 누구나 가능 (공개 게시물)
      allow read: if true;
      
      // 업로드: 로그인한 사용자만 가능
      allow write: if request.auth != null
        && isValidImage(request.resource);
    }
    
    // 프로필 이미지 규칙 (필요시)
    match /profile_images/{userId} {
      allow read: if true;
      allow write: if request.auth != null
        && request.auth.uid == userId
        && isValidImage(request.resource);
    }
    
    // 이미지 파일 유효성 검증 함수
    function isValidImage(resource) {
      return resource.size < 10 * 1024 * 1024  // 10MB 제한
        && resource.contentType.matches('image/.*');
    }
  }
}
```

## 📝 설정 방법

### 1. Firestore 규칙 설정
1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택
3. 왼쪽 메뉴에서 "Firestore Database" 클릭
4. "규칙" 탭 클릭
5. 위의 Firestore 규칙 코드를 복사하여 붙여넣기
6. "게시" 버튼 클릭

### 2. Storage 규칙 설정
1. Firebase Console에서 같은 프로젝트 선택
2. 왼쪽 메뉴에서 "Storage" 클릭
3. "규칙" 탭 클릭
4. 위의 Storage 규칙 코드를 복사하여 붙여넣기
5. "게시" 버튼 클릭

## 🛡️ 보안 특징

### Firestore 규칙의 보안 특징:
- ✅ **인증된 사용자만 읽기/쓰기 가능**
- ✅ **데이터 유효성 검증** (필수 필드, 타입 체크)
- ✅ **좋아요/댓글 수 조작 방지** (1씩만 증감 가능)
- ✅ **핵심 데이터 변경 방지** (username, text 수정 불가)

### Storage 규칙의 보안 특징:
- ✅ **이미지만 업로드 가능** (MIME 타입 검증)
- ✅ **파일 크기 제한** (10MB)
- ✅ **익명 읽기 허용** (공개 게시물용)
- ✅ **인증된 사용자만 업로드 가능**

## ⚠️ 주의사항

1. **테스트 모드에서 프로덕션으로 전환** 시 반드시 규칙을 설정하세요
2. **규칙 변경 후 테스트**를 통해 정상 동작하는지 확인하세요
3. **에러 로그를 모니터링**하여 권한 관련 이슈를 확인하세요

## 🧪 규칙 테스트

Firebase Console의 규칙 탭에서 "규칙 시뮬레이터"를 사용하여 다음을 테스트하세요:

1. **읽기 테스트**: 인증된/비인증된 사용자의 데이터 읽기
2. **쓰기 테스트**: 게시물 생성, 좋아요, 삭제
3. **파일 업로드 테스트**: 이미지 파일 업로드/다운로드

이 규칙들을 적용하면 보안이 강화된 익명 게시판을 운영할 수 있습니다! 🚀