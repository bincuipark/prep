




-- sample
--drop table if exists 테이블명 cascade;
--create table if not exists 테이블명 comment '' ();

-- alter table 테이블명 add constraint 외래키명
-- foreign key (외래키 컬럼) references 참조할 테이블명 (참조할 테이블의 주키 컬럼)



drop table if exists user_account cascade;

create table if not exists user_account comment '사용자 계정' (
    id                      int                     not null auto_increment comment '사용자 계정 번호',
    email                   varchar(40)             not null comment '이메일',
    password                varchar(255)            not null comment '비밀번호',
    nickname                varchar(15)             not null comment '닉네임',
    name                    varchar(12)             not null comment '이름',
    phone                   varchar(11)             not null comment '휴대폰 번호',
    login_type              varchar(5)              not null comment '로그인 유형 (LOCAL : 일반 로그인 / OAUTH : 소셜 로그인)',
    enabled                 tinyint(1)              not null comment '계정 활성화',
    deleted_yn              char(1)                 not null default 'N' comment '계정 삭제 여부(논리적 삭제)',
    created_at              datetime                not null default now() comment '가입 일자',
    updated_at              datetime                not null comment '변경 일자',
    deleted_at              datetime                null comment '삭제 일자',
    primary key (id)
);




drop table if exists user_role cascade;

create table if not exists user_role comment '사용자 별 권한' (
    user_id                 int                     not null comment '사용자 계정 번호',
    role                    varchar(20)             not null comment '권한 명(ROLE_USER : 일반회원 / ROLE_MANAGER : 시스템 매니저 / ROLE_ADMIN : 관리자)',
    used_at                 char(1)                 not null default 'Y' comment '권한 사용 여부',
    created_at              datetime                not null default now() comment '등록 일자',
    updated_at              datetime                not null comment '변경 일자',
    primary key (user_id, role),
    foreign key (user_id) references user_account (id)
);




drop table if exists user_profile cascade;

create table if not exists user_profile comment '사용자 프로필' (
    id                      int                     not null auto_increment comment '프로필 번호',
    user_id                 int                     not null comment '사용자 계정 번호',
    profile_img_url         varchar(255)            not null comment '프로필 이미지 저장 경로',
    gender                  char(1)                 not null comment '성별(M : 남성 / F : 여성 / N : 선택 안함)',
    bio                     varchar(150)            not null comment '한 줄 소개(NONE : 소개 없음)',
    univ                    varchar(45)             not null comment '졸업 또는 재학 중인 대학명(NONE : 선택 안함)',
    location                varchar(20)             not null comment '거주 도시명(NONE : 선택 안함)',
    created_at              datetime                not null default now() comment '프로필 등록 일자',
    updated_at              datetime                not null comment '프로필 변경 일자',
    primary key (id),
    foreign key (user_id) references user_account (id)
);




drop table if exists team cascade;

create table if not exists team comment '팀' (
    id                      int                     not null auto_increment comment '팀 번호',
    name                    varchar(100)            not null comment '팀 명',
    bio                     varchar(150)            not null comment '팀 소개 글(NONE : 소개 글 없음)',
    used_yn                 char(1)                 not null default 'Y' comment '팀 사용 여부',
    deleted_yn              char(1)                 not null default 'N' comment '팀 삭제 여부(논리적 삭제)',
    created_by              int                     not null comment '팀 생성자 번호',
    created_at              datetime                not null default now() comment '팀 정보 등록 일자',
    updated_at              datetime                not null comment '팀 정보 변경 일자',
    deleted_at              datetime                null comment '팀 정보 삭제 일자',
    primary key (id),
    foreign key (created_by) references user_account (id)
);




drop table if exists team_user cascade;

create table if not exists team_user comment '팀원' (
    team_id                 int                     not null comment '팀 번호',
    user_id                 int                     not null comment '사용자 계정 번호',
    is_captain              char(1)                 not null comment '팀장 여부'
    primary key (team_id, user_id),
    foreign key (team_id) references team (id),
    foreign key (user_id) references user_account (id)
);




drop table if exists project cascade;

