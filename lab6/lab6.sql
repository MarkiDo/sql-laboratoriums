-- 1. Wykonaj trzy zapytania w których:
-- - Znaleźć największą wartość atrybutu ID_ZESP (ID_ZESP jest kluczem głównym) w tabeli ZESPOLY (za pomocą polecenia SELECT).
SELECT
    MAX(ID_ZESP) AS Najwieksze_ID_ZESP
FROM
    uczelnia.ZESPOLY;

-- - Wstawić do tabeli ZESPOLY nowy zespół o nazwie „KULTURA SLOWA” i wartości ID_ZESP większej od odczytanej poprzednio wartości (bez identyfikatora adresu).
INSERT INTO
    uczelnia.ZESPOLY (ID_ZESP, NAZWA)
VALUES
((SELECT MAX(ID_ZESP) + 1 FROM uczelnia.ZESPOLY), 'KULTURA SLOWA');

-- - Sprawdzić, czy krotka rzeczywiście została zapisana do tabeli.
SELECT
	*
FROM
	uczelnia.ZESPOLY
WHERE
	nazwa = 'KULTURA SLOWA'


-- 2. Wszystkim pracownikom zarabiającym mniej niż 70% najwyższej płacy podstawowej podnieś pensję o 30% średniej płacy w ich zespole.
WITH MaxSalary AS (
SELECT max(placa_pod)*0.7 AS LimitPensji from  uczelnia.pracownicy
)

UPDATE uczelnia.pracownicy
SET placa_pod = placa_pod + 0.3 * (
    SELECT AVG(placa_pod)
    FROM uczelnia.pracownicy up
    WHERE ID_ZESP = up.ID_ZESP
)
FROM MaxSalary
WHERE placa_pod < MaxSalary.LimitPensji;


-- 3. Usuń pracowników, którzy zarabiają więcej niż 1000 zł.
WITH MaxSalary AS (
SELECT max(placa_pod)*0.7 AS LimitPensji from  uczelnia.pracownicy
)

UPDATE uczelnia.pracownicy
SET placa_pod = placa_pod + 0.3 * (
    SELECT AVG(placa_pod)
    FROM uczelnia.pracownicy up
    WHERE ID_ZESP = up.ID_ZESP
)
FROM MaxSalary
WHERE placa_pod < MaxSalary.LimitPensji;


-- 4. Wstaw etat „STUDENT”. Jako płacę minimalną i maksymalną podaj odpowiednio 0 i 330 złotych.
INSERT INTO
	uczelnia.etaty
(nazwa, placa_od, placa_do)
VALUES ('STUDENT',0,330)

-- 5. Wstaw do relacji PRACOWNICY następujące wartości:
-- - ID_PRAC: podaj największą wartość ID_PRAC w tabeli PRACOWNICY zwiększoną o 10 (użyj zapytania)
-- - NAZWISKO: Twoje nazwisko - IMIE: Twoje imię
-- - DATA_ZATRUDNIENIA: aktualna data systemowa
-- - PLACA_POD: 500
-- - PLACA_DOD: 5% średniej płacy w zespole ANALIZA MATEMATYCZNA (użyj podzapytania)
-- - ETAT: ‘STUDENT’
-- - ID_SZEFA: 180
-- - ID_ZESP: Największa wartość
-- - ID_PRAC w tabeli PRACOWNICY zwiększona o 10 (użyj zapytania).

WITH MaxIDCTE AS (
    SELECT COALESCE(MAX(ID_PRAC), 0) + 10 AS MaxID
    FROM uczelnia.PRACOWNICY
)

INSERT INTO uczelnia.PRACOWNICY (ID_PRAC, NAZWISKO, IMIE, DATA_ZATRUDNIENIA, PLACA_POD, PLACA_DOD, ETAT, ID_SZEFA, ID_ZESP)
VALUES (
    (SELECT MaxID FROM MaxIDCTE),
    'Dobushovskyy',
    'Markiyan',
    CURRENT_DATE,
    500,
    0.05 * (
        SELECT AVG(PLACA_POD)
        FROM uczelnia.PRACOWNICY
        WHERE ID_ZESP = (
            SELECT MAX(ID_ZESP)
            FROM uczelnia.PRACOWNICY
        )
    ),
    'STUDENT',
    180,
    (
        SELECT MAX(ID_ZESP) + 10
        FROM uczelnia.PRACOWNICY
    )
);




-- 6. Pracownikom zespołu o nazwie 'TECHNIKI INFORMACYJNO-KOMUNIKACYJNE' daj 68% podwyżki.
UPDATE uczelnia.PRACOWNICY
SET placa_pod = placa_pod * 1.68
WHERE ID_ZESP = (
    SELECT ID_ZESP
    FROM uczelnia.ZESPOLY
    WHERE NAZWA = 'TECHNIKI INFORMACYJNO-KOMUNIKACYJNE'
)

-- 7. Usuń zespół na którym nie ma zatrudnionych żadnych pracowników.
DELETE
FROM
	uczelnia.ZESPOLY uz
WHERE NOT EXISTS (
    SELECT 1
    FROM uczelnia.PRACOWNICY up
    WHERE up.ID_ZESP = uz.ID_ZESP
);