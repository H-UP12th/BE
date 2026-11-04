-- 도넛팟(핼팅) ERD - MySQL
-- 기준: 노션 기능명세서 / API 명세서 (2026-10-28)

CREATE TABLE users (
  id                BIGINT       NOT NULL AUTO_INCREMENT COMMENT '회원 ID',
  login_id          VARCHAR(30)  NOT NULL COMMENT '아이디',
  password          VARCHAR(255) NOT NULL COMMENT '비밀번호(암호화)',
  name              VARCHAR(30)  NOT NULL COMMENT '성명',
  profile_image_url VARCHAR(500) NULL     COMMENT '프로필 사진',
  created_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
  PRIMARY KEY (id),
  UNIQUE KEY uk_users_login_id (login_id)
) COMMENT '회원';

CREATE TABLE memos (
  id         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '메모 ID',
  user_id    BIGINT   NOT NULL COMMENT '회원 ID',
  content    TEXT     NULL     COMMENT '메모 내용',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
  PRIMARY KEY (id),
  UNIQUE KEY uk_memos_user (user_id),
  FOREIGN KEY (user_id) REFERENCES users (id)
) COMMENT '메인 메모장';

CREATE TABLE to_eat_items (
  id          BIGINT       NOT NULL AUTO_INCREMENT COMMENT 'TO EAT ID',
  user_id     BIGINT       NOT NULL COMMENT '회원 ID',
  day_of_week ENUM('MON','TUE','WED','THU','FRI','SAT','SUN') NOT NULL COMMENT '요일',
  menu_text   VARCHAR(100) NULL     COMMENT '먹을 메뉴',
  PRIMARY KEY (id),
  UNIQUE KEY uk_to_eat_user_day (user_id, day_of_week),
  FOREIGN KEY (user_id) REFERENCES users (id)
) COMMENT 'TO EAT LIST';

CREATE TABLE menus (
  id         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '메뉴 ID',
  category   ENUM('LOW_SUGAR','SLOW_CARB','PROTEIN','CALORIE','SHARED') NOT NULL COMMENT '식단(저당/저속/단백질/칼로리/공유)',
  author_id  BIGINT       NULL     COMMENT '작성자 ID(공유 메뉴만, 기본 메뉴는 NULL)',
  name       VARCHAR(100) NOT NULL COMMENT '메뉴 이름',
  image_url  VARCHAR(500) NULL     COMMENT '대표 이미지',
  calories   INT          NULL     COMMENT '칼로리(kcal)',
  carbs      DECIMAL(6,1) NULL     COMMENT '탄수화물(g)',
  protein    DECIMAL(6,1) NULL     COMMENT '단백질(g)',
  fat        DECIMAL(6,1) NULL     COMMENT '지방(g)',
  tip        TEXT         NULL     COMMENT '추가 사항(팁/주의사항)',
  video_id   VARCHAR(20)  NULL     COMMENT '유튜브 영상 ID(보류)',
  created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
  PRIMARY KEY (id),
  KEY idx_menus_category (category),
  FOREIGN KEY (author_id) REFERENCES users (id)
) COMMENT '메뉴';

CREATE TABLE ingredients (
  id         BIGINT      NOT NULL AUTO_INCREMENT COMMENT '재료 ID',
  menu_id    BIGINT      NOT NULL COMMENT '메뉴 ID',
  name       VARCHAR(50) NOT NULL COMMENT '재료명',
  amount     VARCHAR(30) NULL     COMMENT '분량',
  sort_order INT         NOT NULL COMMENT '표시 순서',
  PRIMARY KEY (id),
  FOREIGN KEY (menu_id) REFERENCES menus (id) ON DELETE CASCADE
) COMMENT '재료';

CREATE TABLE substitutes (
  id              BIGINT      NOT NULL AUTO_INCREMENT COMMENT '대체 재료 ID',
  menu_id         BIGINT      NOT NULL COMMENT '메뉴 ID',
  original_name   VARCHAR(50) NOT NULL COMMENT '원재료',
  substitute_name VARCHAR(50) NOT NULL COMMENT '대체 재료',
  amount          VARCHAR(30) NULL     COMMENT '분량',
  PRIMARY KEY (id),
  FOREIGN KEY (menu_id) REFERENCES menus (id) ON DELETE CASCADE
) COMMENT '대체 재료';

CREATE TABLE recipe_steps (
  id      BIGINT NOT NULL AUTO_INCREMENT COMMENT '조리 단계 ID',
  menu_id BIGINT NOT NULL COMMENT '메뉴 ID',
  step_no INT    NOT NULL COMMENT '단계 번호',
  content TEXT   NOT NULL COMMENT '조리 설명',
  PRIMARY KEY (id),
  UNIQUE KEY uk_steps_menu_no (menu_id, step_no),
  FOREIGN KEY (menu_id) REFERENCES menus (id) ON DELETE CASCADE
) COMMENT '조리 과정';

CREATE TABLE questions (
  id         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '질문 ID',
  menu_id    BIGINT   NOT NULL COMMENT '메뉴 ID',
  user_id    BIGINT   NOT NULL COMMENT '작성자 ID',
  content    TEXT     NOT NULL COMMENT '질문 내용',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
  PRIMARY KEY (id),
  FOREIGN KEY (menu_id) REFERENCES menus (id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users (id)
) COMMENT 'Q&A';

CREATE TABLE ratings (
  id         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '점수 ID',
  menu_id    BIGINT   NOT NULL COMMENT '메뉴 ID',
  user_id    BIGINT   NOT NULL COMMENT '회원 ID',
  score      DECIMAL(2,1) NOT NULL COMMENT '점수(0.0~5.0)',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
  PRIMARY KEY (id),
  UNIQUE KEY uk_ratings_user_menu (user_id, menu_id),
  CHECK (score BETWEEN 0.0 AND 5.0),
  FOREIGN KEY (menu_id) REFERENCES menus (id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users (id)
) COMMENT '평가';

CREATE TABLE bookmarks (
  id         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '북마크 ID',
  user_id    BIGINT   NOT NULL COMMENT '회원 ID',
  menu_id    BIGINT   NOT NULL COMMENT '메뉴 ID',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '저장일',
  PRIMARY KEY (id),
  UNIQUE KEY uk_bookmarks_user_menu (user_id, menu_id),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (menu_id) REFERENCES menus (id) ON DELETE CASCADE
) COMMENT '저장한 레시피';

CREATE TABLE recent_views (
  id        BIGINT   NOT NULL AUTO_INCREMENT COMMENT '최근 본 ID',
  user_id   BIGINT   NOT NULL COMMENT '회원 ID',
  menu_id   BIGINT   NOT NULL COMMENT '메뉴 ID',
  viewed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '본 시각',
  PRIMARY KEY (id),
  UNIQUE KEY uk_recent_user_menu (user_id, menu_id),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (menu_id) REFERENCES menus (id) ON DELETE CASCADE
) COMMENT '최근 본 레시피';
