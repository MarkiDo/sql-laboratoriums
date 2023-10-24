-- 1. Wyświetl najniższą i najwyższą pensję podstawową
-- oraz różnicę dzielącą najlepiej i najgorzej zarabiających pracowników.

select
	max(placa_pod) as "najwyższa pensja podstawowa",
	min(placa_pod) as "najniższa pensja podstawowa",
	max(placa_pod) - min(placa_pod) as "różnica pensji"
from
	uczelnia.pracownicy

-- 2. Wyświetl średnie pensje dla wszystkich etatów.
-- Wyniki uporządkuj wg malejącej średniej pensji.

SELECT
	etat,
	round(avg(placa_pod),0) as "średnie pensje"
FROM
	uczelnia.pracownicy
GROUP BY etat
ORDER BY "średnie pensje"

-- 3. Wyświetl ilość państw z Azji.
SELECT
	count(id_panstwa)
FROM
	uczelnia.panstwa up
LEFT JOIN
	uczelnia.kontynenty uk
ON
	uk.id_kontynentu = up.id_kontynentu
WHERE
	uk.nazwa_kontynentu ilike 'azja'

-- 4. Znajdź sumaryczne miesięczne płace dla każdego zespołu.
-- Nie zapomnij o płacach dodatkowych!

SELECT
	up.id_zesp,
	SUM(up.placa_pod+up.placa_dod)
FROM
	uczelnia.pracownicy up
WHERE
	up.id_zesp IS NOT NULL
GROUP BY
	up.id_zesp

-- 5. Wyświetl numery zespołów, które zatrudniają więcej niż trzech pracowników.
-- Pomiń pracowników bez przydziału do zespołów. Wyniki uporządkuj wg malejącej liczby pracowników.

SELECT
	*
FROM (
	SELECT
		up.id_zesp,
		COUNT(up.id_zesp) as "liczba pracowników"
	FROM
		uczelnia.pracownicy up
	WHERE
		up.id_zesp IS NOT NULL
	GROUP BY
		up.id_zesp
)T
WHERE
	"liczba pracowników" > 3
ORDER BY
	"liczba pracowników" ASC

-- 6. Wyświetl średnie pensje wypłacane w ramach poszczególnych etatów i liczbę pracowników zatrudnionych na danym etacie.
-- Pomiń pracowników zatrudnionych po 1990 roku.
SELECT
	up.etat,
	ROUND(AVG(coalesce(placa_pod,0)+coalesce(placa_dod,0)),0) as "średnia pensja",
	COUNT(up.etat) as "liczba pracowników"
FROM
	uczelnia.pracownicy up
WHERE
	DATE_PART('YEAR',data_zatrudnienia)< 1990
GROUP BY
	up.etat

