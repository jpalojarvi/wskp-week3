Tehtävä 1. 
START TRANSACTION;
UPDATE tili
SET Saldo = Saldo - 100
WHERE Numero = 100;

UPDATE tili
SET Saldo = Saldo + 100
WHERE Numero = 103;

COMMIT;

SELECT Numero, Saldo FROM tili
WHERE Numero = 100 OR Numero = 103;

Tilin 100 Saldo: 1000 -> 900
Tilin 103 Saldo: 760 -> 860

Tehtävä 2.
START TRANSACTION; -lauseen jälkeen ja ROLLBACK; -komentoa edeltävien komentojen vaikuttuneet rivit on palautettu transaktion alkamisen edeltäneeseen tilaan.
Tilin 100 Saldo: 900 -> 900
Tilin 103 Saldo: 860 -> 860

Tehtävä 3.
Sessio 1:
START TRANSACTION;
UPDATE tili
SET Saldo = Saldo - 200
WHERE Numero = 101;

UPDATE tili
SET Saldo = Saldo + 200
WHERE Numero = 102;

SELECT Numero, Saldo FROM tili
WHERE Numero = 101 OR Numero = 102;

Tilin 101 Saldo: 2800,00 -> 2600,00
Tilin 102 Saldo: 1342,57 -> 1542,57

Sessio 2:
SELECT Numero, Saldo FROM tili
WHERE Numero = 101 OR Numero = 102;

Tilin 101 Saldo: 2800,00 -> 2800,00
Tilin 102 Saldo: 1342,57 -> 1342,57

Tilien saldo on päivittynyt vain ensimmäisessä ikkunassa.

Tehtävä 4.
Sessio 1:
COMMIT;

Sessio 2:
SELECT Numero, Saldo FROM tili
WHERE Numero = 101 OR Numero = 102;

Tilin 101 Saldo: 2800,00 -> 2600,00
Tilin 102 Saldo: 1342,57 -> 1542,57

Ensimmäisen session päivitykset ovat sitoutuneet, ja muutokset näkyvät nyt myös toisessa sessiossa.

Tehtävä 5., kaksiosainen tehtävä:
Sessio 1:
START TRANSACTION;
UPDATE tili
SET Saldo = 0
WHERE Numero = 105;

Tilin 105 Saldo: 138 740,69 -> 0

Sessio 2:
START TRANSACTION;
SELECT Numero, Saldo FROM tili
WHERE Numero = 105;

SELECT Numero, Saldo FROM tili
WHERE Numero = 105;

SELECT Numero, Saldo FROM tili
WHERE Numero = 105;

Tilin 105 Saldo: 138 740,69 -> 138 740,69

Sessio 1:
ROLLBACK;

Tilin 105 Saldo: 0 -> 138 740,69

Tehtävä 5., kahdeksanosainen tehtävä:
* 1. 
Sessio 1: 
START TRANSACTION;

* 2.
Sessio 2: 
START TRANSACTION;

* 3.
Sessio 2: 
SELECT Numero, Saldo FROM tili
WHERE Numero = 105;

Tilin 105 Saldo: 138 740,69

* 4.
Sessio 1:
UPDATE tili
SET Saldo = 0
WHERE Numero = 105;

* 5.
Sessio 2:
SELECT Numero, Saldo FROM tili
WHERE Numero = 105;

Tilin 105 Saldo: 138 740,69

* 6.
Sessio 1:
COMMIT;

* 7.
Sessio 2:
SELECT Numero, Saldo FROM tili
WHERE Numero = 105;
Tilin 105 Saldo: 138 740,69

* 8.
Sessio 2:
COMMIT;

SELECT Numero, Saldo FROM tili
WHERE Numero = 105;
Tilin 105 Saldo: 0


Mitä tapahtuu, miten sitoutumattoman transaktionj luku (rivi 5) käsitellään:
Koska tietokantaan on kaksi avointa yhteyttä ja molemmissa on keskeneräinen transaktio, ensimmäisen session transaktio ei näy vielä sitoutuksen jälkeenkään ennen kuin toisenkin session transaktio on päättynyt. Molemmilla sessioilla on siis oma instanssinsa tietokannasta.

Tehtävä 6.
Sessio 1:
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

UPDATE tili
SET Saldo = 1000
WHERE Numero = 105;

SELECT Numero, Saldo FROM tili
WHERE Numero = 105;

Tilin 105 Saldo: 1000


Sessio 2:
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT Numero, Saldo FROM tili
WHERE Numero = 105;
Tilin 105 Saldo: 1000

Tehtävän 5. transaktiot uudelleen READ UNCOMMITTED-eristystasolla:
* 1. 
Sessio 1: 
START TRANSACTION;

* 2.
Sessio 2: 
START TRANSACTION;

* 3.
Sessio 2: 
SELECT Numero, Saldo FROM tili
WHERE Numero = 105;

Tilin 105 Saldo: 1000

* 4.
Sessio 1:
UPDATE tili
SET Saldo = 0
WHERE Numero = 105;

* 5.
Sessio 2:
SELECT Numero, Saldo FROM tili
WHERE Numero = 105;

Tilin 105 Saldo: 0

* 6.
Sessio 1:
COMMIT;

* 7.
Sessio 2:
SELECT Numero, Saldo FROM tili
WHERE Numero = 105;
Tilin 105 Saldo: 0

* 8.
Sessio 2:
COMMIT;

SELECT Numero, Saldo FROM tili
WHERE Numero = 105;
Tilin 105 Saldo: 0


Miten toiminta poikkeaa aiemmasta:
Ensimmäisen session transaktion muutokset näkyvät heti myös toisessa sessiossa, jo ennen sitouttamista.

Tehtävä 7. 
Sessio 1:
UPDATE tili
SET Saldo = 1000
WHERE Numero = 105;

Tilin 105 Saldo: 1000

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;

Sessio 2:
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;

Tehtävän 5. transaktiot uudelleen SERIALIZABLE-eristystasolla:
* 1. 
Sessio 1: 
START TRANSACTION;

* 2.
Sessio 2: 
START TRANSACTION;

* 3.
Sessio 2: 
SELECT Numero, Saldo FROM tili
WHERE Numero = 105;

Tilin 105 Saldo: 1000

* 4.
Sessio 1:
UPDATE tili
SET Saldo = 0
WHERE Numero = 105;

* 5.
Sessio 2:
SELECT Numero, Saldo FROM tili
WHERE Numero = 105;

Tilin 105 Saldo: 1000



* 6.
Sessio 1:
COMMIT;
Ensimmäinen sessio jää odottamaan ensimmäisen session transaktion loppumista.

Menee noin minuutti, ja ensimmäinen istunto herjaa TRANSACTION TIMEOUT.
Tapahtuu automaattinen ROLLBACK.

* 7.
Sessio 2:
SELECT Numero, Saldo FROM tili
WHERE Numero = 105;
Tilin 105 Saldo: 1000
Ensimmäisen session transaktio ei mennyt läpi.


* 8.
Sessio 2:
COMMIT;

SELECT Numero, Saldo FROM tili
WHERE Numero = 105;
Tilin 105 Saldo: 1000


Miten toiminta poikkeaa aiemmasta:
Samoja tietueita koskevia päivityksiä ei pystytä toteuttamaan yhtäaikaa kyseisellä eristystasolla.

Tehtävä 8:
