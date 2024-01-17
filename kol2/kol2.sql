-- 1. Wyświetl sumę kosztów z aliasem ‘SUMA’ dla zamówień sprzedawcy ze Skarżyska (użyj podzapytania).
SELECT
	sum(koszt) as "SUMA"
FROM
	uczelnia.zamowienia uz
LEFT JOIN
	uczelnia.sprzedawcy	us
ON
	uz.id_sprzedawcy = us.id_sprzedawcy
WHERE miasto ilike '%'||'Skarzysk'||'%'
	;


-- 2. Wyświetl wszystkie kolumny zamówień dla sprzedawcy, który ma największą
-- prowizję (użyj podzapytania).
SELECT *
FROM uczelnia.zamowienia uz
WHERE uz.id_sprzedawcy = (
    SELECT us.id_sprzedawcy
    FROM uczelnia.sprzedawcy us
    ORDER BY prowizja DESC
	LIMIT 1
);


-- 3. Wstaw do tabeli SPRZEDAWCY Darię Borowiecką z ID 3009, która zajmuje się
-- zamówieniami w Kazimierze Wielkiej z prowizją 0.13. Sprawdź, czy krotka została
-- zapisana w tabeli.
INSERT INTO uczelnia.sprzedawcy(
	id_sprzedawcy, nazwisko, imie, miasto, prowizja)
	VALUES (3009, 'Borowiecka', 'Daria', 'Kazimierz Wielki', 0.13)
RETURNING *	;

-- 4. Usuń najnowszą sprzedawczynię z tabeli SPRZEDAWCY.
DELETE FROM uczelnia.sprzedawcy
WHERE ID = (SELECT id_sprzedawcy FROM uczelnia.sprzedawcy WHERE ID = 3009);


-- 5. Utwórz relację MANDATY o następujących atrybutach i ograniczeniach:

CREATE TABLE IF NOT EXISTS uczelnia.mandaty
(
    nr_mandatu numeric(5,0) NOT NULL,
    nazwa character varying(40) COLLATE pg_catalog."default" NOT NULL,
	kwota numeric(5,2) NOT NULL,
    data_wstawienia date NOT NULL,
	punkty_karne numeric(3,0) NOT NULL,
 	kwota_min numeric(10,2) NOT NULL,
	kwota_max numeric(10,2) NOT NULL,

	CONSTRAINT mandaty_pkey PRIMARY KEY (nr_mandatu),
	CONSTRAINT mandaty_check_kwota_min CHECK (kwota_min >= 500),
	CONSTRAINT mandaty_check_kwota_max CHECK (kwota_max <= 100000)
)


-- 6. Dodaj do relacji MANDATY następujące atrybuty:
-- ● nr_sluzbowy policjanta jako wartość liczbową posiadającą max. 3 liczby (wartość
-- obowiązkowa)
-- ● stopień policjanta jako typ łańcuchowy o maksymalnym rozmiarze równym 50
-- (wartość nieobowiązkowa).
ALTER TABLE uczelnia.mandaty
ADD nr_sluzbowy numeric(3,0) NOT NULL,
ADD stopien_policjanta character varying(50) COLLATE pg_catalog."default";

-- 7. Zmień nazwę relacji MANDATY na nazwę GRZYWNA.
ALTER TABLE uczelnia.mandaty RENAME TO grzywna;

