



-- 상위 작업 등록
insert into task (name, sort, updated_at)
values ('요구사항 분석', 1, now()),
       ('설계', 2, now()),
       ('구현', 3, now()),
       ('테스트', 4, now()),
       ('유지보수', 5, now());