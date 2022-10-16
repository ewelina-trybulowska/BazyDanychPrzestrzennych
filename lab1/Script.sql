
--1. Utwórz nową bazę danych nazywając ją firma.
create database firma

--2. Dodaj schemat o nazwie ksiegowosc. 
create schema ksiegowosc

SHOW search_path
SET search_path TO ksiegowosc

--3. Dodaj cztery tabele:
--• pracownicy (id_pracownika, imie, nazwisko, adres, telefon) 
--• godziny (id_godziny, data, liczba_godzin , id_pracownika) 
--• pensja (id_pensji, stanowisko, kwota) 
--• premia (id_premii, rodzaj, kwota) 
--• wynagrodzenie ( id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii)
CREATE TABLE ksiegowosc.pracownicy (
	id_pracownika INTEGER NOT NULL,
	imie VARCHAR(30) NOT NULL, 
	nazwisko VARCHAR(30) NOT NULL,
	adres VARCHAR(30) NOT NULL,
	telefon VARCHAR(30) NOT null
);
CREATE TABLE ksiegowosc.godziny (
	id_godziny INTEGER NOT NULL,
	data DATE NOT NULL,
	liczba_godzin INT NOT NULL,
	id_pracownika INT NOT null
);
CREATE TABLE ksiegowosc.pensja (
	id_pensji INTEGER NOT NULL,
	stanowisko VARCHAR(100) NOT NULL,
	kwota FLOAT(2) NOT null
);

CREATE TABLE ksiegowosc.premia(
	id_premii INTEGER NOT NULL,
	rodzaj VARCHAR(100) NOT NULL,
	kwota FLOAT(2) NOT null
);

CREATE TABLE ksiegowosc.wynagrodzenie(
	id_wynagrodzenia INTEGER NOT NULL,
	data DATE NOT NULL,
	id_pracownika INT NOT NULL,
	id_godziny INT NOT NULL,
	id_pensji INT NOT NULL,
	id_premii INT NOT NULL);


--przyjmując następujące założenia:
--i. typy atrybutów mają zostać dobrane tak, aby składowanie danych było optymalne,
--ii. klucz główny dla każdej tabeli oraz klucze obce tam, gdzie występują powiązania pomiędzy tabelami, 
ALTER TABLE ksiegowosc.pracownicy ADD PRIMARY KEY(id_pracownika);
ALTER TABLE ksiegowosc.godziny ADD PRIMARY KEY(id_godziny);
ALTER TABLE ksiegowosc.pensja ADD PRIMARY KEY(id_pensji);
ALTER TABLE ksiegowosc.premia ADD PRIMARY KEY(id_premii);
ALTER TABLE ksiegowosc.wynagrodzenie ADD PRIMARY KEY(id_wynagrodzenia);

ALTER TABLE ksiegowosc.godziny ADD FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy (id_pracownika) ;
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika) ;
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny(id_godziny);
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensja(id_pensji);
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premia(id_premii);

--iii. opisy/komentarze dla każdej tabeli – użyj polecenia COMMENT

COMMENT ON TABLE ksiegowosc.godziny IS 'Tabela z godzinami pracy';
COMMENT ON TABLE ksiegowosc.pensja IS 'Tabela pensji w zaleznosci od stanowiska ';
COMMENT ON TABLE ksiegowosc.pracownicy IS 'Tabela z danymi o pracownikach';
COMMENT ON TABLE ksiegowosc.premia IS 'Tabela z informacjami o premii';
COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 'Tabela z informacjami o wynagrodzeniu';

--4. Wypełnij każdą tabelę 10. rekordami.

INSERT INTO ksiegowosc.pracownicy(id_pracownika, imie, nazwisko, adres, telefon)
VALUES
(1, 'Jan', 'Kowalska', 'Bydgoszcz', '123456789'),
(2, 'Michal', 'Nowak', 'Torun', '666483746'),
(3, 'Kamil', 'Wisniewski', 'Gdansk', '444222777'),
(4, 'Karol', 'Kowalski', 'Krakow', '123123123'),
(5, 'Jacek', 'Kwiatkowski', 'Warszawa', '444222666'),
(6, 'Anna', 'Kowalska', 'Gdansk', '908786878'),
(7, 'Maja', 'Nowak', 'Katowice', '263845291'),
(8, 'Karolina', 'Kaminska', 'Poznan', '555999444'),
(9, 'Aneta', 'Szymanska', 'Warszawa', '999222444'),
(10, 'Paulina', 'Zieliska', 'Krakow', '999555777');

INSERT INTO ksiegowosc.godziny (id_godziny,data, liczba_godzin, id_pracownika) VALUES 
(1,'2022-01-15', 140, 1),
(2,'2022-02-10', 140, 2),
(3,'2022-03-12', 134, 3),
(4,'2022-04-07', 150, 4),
(5,'2022-05-03', 170, 5),
(6,'2022-06-10', 175, 6),
(7,'2022-07-06', 180, 7),
(8,'2022-08-17', 200, 8),
(9,'2022-09-09', 70, 9),
(10,'2022-10-04', 100, 10);

INSERT INTO ksiegowosc.pensja(id_pensji,stanowisko, kwota) 
VALUES 
(1,'chirurg', 45000),
(2,'fryzjer', 1700),
(3,'kucharz', 2500),
(4,'programista', 17000),
(5,'stażysta', 600),
(6,'nauczyciel', 2000),
(7,'manager', 6000),
(8,'team leader', 6500),
(9,'manager', 4200),
(10,'ogrodnik', 800);