create table if not exists project comment '프로젝트' (
    id                      int                     not null auto_increment comment '프로젝트 번호',
    team_id                 int                     not null comment '팀 번호',
    user_id                 int                     not null comment '프로젝트 관리자 번호',
    summary                 varchar(150)            not null comment '프로젝트 소개 글',
    started_date            datetime                not null comment '프로젝트 시작 일자',
    ended_date              datetime                not null comment '프로젝트 종료 일자',
    project_status          char(1)                 not null comment '프로젝트 진행 상태(W : 대기중 / R : 진행중 / D : 완료)',
    deleted_yn              char(1)                 not null default 'N' comment '삭제 여부(논리적 삭제)',
    created_at              datetime                not null default now() comment '등록 일자',
    updated_at              datetime                not null comment '변경 일자',
    deleted_at              datetime                null comment '삭제 일자',
    primary key (id),
    foreign key (team_id) references team (id),
    foreign key (user_id) references user_account (id)
);




drop table if exists project_task cascade;

create table if not exists project_task comment '프로젝트 작업' (
    id                      int                     not null auto_increment comment ' 번호',
    project_id              int                     not null comment '프로젝트 번호',
    parent_task_id          int                     not null comment '상위 작업 번호',
    name                    varchar(150)            not null comment '작업명',
    started_date            datetime                not null comment '프로젝트 작업 시작 일자',
    ended_date              datetime                not null comment '프로젝트 작업 종료 일자',
    actual_ended_date       datetime                not null comment '실제 프로젝트 작업 종료 일자',
    rate                    int                     not null default 0 comment '진행률',
    sort                    int                     not null comment '화면 정렬 번호',
    created_at              datetime                not null default now() comment '작업 등록 일자',
    updated_at              datetime                not null comment '작업 변경 일자',
    primary key (id),
    foreign key (project_id) references project (id)
);




drop table if exists project_task_assignment cascade;

create table if not exists project_task_assignment comment '프로젝트 작업 할당' (
    project_task_id         int                     not null comment '프로젝트 작업 번호',
    user_id                 int                     not null comment '작업 진행자 번호',
    primary key (project_task_id, user_id),
    foreign key (project_task_id) references project_task (id),
    foreign key (user_id) references user_account (id)
);




drop table if exists meeting_minutes cascade;

create table if not exists meeting_minutes comment '회의록' (
    id                      int                     not null auto_increment comment '회의록 번호',
    project_id              int                     not null comment '프로젝트 번호',
    user_id                 int                     not null comment '회의록 작성자 번호',
    title                   varchar(150)            not null comment '회의록 제목',
    content                 text                    not null comment '회의록 내용',
    meeting_date            datetime                not null comment '회의 일자',
    created_at              datetime                not null default now() comment '회의록 등록 일자',
    updated_at              datetime                not null comment '회의록 변경 일자',
    primary key (id),
    foreign key (project_id) references project (id),
    foreign key (user_id) references user_account (id)
);




drop table if exists meeting_attendant cascade;

create table if not exists meeting_attendant comment '회의 참여자' (
    meeting_minutes_id      int                     not null comment '회의록 번호',
    user_id                 int                     not null comment '참여자 계정 번호',
    primary key (meeting_minutes_id, user_id),
    foreign key (meeting_minutes_id) references meeting_minutes (id),
    foreign key (user_id) references user_account (id)
);




drop table if exists task cascade;

create table if not exists task comment '작업' (
    id                      int                     not null auto_increment comment '작업 번호',
    name                    varchar(45)             not null comment '작업명',
    sort                    int                     not null comment '화면 정렬 번호',
    used_yn                 char(1)                 not null default 'Y' comment '사용 여부',
    created_at              datetime                not null default now() comment '등록 일자',
    updated_at              datetime                not null comment '변경 일자',
    primary key (id)
);



drop table if exists login_history cascade;

create table if not exists login_history comment '로그인 이력' (
    id                      int                     not null auto_increment comment '이력 번호',
    user_id                 int                     not null comment '계정 번호',
    ip_address              varchar(15)             not null comment '접속 ip 주소',
    user_agent              varchar(255)            not null comment '사용자 식별 정보',
    event_type              char(1)                 not null comment '로그인 구분 코드(I : 로그인 / O : 로그아웃)',
    login_at                datetime                not null comment '로그인 일자',
    logout_at               datetime                null comment '로그아웃 일자',
    primary key (id),
    foreign key (user_id) references user_account (id)
);


































