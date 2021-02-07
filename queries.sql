-- temiz bir baslangic :)
DROP TABLE test;

-- tabloyu yaratalim
CREATE TABLE test
(
    date       INT,
    hub_id     INT,
    package_no INT
);

-- 1m data yaratalim
do
$$
    begin
        for i in 1..1000000
            loop
                INSERT INTO test
                SELECT 10 * random(), 20 * random(), 100000 * random();
            end loop;
    end;
$$;

-- esitsizlik basta olacak sekilkde indeksi yaratalim
create index concurrently idx_test_date_hub_id_package_no
    on test (date, hub_id, package_no);

-- yarattigimiz index ile sorgunun costunu gorelim
EXPLAIN
select *
from test
where 7 < date
  and date < 9
  and hub_id = 3
  and package_no = 13797;

-- yarattigimiz index'i dusurelim
drop index concurrently idx_test_date_hub_id_package_no;

-- esitlikler basta olacak sekilde index'i yaratalim
create index concurrently idx_test_package_no_hub_id_date
    on test (package_no, hub_id, date);

-- yarattigimiz index ile sorgunun costunu gorelim
EXPLAIN
select *
from test
where 7 < date
  and date < 9
  and hub_id = 3
  and package_no = 13797;

-- yarattigimiz index'i dusurelim
drop index concurrently idx_test_package_no_hub_id_date;

-- esitlikler yine basta olacak sekilde ama yerlerini degistirerek index'i yaratalim
-- burada cost'un degismediginiz gormeyi bekliyoruz
create index concurrently idx_test_hub_id_package_no_date
    on test (hub_id, package_no, date);

-- yarattigimiz index ile sorgunun costunu gorelim
EXPLAIN
select *
from test
where 7 < date
  and date < 9
  and hub_id = 3
  and package_no = 13797;

-- yarattigimiz index'i dusurelim
drop index concurrently idx_test_hub_id_package_no_date;