# App Store Connect 인앱구매 체크리스트

## 🔍 TestFlight 스토어 연결 오류 해결 가이드

### 1. App Store Connect 확인사항

#### 상품 등록 상태
- [ ] App Store Connect 로그인: https://appstoreconnect.apple.com
- [ ] My Apps > SONA 선택
- [ ] Features > In-App Purchases 확인

#### 필수 상품 ID (정확히 일치해야 함)
- [ ] `com.nohbrother.teamsona.chatapp.hearts_10`
- [ ] `com.nohbrother.teamsona.chatapp.hearts_30`
- [ ] `com.nohbrother.teamsona.chatapp.hearts_50`

#### 상품별 필수 정보
각 상품마다 다음 정보가 모두 입력되어야 함:
- [ ] Reference Name (내부 참조용 이름)
- [ ] Product ID (위의 ID와 정확히 일치)
- [ ] Type: **Consumable** (소모품)
- [ ] Price Tier 설정
- [ ] Display Name (최소 1개 언어)
  - 한국어: 하트 10개 / 하트 30개 / 하트 50개
  - 영어: 10 Hearts / 30 Hearts / 50 Hearts
- [ ] Description (최소 1개 언어)
- [ ] Screenshot (최소 1개) - 640x920 이상
- [ ] Review Notes (선택사항이지만 권장)

#### 상품 상태 확인
- [ ] 상태가 **"Ready to Submit"** 또는 **"Approved"**인지 확인
- [ ] "Missing Metadata" 상태가 아닌지 확인
- [ ] "Developer Action Needed" 상태가 아닌지 확인

### 2. 계약 및 세금 정보

#### Agreements, Tax, and Banking 확인
- [ ] Paid Applications 계약 상태: **Active**
- [ ] Banking Information 등록 완료
- [ ] Tax Forms 제출 완료
- [ ] Contact Information 입력 완료

### 3. TestFlight 설정

#### 내부 테스트 그룹
- [ ] 테스터 그룹 생성됨
- [ ] 테스터 이메일 추가됨
- [ ] 빌드가 테스트 그룹에 배포됨

#### Sandbox 테스트 계정
- [ ] Users and Access > Sandbox > Testers
- [ ] 테스트용 Apple ID 생성됨
- [ ] 디바이스 설정 > App Store > Sandbox Account 로그인

### 4. 빌드 설정 확인

#### Xcode 설정
- [ ] Bundle ID: `com.nohbrother.teamsona.chatapp`
- [ ] In-App Purchase Capability 추가됨
- [ ] StoreKit Configuration: **None** (Archive 시)

#### 버전 정보
- [ ] 현재 버전: 1.0.8+21
- [ ] TestFlight 빌드 번호가 증가함

### 5. 디버깅 단계

#### TestFlight 로그 확인
1. TestFlight 앱 실행
2. SONA 앱 선택
3. "Send Beta Feedback" 탭
4. Crash 로그 확인

#### 콘솔 로그 확인 (Mac 필요)
1. iPhone을 Mac에 연결
2. Console.app 실행
3. 디바이스 선택
4. "sona" 필터 적용
5. 앱 실행 후 로그 확인

### 6. 일반적인 문제 해결

#### "Cannot connect to iTunes Store"
- 원인: Bundle ID 불일치 또는 상품 미등록
- 해결: Bundle ID와 Product ID 확인

#### "Product not found"
- 원인: 상품 메타데이터 미완성
- 해결: App Store Connect에서 모든 필수 정보 입력

#### "Store connection error"
- 원인: 계약 미체결 또는 StoreKit 설정 문제
- 해결: Paid Applications 계약 확인

### 7. 추가 확인사항

#### 네트워크 환경
- [ ] WiFi 연결 상태 양호
- [ ] VPN 비활성화
- [ ] 프록시 설정 없음

#### 디바이스 설정
- [ ] iOS 버전 13.0 이상
- [ ] App Store 로그인됨
- [ ] 제한 모드 비활성화 (스크린타임)

### 8. 문의처

#### Apple Developer Support
- https://developer.apple.com/contact/
- 전화: 080-330-5172 (한국)

#### 관련 문서
- [In-App Purchase 가이드](https://developer.apple.com/in-app-purchase/)
- [StoreKit 문서](https://developer.apple.com/documentation/storekit/)
- [TestFlight 문서](https://developer.apple.com/testflight/)

---

## ✅ 최종 체크

모든 항목을 확인한 후에도 문제가 지속되면:

1. **24시간 대기**: App Store Connect 변경사항 반영에 시간이 걸릴 수 있음
2. **새 빌드 업로드**: 클린 빌드로 다시 시도
3. **Apple 지원 문의**: 기술 지원 요청 제출