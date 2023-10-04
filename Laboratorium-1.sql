-- 1.Odczytaj wszystkie dane z tabeli PANSTWA.
SELECT
	*
FROM
	uczelnia.adresy;
-- 2. Odczytaj ulicę i miasto wszystkich zespołów w tabeli ADRESY.
SELECT  ulica, miasto
	FROM uczelnia.adresy;

-- 3. Dla każdego pracownika oblicz jego dniówkę (1/20 płacy podstawowej) i wyświetl razem z jego imieniem i nazwiskiem.
SELECT
	nazwisko, imie, round(placa_pod/20,2)
FROM
	uczelnia.pracownicy;

-- 4. Dla każdego pracownika skonstruuj zdanie:
-- „XXX pracuje na etacie YYY i został zatrudniony ZZZ” gdzie XXX jest nazwiskiem pracownika, YYY jest nazwą jego etatu a ZZZ jest datą zatrudnienia.
--  Wykorzystaj operator konkatenacji poznany na wykładzie. Skonstruowanemu przez siebie wyrażeniu nadaj alias ZDANIE.
SELECT
	CONCAT(nazwisko, ' pracuje na etacie ', etat, ' i został zatrudniony ', data_zatrudnienia) as ZDANIE
FROM
	uczelnia.pracownicy;

-- 5. Dla każdego pracownika oblicz jego roczną płacę z uwzględnieniem płacy dodatkowej.
--  W wyniku ma się znaleźć imię i nazwisko (w jednej kolumnie jako konkatenacja) i obliczona roczna płaca pracownika.
--  Wyrażeniu obliczającemu roczną płacę nadaj alias „DOCHÓD”.
SELECT
	CONCAT(imie,' ',nazwisko) as pracownik,
	(coalesce(placa_pod,0)*12 + coalesce(placa_dod,0)*12) as dochód
FROM
	uczelnia.pracownicy;
-- 6. Znajdź identyfikatory państw, w których znajdują się adresy.
-- W wyniku identyfikatory państw nie mogą się powtórzyć.
SELECT
	id_panstwa
FROM
	uczelnia.adresy
group by
	id_panstwa

-- 7. Podaj nazwiska i miesięczną płacę pracowników (z uwzględnieniem płacy dodatkowej), którzy mają jakąś płacę dodatkową.
SELECT
	CONCAT(imie,' ',nazwisko) as pracownik,
	(coalesce(placa_pod,0) + coalesce(placa_dod,0)) as dochód
FROM
	uczelnia.pracownicy
WHERE
	placa_dod is not null

-- 8. Znajdź wszystkich pracowników, którzy pracują na etacie ASYSTENT albo SEKRETARKA i zarabiają mniej niż 900 złotych
-- lub takich pracowników, którzy posiadają pensję dodatkową.
-- Dla każdego ze znalezionych pracowników wyświetl jego nazwisko.

SELECT
    nazwisko
FROM
	uczelnia.pracownicy
WHERE
		placa_dod is not null
	OR
		etat=any(array['ASYSTENT','SEKRETARKA']) AND placa_pod <900