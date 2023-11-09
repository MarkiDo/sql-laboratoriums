-- 1. Wyświetl wszystkie kombinacje nazw etatów zaczynających się na literę A
-- i nazwisk pracowników na literę N.
SELECT
	etat
FROM
	uczelnia.pracownicy
WHERE
	SUBSTRING(etat,1,1)='A'
AND
	SUBSTRING(nazwisko,1,1)='N'


-- 2. Wyświetl nazwę kontynentu i nazwę państwa dla Europy i Afryki.
SELECT
	uk.nazwa_kontynentu,
	up.panstwo
FROM
	uczelnia.kontynenty uk
LEFT JOIN
	uczelnia.panstwa up
ON
	up.id_kontynentu = uk.id_kontynentu
WHERE
	uk.nazwa_kontynentu ilike any(array['Europa','Afryka'])


-- 3. Dla każdego zespołu wyświetl liczbę miast, w których znajdują się wszystkie zespoły.
SELECT
	COUNT(ua.miasto)
FROM
	uczelnia.zespoly uz
LEFT JOIN
	uczelnia.adresy ua
ON
	ua.id_adresu = uz.id_adresu
GROUP BY
	uz.id_zesp


-- 4. Dla każdego zespołu wyświetl liczbę zatrudnionych w nim pracowników.
-- W wyniku ma zostać uwzględniony zespół TECHNIKI CYFROWE, na którym nie zatrudniono żadnego pracownika.
SELECT
	count(up.id_zesp) as "liczba_zatrudnionych",
	uz.nazwa
FROM
	uczelnia.zespoly uz
LEFT JOIN
	uczelnia.pracownicy up
ON
	up.id_zesp = uz.id_zesp
GROUP BY
	uz.id_zesp
ORDER BY
	"liczba_zatrudnionych"

-- 5. Wyświetl dla każdego pracownika jego nazwisko, nazwisko jego szefa, adres zespołu pracownika i adres zespołu szefa.
-- Dobierz odpowiednio typy połączeń tak, aby wszyscy pracownicy znaleźli się w rozwiązaniu
-- (zarówno Ci nie przydzieleniu do zespołów, jak i ci bez szefów).
SELECT
	up.nazwisko as "nazwisko_pracownika",
	CASE
		WHEN
			ua.id_adresu IS NULL
		THEN
			'N/A'
		ELSE
			CONCAT(ua.ulica,', ',ua.miasto,', ',ua.id_panstwa)
	END as "adres_zespołu_pracownika",
	upp.nazwisko_szefa,
	upp.adres_szefa as "adres_zespołu_szefa"
FROM
	uczelnia.pracownicy up
LEFT JOIN
(
	SELECT
		id_prac,
		upp.nazwisko as "nazwisko_szefa",
		CONCAT(ua.ulica,', ',ua.miasto,', ',ua.id_panstwa ) as "adres_szefa"
	FROM
		uczelnia.pracownicy upp
	LEFT JOIN
		uczelnia.zespoly uz
	ON
		upp.id_zesp = uz.id_zesp
	LEFT JOIN
		uczelnia.adresy ua
	ON
		ua.id_adresu = uz.id_adresu
) upp
ON
	up.id_szefa=upp.id_prac
LEFT JOIN
	uczelnia.zespoly uz
ON
	up.id_zesp = uz.id_zesp
LEFT JOIN
	uczelnia.adresy ua
ON
	ua.id_adresu = uz.id_adresu

-- 6. Dla każdego państwa wyświetl liczbę znajdujących się w nich miasta.
-- Ćwiczenie wykonaj korzystając ze starej notacji połączeń.
SELECT
 	up.panstwo,
 	count(ua.miasto)
FROM
 	uczelnia.panstwa up,
 	uczelnia.adresy ua
WHERE
	up.id_panstwa = ua.id_panstwa
GROUP BY
	up.panstwo


-- 7. Wyświetl nazwiska, nazwy etatów, id zespołu oraz nazwy zespołów tych pracowników, których zespół nie zaczyna się na literę A.
SELECT
	up.etat,
	up.nazwisko,
	up.id_zesp,
	uz.nazwa
FROM
	uczelnia.pracownicy up
LEFT JOIN
	uczelnia.zespoly uz
ON
	up.id_zesp=uz.id_zesp
WHERE
	SUBSTRING(uz.nazwa,1,1)<>'A'

-- 8. Dla każdego pracownika wyświetl jego kategorię płacową i widełki płacowe w jakich mieści się pensja pracownika.
SELECT
	CONCAT(up.imie,' ',up.nazwisko) as "pracownik",
	ue.nazwa as "kategoria",
	CONCAT(ue.placa_od,'-',ue.placa_do) as "widełka_płacowa"
FROM
	uczelnia.pracownicy up
LEFT JOIN
	uczelnia.etaty ue
ON
	ue.nazwa = up.etat

-- 9. Wyświetl nazwiska, etaty, płace podstawowe, nazwy zespołów, ulice i miasta nie będących doktorantami.
-- Wyniki uszereguj zgodnie z malejącym wynagrodzeniem.
SELECT
	up.nazwisko,
	up.etat,
	up.placa_pod,
	uz.nazwa,
	ua.ulica,
	ua.miasto
FROM
	uczelnia.pracownicy up
LEFT JOIN
	uczelnia.zespoly uz
ON
	up.id_zesp = uz.id_zesp
LEFT JOIN
	uczelnia.adresy ua
ON
	ua.id_adresu = uz.id_adresu
WHERE
	up.etat not ilike 'doktorant'
ORDER BY
	up.placa_pod DESC

-- 10. Wyświetl nazwiska i numery pracowników wraz z numerami i nazwiskami ich szefów.
-- Uwzględnij również pracownika o nazwisku Pasieka (który nie ma szefa).
SELECT
	CONCAT(up.imie,' ',up.nazwisko) as "pracownik",
	up.id_prac,
	CONCAT(upp.imie,' ',upp.nazwisko) as "szef",
	upp.id_prac
FROM
	uczelnia.pracownicy up
LEFT JOIN
	uczelnia.pracownicy upp
ON
	up.id_szefa=upp.id_prac