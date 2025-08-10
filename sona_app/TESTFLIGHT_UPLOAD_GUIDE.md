# TestFlight 업로드 가이드

## 현재 상태
- ✅ 버전: 1.0.4
- ✅ 빌드 번호: 18
- ✅ Bundle ID: com.nohbrother.teamsona.chatapp
- ✅ Team ID: 3VXN83XNN5
- ✅ Pod 설치 완료
- ✅ Flutter 릴리즈 빌드 준비 중

## Xcode에서 Archive 생성 및 TestFlight 업로드

### 1. Xcode 열기
```bash
open ios/Runner.xcworkspace
```
⚠️ **중요**: `Runner.xcodeproj`가 아닌 `Runner.xcworkspace`를 열어야 합니다!

### 2. 프로젝트 설정 확인

#### Signing & Capabilities
1. 왼쪽 프로젝트 네비게이터에서 `Runner` 선택
2. TARGETS에서 `Runner` 선택
3. `Signing & Capabilities` 탭 클릭
4. 확인사항:
   - ✅ Automatically manage signing 체크
   - ✅ Team: `noh dol (3VXN83XNN5)` 선택
   - ✅ Bundle Identifier: `com.nohbrother.teamsona.chatapp`

#### General 설정
1. `General` 탭 클릭
2. 확인사항:
   - Version: `1.0.4`
   - Build: `18`
   - Deployment Target: `iOS 13.0`

### 3. Archive 생성

1. **디바이스 선택**
   - 상단 툴바에서 `Any iOS Device (arm64)` 선택
   - 시뮬레이터가 선택되어 있으면 Archive 메뉴가 비활성화됨

2. **빌드 정리 (선택사항)**
   - 메뉴: Product > Clean Build Folder (Cmd+Shift+K)

3. **Archive 생성**
   - 메뉴: Product > Archive
   - 또는 단축키: Cmd+Shift+I 후 Archive 선택
   - ⏱️ 5-10분 소요

4. **빌드 에러 발생 시**
   - Clean Build Folder 다시 실행
   - ios 폴더에서 `pod install` 재실행
   - DerivedData 삭제: `rm -rf ~/Library/Developer/Xcode/DerivedData`

### 4. TestFlight 업로드

Archive 완료 후 Organizer 창이 자동으로 열립니다.

1. **Archive 선택**
   - 방금 생성한 Archive 선택 (날짜/시간 확인)

2. **Distribute App 클릭**
   - 오른쪽 `Distribute App` 버튼 클릭

3. **배포 방법 선택**
   - `App Store Connect` 선택 > Next

4. **배포 옵션**
   - `Upload` 선택 > Next
   - (TestFlight 전용이면 Upload, 앱스토어 출시면 Upload 후 Submit)

5. **App Store Connect 옵션**
   - `Manage Version and Build Number` 체크 해제 (수동 관리)
   - `Upload your app's symbols` 체크 (크래시 리포트용)
   - Next

6. **서명 옵션**
   - `Automatically manage signing` 선택 > Next

7. **검토 및 업로드**
   - 앱 정보 확인
   - `Upload` 클릭
   - ⏱️ 5-15분 소요 (네트워크 속도에 따라)

### 5. App Store Connect에서 TestFlight 설정

1. **App Store Connect 접속**
   - https://appstoreconnect.apple.com
   - Apple ID로 로그인

2. **앱 선택**
   - My Apps > SONA 선택

3. **TestFlight 탭**
   - TestFlight 탭 클릭
   - 빌드가 처리 중이면 "Processing" 상태
   - ⏱️ 10-30분 후 사용 가능

4. **테스터 추가**
   - Internal Testing 또는 External Testing 그룹 생성
   - 테스터 이메일 추가
   - 초대 발송

### 6. 빌드 처리 상태 확인

- **Processing**: Apple이 빌드 검증 중 (10-30분)
- **Ready to Submit**: 외부 테스팅 준비 완료
- **Invalid Binary**: 빌드 문제 발생 (이메일 확인)

### 일반적인 문제 해결

#### "No account for team" 에러
- Xcode > Preferences > Accounts
- Apple ID 추가 또는 재로그인

#### "Provisioning profile" 에러
- Automatically manage signing 체크 확인
- Team 재선택
- Xcode 재시작

#### Archive 메뉴 비활성화
- 시뮬레이터가 아닌 실제 디바이스 또는 "Any iOS Device" 선택

#### 빌드 번호 중복
- pubspec.yaml에서 빌드 번호 증가 (현재: 18 → 19)
- 또는 Xcode에서 직접 수정

## 체크리스트

### 업로드 전 확인사항
- [ ] Apple Developer 계정 활성화
- [ ] 앱 아이콘 모든 크기 제공
- [ ] LaunchScreen 설정
- [ ] Info.plist 권한 설명 추가
- [ ] 빌드 번호 증가
- [ ] 서명 설정 완료

### TestFlight 제출 정보
- [ ] 테스트 정보 작성
- [ ] 베타 앱 설명
- [ ] 연락처 정보
- [ ] 테스터 그룹 생성

## 다음 빌드를 위한 스크립트

```bash
# 빌드 번호 자동 증가 및 빌드
./build_testflight.sh

# 또는 수동으로
flutter build ios --release --build-number=19
```

## 참고 링크
- [App Store Connect](https://appstoreconnect.apple.com)
- [Apple Developer](https://developer.apple.com)
- [TestFlight 문서](https://developer.apple.com/testflight/)

---

**현재 빌드 정보**
- Version: 1.0.4
- Build: 18
- Bundle ID: com.nohbrother.teamsona.chatapp
- Team: noh dol (3VXN83XNN5)