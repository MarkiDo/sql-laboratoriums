-- 1.Utwórz relacje ZOO o następujących atrybutach i ograniczeniach:
CREATE TABLE uczelnia.ZOO (
    id_zw numeric(4) PRIMARY KEY,
    Rasa VARCHAR(100),
    Gatunek VARCHAR(100),
    data_odkrycia DATE
);

-- 2. Utwórz relację NETFLIX o następujących atrybutach i ograniczeniach:
CREATE TABLE IF NOT EXISTS uczelnia.netflix
(
    id numeric(12) NOT NULL,
    tytul character varying(100) COLLATE pg_catalog."default" NOT NULL,
    gatunek character varying(30) COLLATE pg_catalog."default",
    tworca character varying(100) COLLATE pg_catalog."default",
    liczba_sezonow numeric(2),
    liczba_odcinkow numeric(3),
    data_powstania date,
    CONSTRAINT netflix_pkey PRIMARY KEY (id)
)

-- 3. Wstaw do relacji NETFLIX następujące wartości:
-- 	- Id: 1000000
-- 	- Tytuł: nazwa dowolnego filmu/serialu z platformy Netflix
-- 	- Gatunek: gatunek tytułu
-- 	- Tworca: twórca tytułu
-- 	- Liczba_sezonow: liczba sezonów serialu (jeśli w tytule jest serial z platformy Netflix)
-- 	- Liczba_odcinkow: liczba odcinków serialu (jeśli w tytule jest serial z platformy Netflix)
-- 	- Data_powstania: data powstania tytułu

INSERT INTO uczelnia.netflix (Id, Tytul, Gatunek, Tworca, Liczba_sezonow, Liczba_odcinkow, Data_powstania)
VALUES (1000000, 'The Crown', 'Dramat historyczny', 'Peter Morgan', 4, 40, '2016-11-04');

-- 4. Zmień nazwę relacji ZOO na ZOO_KIELCE, a potem ją usuń.
ALTER TABLE uczelnia.ZOO RENAME TO ZOO_KIELCE;
DROP TABLE IF EXISTS uczelnia.ZOO_KIELCE;

-- 5. Utwórz relacje PROJEKTY o następujących atrybutach i ograniczeniach
CREATE TABLE IF NOT EXISTS uczelnia.projekty
(
    id_projektu numeric(3,0) NOT NULL,
    nazwa character varying(70) COLLATE pg_catalog."default" NOT NULL,
    opis character varying(200) COLLATE pg_catalog."default" NOT NULL,
    data_rozpoczecia date DEFAULT CURRENT_DATE,
    data_zakonczenia date,
    fundusz numeric(7,2),
    CONSTRAINT projekty_pkey PRIMARY KEY (id_projektu),
    CONSTRAINT proj_name_unique UNIQUE (nazwa),
    CONSTRAINT projekty_check CHECK (data_zakonczenia > data_rozpoczecia)
)


-- 6. Utwórz relacje PRZYDZIAŁY o następujących atrybutach i ograniczeniach.
-- Klucz podstawowy tworzą atrybuty id_projektu i id_prac (pamiętaj o wczytaniu bazy UCZELNIA).
drop table uczelnia.przydzialy;
CREATE TABLE IF NOT EXISTS uczelnia.przydzialy
(
    id_projektu numeric(3,0),
    id_prac numeric(4,0),
    od date DEFAULT CURRENT_DATE,
    "do" date CHECK ("do" > od),
    stawka numeric(7,2),
    rola character varying(20) COLLATE pg_catalog."default" CHECK (rola IN ('LIDER', 'ANALITYK', 'DESIGNER', 'PROGRAMISTA')),
    CONSTRAINT fk_prac FOREIGN KEY (id_prac)
        REFERENCES uczelnia.pracownicy (id_prac) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_proj FOREIGN KEY (id_projektu)
        REFERENCES uczelnia.projekty (id_projektu) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

-- 7. Dodaj do relacji PRZYDZIAŁY atrybut GODZINY typu liczbowego.
ALTER TABLE uczelnia.przydzialy
ADD COLUMN godziny numeric;

-- 8. Wyłącz tymczasowo sprawdzanie unikalności nazw projektów.
ALTER TABLE uczelnia.projekty
DROP CONSTRAINT proj_name_unique


-- 9. Zwiększ maksymalny rozmiar atrybutu Opis do 30 znaków.
ALTER TABLE uczelnia.projekty
ALTER COLUMN Opis TYPE VARCHAR(230);

-- 10. Wstaw pracownika o nazwisku Mostowiak do relacji PRACOWNICY.
-- Spróbuj założyć ograniczenie „wartość unikalna” na atrybucie nazwisko. Co się stało?
ALTER TABLE uczelnia.pracownicy
ADD CONSTRAINT unique_nazwisko UNIQUE (nazwisko);

INSERT INTO uczelnia.pracownicy (id_prac,nazwisko, imie, data_zatrudnienia, placa_pod)
VALUES (244,'Mostowiak', 'Jan', '2022-01-10', 5000.00);

-- 11. Utwórz relację PANSTWA_ADRESY zawierającą następujące atrybuty:
-- 	ID_PANSTWA, PANSTWO, ULICA, KOD_POCZTOWY, MIASTO, PROWINCJA i
-- wypełnij ją korzystając z mechanizmu tworzenia relacji w oparciu o zapytanie.
CREATE TABLE uczelnia.panstwa_adresy (
    ID_PANSTWA SERIAL PRIMARY KEY,
    PANSTWO VARCHAR(100),
    ULICA VARCHAR(100),
    KOD_POCZTOWY VARCHAR(10),
    MIASTO VARCHAR(100),
    PROWINCJA VARCHAR(50)
);

INSERT INTO uczelnia.panstwa_adresy (PANSTWO, ULICA, KOD_POCZTOWY, MIASTO, PROWINCJA)
VALUES ('Polska', 'ul. Kwiatowa 1', '00-001', 'Warszawa', 'Mazowieckie'),
       ('Niemcy', 'Musterstraße 123', '12345', 'Berlin', 'Berlin'),
       ('Francja', 'Rue de la Paix 7', '75001', 'Paryż', 'Île-de-France');

