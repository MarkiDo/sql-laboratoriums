-- 1.Wyświetl nazwiska i etaty pracowników pracujących w tym samym zespole co pracownik o nazwisku Brazil
-- (załóż, że w zbiorze pracowników istnieje tylko jedna Brazil).
SELECT
	nazwisko,
	etat
FROM
	uczelnia.pracownicy
WHERE
	id_zesp in (
		SELECT
			id_zesp
		FROM
			uczelnia.pracownicy
		WHERE
			nazwisko = 'Brazil'
		LIMIT 1
);

-- 2. Wyświetl najdłużej pracujących pracowników każdego etatu.
-- Uszereguj wyniki zgodnie z kolejnością zatrudnienia.

SELECT
  etat,
  imie,
  nazwisko,
  data_zatrudnienia
FROM (
  SELECT
    etat,
    imie,
    nazwisko,
    data_zatrudnienia,
    ROW_NUMBER() OVER(PARTITION BY etat ORDER BY data_zatrudnienia ASC) as r
  FROM
    uczelnia.pracownicy
) AS ranked
WHERE r = 1;

-- 3. Wyświetl dane zespołów, które nie zatrudniają żadnych pracowników.
SELECT a
	uz.*
FROM
	uczelnia.zespoly uz
LEFT JOIN
   uczelnia.pracownicy up
ON
 uz.id_zesp = up.id_zesp
WHERE
 up.id_zesp is null


-- 4. Wyświetl nazwiska tych profesorów, którzy wśród swoich podwładnych nie mają żadnych doktorantów.
SELECT
upp.nazwisko
FROM
	uczelnia.pracownicy upp
LEFT JOIN
(
	SELECT
*
FROM
	uczelnia.pracownicy upd
WHERE etat ILIKE 'doktorant'
)upd ON
	upd.id_szefa = upp.id_prac
WHERE
	upp.etat ILIKE '%profesor%'	 AND upd.id_prac IS NULL


-- 5. Podaj nazwę kontynentu zawierającego najwięcej państw w bazie danych.

SELECT
	COUNT(up.id_panstwa),
	uk.nazwa_kontynentu
FROM
	uczelnia.kontynenty uk
LEFT JOIN
	uczelnia.panstwa up
ON
	up.id_kontynentu = uk.id_kontynentu
GROUP BY
	up.id_kontynentu,uk.nazwa_kontynentu
ORDER BY count

-- 6. Stosując podzapytanie skorelowane wyświetl informacje o zespole nie zatrudniającym żadnych pracowników.
SELECT
 nazwa
FROM
  uczelnia.zespoly Z
WHERE
  NOT EXISTS (
    SELECT 1
    FROM uczelnia.pracownicy P
    WHERE P.id_zesp = Z.id_zesp
  );

-- 7. Wyświetl nazwiska i pensje trzech najlepiej zarabiających pracowników
SELECT
nazwisko,
placa_pod+coalesce(placa_dod,0) as pensja
FROM
	uczelnia.pracownicy
ORDER BY
placa_pod+coalesce(placa_dod,0) DESC
LIMIT 3