INSERT INTO ksiegowosc.premia (id_premii, rodzaj, kwota) 
VALUES 
(1,'brak', 0),
(2,'swiateczna',400),
(3,'nadgodziny',200),
(4,'staz pracy', 200),
(5,'najlepszy pracownik', 500),
(6,'manager', 500),
(7,'regulaminowa', 300),
(8,'uznaniowa', 150),
(9,'motywacyjna', 200),
(10,'zadaniowa', 100);

INSERT INTO ksiegowosc.wynagrodzenie (id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii)
VALUES
(1,'2022-10-14', 1, 2, 10, 10),
(2,'2022-10-14', 2, 3, 9, 9), 
(3,'2022-10-14', 3, 4, 8, 4), 
(4,'2022-10-14', 4, 5, 7, 5), 
(5,'2022-10-14', 5, 6, 6, 6),
(6,'2022-10-14', 6, 7, 5, 8),
(7,'2022-10-14', 7, 8, 4, 7),
(8,'2022-10-14', 8, 9, 3, 3),
(9,'2022-10-14', 9, 10, 2, 2),
(10,'2022-10-14', 10, 1, 1, 1);





--5. Wykonaj następujące zapytania:
--a) Wyświetl tylko id pracownika oraz jego nazwisko. 
SELECT id_pracownika, nazwisko FROM pracownicy

--b) Wyświetl id pracowników, których płaca jest większa niż 1000. 

SELECT id_pracownika FROM wynagrodzenie
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE pensja.kwota > 1000;

--c) Wyświetl id pracowników nieposiadających premii, których płaca jest większa niż 2000. 
SELECT id_pracownika FROM wynagrodzenie
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
JOIN premia on wynagrodzenie.id_premii = premia.id_premii
WHERE pensja.kwota > 2000 AND premia.rodzaj = 'brak';

--d) Wyświetl pracowników, których pierwsza litera imienia zaczyna się na literę ‘J’. 
SELECT * FROM pracownicy WHERE imie LIKE 'J%'

--e) Wyświetl pracowników, których nazwisko zawiera literę ‘n’ oraz imię kończy się na literę ‘a’. 
SELECT * FROM pracownicy where nazwisko like '%n%' AND imie LIKE '%a'

--f) Wyświetl imię i nazwisko pracowników oraz liczbę ich nadgodzin, przyjmując, iż standardowy czas pracy to 160 
	--h miesięcznie. 
SELECT imie, nazwisko, liczba_godzin-160 as nadgodziny FROM pracownicy
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN godziny ON wynagrodzenie.id_godziny = godziny.id_godziny 
WHERE liczba_godzin > 160;

--g) Wyświetl imię i nazwisko pracowników, których pensja zawiera się w przedziale 1500 – 3000 PLN. 
SELECT imie, nazwisko FROM pracownicy
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji 
WHERE kwota>= 1500 AND kwota <= 3000;

--h) Wyświetl imię i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii. 
SELECT imie, nazwisko FROM pracownicy 
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN godziny ON wynagrodzenie.id_godziny = godziny.id_godziny 
JOIN premia ON wynagrodzenie.id_premii = premia.id_premii 
WHERE liczba_godzin > 160 AND premia.rodzaj LIKE 'brak'

--i) Uszereguj pracowników według pensji.
SELECT imie, nazwisko,kwota FROM pracownicy
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji 
ORDER BY kwota

--j) Uszereguj pracowników według pensji i premii malejąco. 
SELECT imie, nazwisko,pensja.kwota,premia.kwota FROM pracownicy
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji 
JOIN premia ON wynagrodzenie.id_premii = premia.id_premii 
ORDER BY pensja.kwota DESC,premia.kwota desc

--k) Zlicz i pogrupuj pracowników według pola ‘stanowisko’. 
SELECT stanowisko, COUNT(pracownicy.id_pracownika) FROM pracownicy
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji
GROUP BY stanowisko;

--l) Policz średnią, minimalną i maksymalną płacę dla stanowiska ‘kierownik’ (jeżeli takiego nie masz, to przyjmij 
	--dowolne inne). 


SELECT stanowisko, AVG(kwota), MIN(kwota), MAX(kwota) FROM pracownicy 
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji 
WHERE stanowisko LIKE 'manager'
group by stanowisko;

--m) Policz sumę wszystkich wynagrodzeń.
SELECT SUM(kwota) FROM pracownicy 
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji; 

--f) Policz sumę wynagrodzeń w ramach danego stanowiska. 
SELECT stanowisko, SUM(kwota) FROM pracownicy 
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji 
GROUP BY stanowisko;

--g) Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska. 
SELECT stanowisko,COUNT(pracownicy.id_pracownika) AS ilosc_premii, SUM(premia.kwota) FROM pracownicy 
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji 
JOIN premia ON wynagrodzenie.id_premii = premia.id_premii
GROUP BY stanowisko;

--h) Usuń wszystkich pracowników mających pensję mniejszą niż 1200 zł
ALTER TABLE pracownicy DISABLE TRIGGER ALL;
ALTER TABLE godziny DISABLE TRIGGER ALL;
ALTER TABLE wynagrodzenie DISABLE TRIGGER ALL;
ALTER TABLE pensja DISABLE TRIGGER ALL;
ALTER TABLE premia DISABLE TRIGGER ALL;

delete from pracownicy
WHERE id_pracownika IN ( SELECT pracownicy.id_pracownika FROM pracownicy
JOIN wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
JOIN pensja ON wynagrodzenie.id_pensji = pensja.id_pensji 
WHERE pensja.kwota<=1200)


