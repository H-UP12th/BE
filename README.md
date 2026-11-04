# 도넛팟 BE

## Tech Stack
Java 21 · Spring Boot 4.0 · Gradle · MySQL 8 · Spring Data JPA · Swagger(springdoc)

## 로컬 실행
1. `src/main/resources/application.yml.example` 을 복사해서 `application.yml` 로 만들고 DB 비밀번호 입력 (커밋 X)
2. MySQL에서 `docs/donutpot_erd.sql` 실행해서 테이블 생성 (`ddl-auto: validate` 라 테이블이 없으면 서버가 안 뜸)
3. `./gradlew bootRun`
4. Swagger: http://localhost:8080/swagger-ui/index.html

## 패키지 구조
```
com.donutpot.be
 ├─ domain/{도메인}/controller · service · repository · entity · dto
 └─ global/config · entity · exception · response
```

## 공통 규칙
- 응답: `ApiResponse.ok(data)` / 에러는 `throw new CustomException(HttpStatus.XXX, "메시지")`
- created_at 있는 엔티티는 `BaseTimeEntity` 상속
