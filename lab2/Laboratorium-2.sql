-- 1. Dla każdego adresu wygeneruj kod składający się z dwóch pierwszych liter jej prowincji
--  i jego kodu pocztowego.

SELECT id_adresu, ulica, kod_pocztowy, miasto, prowincja, id_panstwa,
concat(substring(prowincja,1,2),kod_pocztowy) as "kod"
	FROM uczelnia.adresy;

-- 2. Wyświetl imiona i płace podstawowe pracowników powiększone o 15%
--  i zaokrąglone do liczb całkowitych.

SELECT imie, round(placa_pod*0.15,2) as "extra"
	FROM uczelnia.pracownicy;

-- 3. Policz, ile lat pracuje każdy pracownik.
SELECT DATE_PART('YEAR',now())-DATE_PART('YEAR',data_zatrudnienia) as "iloscLatPracy"
	FROM uczelnia.pracownicy;

-- 4. Wyświetl nazwę dni tygodnia zatrudnienia pracowników z zespołu o nazwie naszego przedmiotu
--  z semestru zimowego 2022/23.
SELECT
	extract('DAY' FROM data_zatrudnienia)
FROM
	uczelnia.zespoly uz
LEFT JOIN
	uczelnia.pracownicy up
ON
	uz.id_zesp = up.id_zesp
WHERE
	uz.nazwa='BAZY DANYCH'

-- 5. Wyświetl informacje o wszystkich kontynentach wraz z nazwami kierunków, w których zlokalizowane są kontynenty.
-- Przyjmij, że Europa i Azja należą do kierunku Wschód, Ameryka należy do kierunku Zachód a Afryka należy do kierunku Południe.
--  Skorzystaj z wyrażenia CASE.
SELECT
	id_kontynentu,
	nazwa_kontynentu,
	CASE
		WHEN nazwa_kontynentu = 'EUROPA' OR nazwa_kontynentu = 'AZJA' THEN 'Wschód'
		WHEN nazwa_kontynentu = 'AMERYKA' THEN 'Zachód'
		WHEN nazwa_kontynentu = 'AFRYKA' THEN 'Południe'
	END as "Kierunek"
FROM uczelnia.kontynenty;

-- 6. Dla każdego pracownika wyświetl jego nazwisko, płacę podstawową i informację o tym,
-- czy jego pensja jest mniejsza, równa lub większa od 2136 złotych. Skorzystaj z wyrażenia CASE.
SELECT
	up.nazwisko,
	up.placa_pod,
	CASE
		WHEN up.placa_pod>2136 THEN 'penjsa większa od 2136'
		WHEN up.placa_pod=2136 THEN 'penjsa równa 2136'
		WHEN up.placa_pod<2136 THEN 'penjsa mniejsza od 2136'
	END

FROM
	uczelnia.pracownicy up

-- 7. Wyświetl nazwy etatów, na które przyjęto pracowników zarówno w 1992 jak i 1993 roku.
--  Skorzystaj z operatorów zbiorowych.
SELECT
	etat
FROM
	uczelnia.pracownicy up
WHERE extract('YEAR' FROM up.data_zatrudnienia) = 1992
UNION
SELECT
	etat
FROM
	uczelnia.pracownicy up
WHERE extract('YEAR' FROM up.data_zatrudnienia) = 1993



-- 8. Dla każdego pracownika wyświetl jego nazwisko, płacę podstawową i informację o tym,
--  czy jego pensja jest mniejsza, równa lub większa od 1850 złotych.
-- Wynik posortuj wg nazwisk pracowników. Skorzystaj z operatorów zbiorowych.


SELECT
	up.nazwisko,
	up.placa_pod,
	CASE
		WHEN up.placa_pod>1850 THEN 'penjsa większa od 1850'
	END
FROM
	uczelnia.pracownicy up
WHERE 	up.placa_pod>1850
UNION
SELECT
	up.nazwisko,
	up.placa_pod,
	CASE
		WHEN up.placa_pod=1850 THEN 'penjsa równa 1850'
	END
FROM
	uczelnia.pracownicy up
WHERE 	up.placa_pod=1850
UNION
SELECT
	up.nazwisko,
	up.placa_pod,
	CASE
		WHEN up.placa_pod<1850 THEN 'penjsa mniejsza od 1850'
	END
FROM
	uczelnia.pracownicy up
WHERE 	up.placa_pod<1850
ORDER BY
    nazwisko
