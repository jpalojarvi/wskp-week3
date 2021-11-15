Tehtävä 1:
CREATE VIEW ttlista
AS
SELECT Tyontekijanumero, Etunimi, Sukunimi, Lahiosoite, tyontekija.Postinumero, Postitoimipaikka
FROM tyontekija, postitus
WHERE tyontekija.Postinumero = postitus.Postinumero;

Tehtävä 2:
SELECT *
FROM ttlista
WHERE Sukunimi = 'Virtanen'
ORDER BY Tyontekijanumero;

Tehtävä 3:
SHOW FULL TABLES;
Näyttää kaikki taulut ja niiden tyypit; onko kyseessä perustaulu vai näkymä. Kaikki muut ovat perustauluja paitsi ttlista, joka on näkymä.

Tehtävä 4:
UPDATE tyontekija
SET Etunimi = 'Tauno'
WHERE Tyontekijanumero = 198874;

SELECT *
FROM ttlista
WHERE Tyontekijanumero = 198874;

Havaitaan, että työntekijän 198874 'Daniel Virtanen' etunimi on muuttunut 'Tauno':ksi.

Tehtävä 5:
UPDATE ttlista
SET Sukunimi = 'Kauriainen'
WHERE Tyontekijanumero = 15236;

SELECT *
FROM tyontekija
WHERE Tyontekijanumero = 15236;

Eelis 'Tauriainen' sukunimi on muuttunut nimeksi 'Kauriainen' myös tyontekija-taulussa.

Tehtävä 6:
UPDATE ttlista
SET Postitoimipaikka = 'Vihti'
WHERE Tyontekijanumero = 15236;

SELECT *
FROM tyontekija
INNER JOIN postitus
ON tyontekija.Postinumero = postitus.Postinumero
WHERE Tyontekijanumero = 15236;

Nähdään, että Eeliksen Postitoimipaikaksi on vaihtunut 'Vihti', mutta Postinumero on pysynyt ennallaan.
Postinumero 00940 sijaitsee tosiasiassa Kontulassa Helsingissä. Oletettavasti taulukossa ei ole asetettu rajoituksia Postinumeron ja Postitoimipaikan välille.

Päivityksen ei pitäisi kuitenkaan olla vaikuttanut muihin henkilöihin, koska:
/* Affected rows: 1  Found rows: 0  Warnings: 0  Duration for 1 query: 0,000 sec. */

Tehtävä 7:
SELECT COUNT(PuheluID), AVG(Hinta), MIN(Hinta), MAX(Hinta)
FROM puhelu;

CREATE VIEW puhelunakyma
AS
SELECT COUNT(PuheluID), AVG(Hinta), MIN(Hinta), MAX(Hinta)
FROM puhelu;

SELECT * FROM puhelunakyma;

Tehtävä 8:
CREATE USER 'dbuserr'@'localhost' IDENTIFIED BY 'dbpass';

CREATE DATABASE julkinen;

GRANT SELECT ON julkinen.* TO 'dbuser'@'localhost';

USE julkinen;

CREATE VIEW ttlista
AS
SELECT Tyontekijanumero, Etunimi, Sukunimi, Lahiosoite, tyontekija.Postinumero, Postitoimipaikka
FROM isofirma.tyontekija, isofirma.postitus
WHERE tyontekija.Postinumero = postitus.Postinumero;

*Logout*

*Login AS dbuserr*

SELECT * FROM ttlista
WHERE Tyontekijanumero = 15236;

Näkymän tiedot tulevat näkyville, mutta ei mitään muuta, koska käyttäjälle ei ole annettu mitään muita oikeuksia.

Tehtävä 9:
UPDATE ttlista
SET Sukunimi = 'Mauriainen'
WHERE Tyontekijanumero = 15236;

SQL Error (1142): UPDATE command denied to user 'dbuserr'@'localhost' for table 'ttlista' query

Käyttäjällä dbuserr ei ole mitään keinoa muuttaa sukunimeä, ellei se saa UPDATE-oikeutta root-tunnukselta.

Tehtävä 10:
*Logout*

*Login AS root*

CREATE VIEW isopalkkaiset
AS
SELECT *
FROM tyontekija
WHERE Palkka > 5000;

UPDATE isopalkkaiset  
SET Palkka = 4800
WHERE Tyontekijanumero = 994;

SELECT * FROM isopalkkaiset;

Päivitys onnistui, koska käytössä on root-tunnus jolla on käytössä kaikki mahdolliset oikeudet.
Ohto Majaoja (944) katoaa näkymästä isopalkkaiset, koska putoaa alle 5000e/kk vaatimuksen.

Tehtävä 11:
UPDATE tyontekija
SET Palkka = 5500
WHERE Tyontekijanumero = 994;

DROP VIEW isopalkkaiset;

CREATE VIEW isopalkkaiset
AS
SELECT *
FROM tyontekija
WHERE Palkka > 5000
WITH CHECK OPTION;

UPDATE isopalkkaiset  
SET Palkka = 4800
WHERE Tyontekijanumero = 994;

/* SQL Error (1369): CHECK OPTION failed `isofirma`.`isopalkkaiset` */

Koska näkymässä on käytössä CHECK OPTION, näkymään ei pysty tekemään muutoksia jotka pudottaisivat tietueen näkymästä, kuten em. UPDATE-lauseketta.