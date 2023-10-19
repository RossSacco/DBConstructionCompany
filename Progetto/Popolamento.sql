-- trigger popolamento
DROP TRIGGER IF EXISTS PopolamentoSensore;
DROP TRIGGER IF EXISTS PopolamentoRegistri;
DROP TRIGGER IF EXISTS PopolamentoAlert;
DROP TRIGGER IF EXISTS PopolamentoAlertMultivalore;

-- TRIGGER POPOLAMENTO Sensore

DELIMITER $$

CREATE TRIGGER PopolamentoSensore 
BEFORE INSERT ON Sensore
FOR EACH ROW
BEGIN

DECLARE posx INTEGER DEFAULT 0;
DECLARE posz INTEGER DEFAULT 0;
SELECT V1.Larghezza,V1.Altezza INTO posx,posz
FROM Vano V1
WHERE V1.IDVano = NEW.IDVano;

SET NEW.PosizioneX=rand()*(posx - 0 + 1)+0;
SET NEW.PosizioneY=0;
SET NEW.PosizioneZ=rand()*(posz - 0 + 1)+0;
SET NEW.SogliaDiSicurezza=FLOOR(RAND()*(9 - 6 + 1)+6);

END $$

DELIMITER ;

-- TRIGGER POPOLAMENTO Registro e RegistroMultivalore

DELIMITER $$

CREATE TRIGGER PopolamentoRegistri
AFTER INSERT ON Sensore
FOR EACH ROW
BEGIN

DECLARE i INTEGER DEFAULT 10000;
DECLARE j INTEGER DEFAULT (RAND()*(80 - 60 + 1) + 60);
DECLARE t INTEGER DEFAULT 0;

-- LIVELLO PRECIPITAZIONI

IF NEW.TipoSensore='Livello Precipitazioni' THEN
BEGIN
-- inserimento valori che generano alert
WHILE j > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY -INTERVAL t MINUTE-INTERVAL t SECOND, FLOOR(RAND()*(500 - 201 + 1) + 201), FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET t = t + 1;

END WHILE ;
-- inserimento valori che non generano alert
WHILE i > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t MINUTE, FLOOR(RAND()*(200 - 0 + 1) + 0), FLOOR(RAND()*(6 - 1 + 1) + 1 ) ); 
SET i = i -1;
SET t = t + 1;

END WHILE ;
END ;
END IF;


-- TEMPERATURA INTERNA

IF NEW.TipoSensore='Temperatura Interna' THEN
BEGIN

-- inserimento valori che generano alert
WHILE j > 35 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, RAND()*(40 - 30 + 1) + 30, FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET t = t + 1;

END WHILE;

WHILE j > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, RAND()*(14 - 8 + 1) + 8, FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET t = t + 1;

END WHILE ;
 
-- inserimento valori che non generano alert
WHILE i > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t MINUTE, RAND()*(29 - 15 + 1) + 15, FLOOR(RAND()*(5 - 1 + 1) + 1 ) ); 
SET i = i -1;
SET t = t + 1;

END WHILE ;

END ;
END IF;


-- TEMPERATURA ESTERNA


IF NEW.TipoSensore='Temperatura Esterna' THEN
BEGIN

-- inserimento valori che generano alert
WHILE j > 35 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, RAND()*(45 - 35 + 1) + 35, FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET t = t + 1;

END WHILE;

WHILE j > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, RAND()*(-5 - -13 + 1) + -13, FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET t = t + 1;

END WHILE ;
 
-- inserimento valori che non generano alert
WHILE i > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t MINUTE, RAND()*(32 - -4 + 1) + -4, FLOOR(RAND()*(5 - 1 + 1) + 1 ) ); 
SET i = i -1;
SET t = t + 1;

END WHILE ;

END ;
END IF;


-- UMIDITA' INTERNA

IF NEW.TipoSensore='Umidità Interna' THEN
BEGIN

-- inserimento valori che generano alert
WHILE j > 35 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, FLOOR(RAND()*(90 - 70 + 1) + 70), FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET t = t + 1;

END WHILE;

WHILE j > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND , FLOOR(RAND()*(35 - 10 + 1) + 10), FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET t = t + 1;

END WHILE ;
 
-- inserimento valori che non generano alert
WHILE i > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t MINUTE, FLOOR(RAND()*(65 - 40 + 1) + 40), FLOOR(RAND()*(5 - 1 + 1) + 1 ) ); 
SET i = i -1;
SET t = t + 1;

END WHILE ;

END ;
END IF;


-- UMIDITA' ESTERNA

IF NEW.TipoSensore='Umidità Esterna' THEN
BEGIN

-- inserimento valori che generano alert
WHILE j > 35 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, FLOOR(RAND()*(90 - 75 + 1) + 75), FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET  t= t +1;


END WHILE;

WHILE j > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, FLOOR(RAND()*(30 - 10 + 1) + 10), FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET  t= t +1;


END WHILE ;
 
-- inserimento valori che non generano alert
WHILE i > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t MINUTE, FLOOR(RAND()*(70 - 40 + 1) + 40), FLOOR(RAND()*(5 - 1 + 1) + 1 ) ); 
SET i = i -1;
SET  t= t +1;


END WHILE ;

END ;
END IF;


-- POSIZIONE

IF NEW.TipoSensore='Posizione' THEN
BEGIN

-- inserimento valori che generano alert
WHILE j > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, FLOOR(RAND()*(40 - 12 + 1) + 11), FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET  t= t +1;


END WHILE;
 
-- inserimento valori che non generano alert
WHILE i > 0 DO

INSERT INTO registro(idSensore,Timestamp,Valore,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t MINUTE, FLOOR(RAND()*(10 - 0.1 + 1) + 0.1), FLOOR(RAND()*(5 - 1 + 1) + 1 ) ); 
SET i = i -1;
SET  t= t +1;


END WHILE ;

END ;
END IF;


-- ACCELEROMETRO

IF NEW.TipoSensore='Accelerometro' THEN
BEGIN

-- inserimento valori che generano alert
WHILE j > 35 DO

INSERT INTO registromultivalore(idSensore,Timestamp,ValoreX,ValoreY,ValoreZ,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, RAND()*( 0.3 - 0.11 + 1) + 0.11, RAND()*( 0.3 - 0.11 + 1) + 0.11, RAND()*( 0.3 - 0.11 + 1) + 0.11, FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET  t= t +1;


END WHILE;

WHILE j > 0 DO

INSERT INTO registromultivalore(idSensore,Timestamp,ValoreX,ValoreY,ValoreZ,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, RAND()*( -0.11 - -0.3 + 1) + -0.3, RAND()*( -0.11 - -0.3 + 1) + -0.3, RAND()*( -0.11 - -0.3 + 1) + -0.3, FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET  t= t +1;


END WHILE ;
 
-- inserimento valori che non generano alert
WHILE i > 0 DO

INSERT INTO registromultivalore(idSensore,Timestamp,ValoreX,ValoreY,ValoreZ,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t MINUTE, RAND()*(0.1 - -0.1 + 1) + -0.1, RAND()*(0.1 - -0.01 + 1) + -0.01, RAND()*(0.1 - -0.01 + 1) + -0.01, FLOOR(RAND()*(5 - 1 + 1) + 1 ) ); 
SET i = i -1;
SET  t= t +1;


END WHILE ;

END ;
END IF;


-- GIROSCOPIO

IF NEW.TipoSensore='Giroscopio' THEN
BEGIN

-- inserimento valori che generano alert
WHILE j > 35 DO

INSERT INTO registromultivalore(idSensore,Timestamp,ValoreX,ValoreY,ValoreZ,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, RAND()*( 0.3 - 0.11 + 1) + 0.11, RAND()*( 0.3 - 0.11 + 1) + 0.11, RAND()*( 0.3 - 0.11 + 1) + 0.11, FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET  t= t +1;


END WHILE;

WHILE j > 0 DO

INSERT INTO registromultivalore(idSensore,Timestamp,ValoreX,ValoreY,ValoreZ,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t DAY-INTERVAL t MINUTE-INTERVAL t SECOND, RAND()*( -0.11 - -0.3 + 1) + -0.3, RAND()*( -0.11 - -0.3 + 1) + -0.3, RAND()*( -0.11 - -0.3 + 1) + -0.3, FLOOR(RAND()*(10 - 7 + 1) + 7 ) );
SET j = j - 1;
SET  t= t +1;


END WHILE ;
 
-- inserimento valori che non generano alert
WHILE i > 0 DO

INSERT INTO registromultivalore(idSensore,Timestamp,ValoreX,ValoreY,ValoreZ,SogliaStimata) VALUES(NEW.idSensore,CURRENT_TIMESTAMP() - INTERVAL t MINUTE, RAND()*(0.1 - -0.1 + 1) + -0.1, RAND()*(0.1 - -0.01 + 1) + -0.01, RAND()*(0.1 - -0.01 + 1) + -0.01, FLOOR(RAND()*(5 - 1 + 1) + 1 ) ); 
SET i = i -1;
SET  t= t +1;


END WHILE ;

END ;
END IF;

END $$

DELIMITER ;



-- TRIGGER POPOLAMENTO ALERT

DELIMITER $$

CREATE TRIGGER PopolamentoAlert
AFTER INSERT ON registro
FOR EACH ROW
BEGIN

DECLARE Soglia INTEGER DEFAULT 1;

SELECT S.SogliaDiSicurezza INTO Soglia
FROM sensore S
WHERE S.idSensore=NEW.idSensore;

IF NEW.SogliaStimata > Soglia THEN

INSERT INTO Alert (idSensore,Timestamp) VALUES (NEW.idSensore,NEW.Timestamp);

END IF ;
END $$
DELIMITER ;



-- TRIGGER POPOLAMENTO ALERTMULTIVALORE

DELIMITER $$

CREATE TRIGGER PopolamentoAlertMultivalore
AFTER INSERT ON registromultivalore
FOR EACH ROW
BEGIN

DECLARE Soglia INTEGER DEFAULT 1;

SELECT S.SogliaDiSicurezza INTO Soglia
FROM sensore S
WHERE S.idSensore=NEW.idSensore;

IF NEW.SogliaStimata >= Soglia THEN

INSERT INTO AlertMultivalore (idSensore,Timestamp) VALUES (NEW.idSensore,NEW.Timestamp);

END IF ;
END $$
DELIMITER ;


-- AREAGEOGRAFICA
insert into AreaGeografica (IdArea, Nome, Superficie, Latitudine, Longitudine) values (1, 'Palermo', 158.9, 38.13205, 13.33561);
insert into AreaGeografica (IdArea, Nome, Superficie, Latitudine, Longitudine) values (2, 'Rabat', 117, 34.02241, 34.02241 -6.83454);
insert into AreaGeografica (IdArea, Nome, Superficie, Latitudine, Longitudine) values (3, 'Mosca', 2501.59, 55.75222, 37.61556);
insert into AreaGeografica (IdArea, Nome, Superficie, Latitudine, Longitudine) values (4, 'Sarajevo', 141.5, 43.84864, 18.35644 );
insert into AreaGeografica (IdArea, Nome, Superficie, Latitudine, Longitudine) values (5, 'Buenos Aires', 203.49, -34.60757,  -58.43709);
insert into AreaGeografica (IdArea, Nome, Superficie, Latitudine, Longitudine) values (6, 'Toronto', 630.22, 43.70011, -79.4163);


-- EDIFICIO
insert into Edificio (IDEdificio, Tipologia, idArea) values (1, 'Condominio', 6);
insert into Edificio (IDEdificio, Tipologia, idArea) values (2, 'Casa Familiare', 3);
insert into Edificio (IDEdificio, Tipologia, idArea) values (3, 'Villa', 1);
insert into Edificio (IDEdificio, Tipologia, idArea) values (4, 'Bilocale', 2);
insert into Edificio (IDEdificio, Tipologia, idArea) values (5, 'Monolocale', 3);
insert into Edificio (IDEdificio, Tipologia, idArea) values (6, 'Casa Familiare', 4);
insert into Edificio (IDEdificio, Tipologia, idArea) values (7, 'Condominio', 5);


-- PIANO
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (1, 1, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (2, 1, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (3, 1, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (4, 1, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (5, 1, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (1, 2, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (2, 2, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (1, 3, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (2, 3, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (3, 3, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (1, 4, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (1, 5, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (1, 6, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (2, 6, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (1, 7, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (2, 7, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (3, 7, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (4, 7, 0);
insert into Piano (NumeroPiano, IDEdificio, Superficie) values (5, 7, 0);


-- VANO
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (24767, 7, 5, 4, 'Camera', 1, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (21719, 7, 8, 5, 'Cucina', 1, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (19177, 7, 5, 4, 'Bagno', 1, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (30890, 7, 6, 4, 'Camera', 1, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (599, 8, 7, 5, 'Sala', 1, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (2586, 5, 8, 3, 'Bagno', 1, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (15712, 8, 7, 4, 'Bagno', 1, 3);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (32499, 6, 3, 5, 'Cucina', 1, 3);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (7505, 3, 8, 3, 'Camera', 1, 3);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (1848, 8, 8, 3, 'Bagno', 1, 4);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (12853, 4, 8, 3, 'Sala', 1, 4);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (13905, 4, 3, 5, 'Camera', 1, 4);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (23257, 5, 5, 4, 'Camera', 1, 5);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (6126, 5, 6, 4, 'Sala', 1, 5);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (27768, 3, 5, 5, 'Bagno', 1, 5);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (15372, 4, 6, 3, 'Sala', 2, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (25897, 3, 3, 4, 'Cucina', 2, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (22532, 6, 5, 4, 'Bagno', 2, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (32118, 3, 3, 5, 'Studio', 2, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (6020, 5, 3, 3, 'Camera', 2, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (26006, 8, 7, 3, 'Camera', 2, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (3803, 6, 5, 3, 'Bagno', 2, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (13550, 7, 3, 3, 'Cucina', 3, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (27267, 7, 5, 5, 'Sala', 3, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (19356, 4, 4, 3, 'Bagno', 3, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (12854, 7, 5, 5, 'Sala', 3, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (22738, 8, 3, 3, 'Bagno', 3, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (9927, 7, 6, 3, 'Studio', 3, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (13101, 5, 6, 4, 'camera', 3, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (5425, 8, 8, 5, 'Camera', 3, 3);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (1340, 6, 4, 5, 'Camera', 3, 3);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (7021, 4, 8, 5, 'Bagno', 3, 3);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (18471, 3, 8, 4, 'Camera', 4, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (30351, 5, 5, 5, 'Sala', 4, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (21523, 4, 3, 3, 'Camera', 5, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (22700, 8, 4, 3, 'Sala', 5, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (19765, 4, 7, 4, 'Camera', 6, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (16833, 4, 7, 3, 'Sala', 6, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (9792, 4, 7, 4, 'Bagno', 6, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (24567, 7, 5, 4, 'Camera', 7, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (23719, 7, 8, 5, 'Cucina', 7, 1);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (19117, 7, 5, 4, 'Bagno', 7, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (30880, 7, 6, 4, 'Camera', 7, 2);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (59966, 8, 7, 5, 'Sala', 7, 3);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (258613, 5, 8, 3, 'Bagno', 7, 3);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (15714, 8, 7, 4, 'Camera', 7, 4);
insert into Vano (IDVano, Larghezza, Lunghezza, Altezza, Funzione, IDEdificio, NumeroPiano) values (32469, 6, 3, 5, 'Camera', 7, 5);

-- FINESTRA

insert into Finestra (IdFinestra, Larghezza, Altezza, PuntoCardinale, IDVano) values (730, 1.21, 1.02, 'NW',24767);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (164, 1.13, 0.87, 'E', 21719);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (697, 0.88, 1.39, 'W', 19177);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (254, 0.86, 0.98, 'E', 30890);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (335, 1.25, 1.33, 'NW',599);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (212, 0.89, 1.31, 'E', 2586);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (129, 1.01, 1.28, 'N', 15712);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (743, 1.18, 1.47, 'E', 32499);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (176, 1.17, 1.45, 'E', 7505);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (308, 1.04, 1.03, 'S', 1848);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (684, 1.16, 1.08, 'SW',12853);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (634, 1.02, 1.0, 'W',  13905);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (438, 1.37, 1.35, 'E', 23257);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (540, 1.37, 1.45, 'E', 6126);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (449, 0.82, 0.86, 'W', 27768);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (828, 1.13, 1.28, 'E', 15372);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (689, 1.44, 1.46, 'SW',25897);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (188, 0.81, 0.84, 'E', 22532);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (519, 1.05, 1.11, 'SE',32118);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (698, 1.39, 1.11, 'E', 6020);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (799, 1.25, 0.93, 'N', 26006);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (494, 1.26, 1.08, 'SW',3803);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (518, 1.0, 1.18, 'W',59966);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (488, 1.03, 0.97, 'E', 27267);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (187, 1.32, 1.37, 'W', 19356);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (376, 1.08, 1.31, 'SW',12854);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (111, 1.43, 1.45, 'SW',19117);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (631, 0.94, 1.1, 'E',  9927);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (606, 0.84, 0.99, 'W', 13101);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (266, 1.5, 1.21, 'E', 5425);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (170, 1.49, 0.9, 'W',  1340);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (744, 1.21, 1.48, 'SE',7021);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (499, 1.12, 0.91, 'E', 18471);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (503, 1.33, 1.46, 'NW',30351);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (651, 1.26, 1.01, 'E', 21523);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (185, 1.16, 1.17, 'NE',22700);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (571, 1.43, 0.83, 'E', 19765);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (319, 1.0, 1.14, 'E', 16833);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (458, 1.48, 1.14, 'W', 9792);
insert into Finestra (IdFinestra, Larghezza,Altezza , PuntoCardinale, IDVano) values (587, 1.01, 1.45, 'E', 24567);


-- PUNTO DI ACCESSO


INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('759', 'Interno', 'Porta', '1.17', '2.46');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('924', 'Interno', 'Porta', '1.74', '3.20');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('1226', 'Interno', 'Porta', '2.12', '2.90');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('1342', 'Interno', 'Porta', '1.58', '2.14');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('1864', 'Interno', 'Porta', '2.94', '2.63');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('2018', 'Interno', 'Porta', '1.50', '3.35');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('2188', 'Interno', 'Porta', '2.53', '2.37');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('2425', 'Interno', 'Porta', '1.60', '3.61');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3011', 'Interno', 'Porta', '1.79', '2.19');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3097', 'Interno', 'Porta', '1.64', '3.37');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3170', 'Interno', 'Porta', '1.81', '2.17');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3200', 'Interno', 'Porta', '1.66', '3.40');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3212', 'Interno', 'Porta', '2.22', '2.24');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3349', 'Interno', 'Porta', '1.26', '3.34');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3693', 'Interno', 'Porta', '1.23', '2.97');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3747', 'Interno', 'Porta', '1.12', '2.37');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3831', 'Interno', 'Porta', '1.98', '2.64');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('4605', 'Interno', 'Porta', '1.25', '2.51');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('4712', 'Interno', 'Porta', '2.11', '2.75');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('4751', 'Interno', 'Porta', '1.71', '2.71');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5069', 'Interno', 'Porta', '1.40', '2.97');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5080', 'Interno', 'Porta', '2.33', '3.63');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5173', 'Interno', 'Porta', '1.58', '3.82');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5203', 'Interno', 'Porta', '1.96', '3.71');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5293', 'Interno', 'Porta', '2.17', '2.72');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5325', 'Interno', 'Porta', '2.72', '3.42');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5357', 'Interno', 'Porta', '2.66', '3.09');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5364', 'Interno', 'Porta', '2.84', '4.00');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5462', 'Interno', 'Porta', '1.70', '2.24');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5600', 'Interno', 'Porta', '2.08', '2.04');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('6058', 'Interno', 'Porta', '2.84', '3.59');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('6476', 'Interno', 'Porta', '2.43', '3.30');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('6724', 'Interno', 'Porta', '1.02', '2.10');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('6817', 'Interno', 'Porta', '2.39', '2.90');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('6893', 'Interno', 'Porta', '1.22', '2.99');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('7027', 'Interno', 'Porta', '2.19', '3.74');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('7348', 'Interno', 'Porta', '1.61', '2.66');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('7402', 'Interno', 'Porta', '1.19', '2.53');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('7497', 'Interno', 'Porta', '2.87', '2.87');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('8470', 'Interno', 'Porta', '1.27', '2.26');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('8517', 'Interno', 'Porta', '1.93', '3.57');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('9131', 'Interno', 'Porta', '1.84', '2.71');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('9144', 'Interno', 'Porta', '1.39', '2.47');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('9151', 'Interno', 'Porta', '1.78', '2.41');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('9667', 'Interno', 'Porta', '2.79', '3.14');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('9892', 'Interno', 'Porta', '1.78', '3.95');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('9939', 'Interno', 'Porta', '1.08', '2.43');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('522', 'Esterno', 'Portafinestra', '1.83', '3.90');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('556', 'Esterno', 'Portafinestra', '1.29', '3.19');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('978', 'Esterno', 'Portafinestra', '2.99', '3.40');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('980', 'Esterno', 'Portafinestra', '2.97', '3.31');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('1052', 'Esterno', 'Portafinestra', '2.07', '2.77');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('1369', 'Esterno', 'Portafinestra', '1.44', '3.43');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('1398', 'Esterno', 'Portafinestra', '2.39', '2.16');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('1610', 'Esterno', 'Portafinestra', '1.54', '3.80');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('1686', 'Esterno', 'Portafinestra', '1.90', '3.54');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('1728', 'Esterno', 'Portafinestra', '1.23', '2.16');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('2148', 'Esterno', 'Portafinestra', '2.57', '2.61');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('2242', 'Esterno', 'Portafinestra', '2.91', '2.24');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('2279', 'Esterno', 'Portafinestra', '2.42', '3.80');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('2280', 'Esterno', 'Portafinestra', '2.90', '2.16');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('2412', 'Esterno', 'Portafinestra', '1.35', '2.34');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('2482', 'Esterno', 'Portafinestra', '2.14', '2.25');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('2486', 'Esterno', 'Portafinestra', '2.64', '2.77');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3003', 'Esterno', 'Portafinestra', '1.36', '2.02');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('3671', 'Esterno', 'Portafinestra', '2.01', '2.88');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('4682', 'Esterno', 'Portafinestra', '1.53', '3.86');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('4964', 'Esterno', 'Portafinestra', '1.48', '3.45');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5019', 'Esterno', 'Portafinestra', '1.84', '3.20');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5144', 'Esterno', 'Portafinestra', '1.90', '3.46');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5186', 'Esterno', 'Portafinestra', '2.02', '4.00');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5192', 'Esterno', 'Portafinestra', '1.45', '3.15');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5573', 'Esterno', 'Portafinestra', '1.81', '2.73');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5651', 'Esterno', 'Portafinestra', '1.40', '2.63');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5758', 'Esterno', 'Portafinestra', '2.02', '3.67');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('5885', 'Esterno', 'Portafinestra', '1.44', '2.70');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('6220', 'Esterno', 'Portafinestra', '1.14', '2.97');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('6478', 'Esterno', 'Portafinestra', '2.32', '2.73');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('6786', 'Esterno', 'Portafinestra', '1.85', '2.19');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('6902', 'Esterno', 'Portafinestra', '2.40', '2.89');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('7151', 'Esterno', 'Portafinestra', '2.00', '2.72');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('7181', 'Esterno', 'Portafinestra', '2.29', '2.18');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('7263', 'Esterno', 'Portafinestra', '2.27', '2.01');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('7452', 'Esterno', 'Portafinestra', '1.33', '3.18');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('7545', 'Esterno', 'Portafinestra', '1.81', '3.56');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('8278', 'Esterno', 'Portafinestra', '2.36', '3.83');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('8410', 'Esterno', 'Portafinestra', '2.26', '3.25');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('8686', 'Esterno', 'Portafinestra', '2.43', '3.94');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('8885', 'Esterno', 'Portafinestra', '2.28', '3.06');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('8908', 'Esterno', 'Portafinestra', '2.52', '2.26');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('8988', 'Esterno', 'Portafinestra', '2.45', '3.88');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('9534', 'Esterno', 'Portafinestra', '2.51', '3.86');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('9552', 'Esterno', 'Portafinestra', '1.26', '3.57');
INSERT INTO puntodiaccesso (idAccesso, Collegamento, Tipologia, Larghezza, Altezza) VALUES ('9783', 'Esterno', 'Portafinestra', '2.51', '3.70');

-- CALAMITA'

insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2020-05-24 16:15:01', 'Terremoto', 7, 38.115688, 13.361267, 1);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2020-05-31 05:57:07', 'Incendio', 3, 38.112747, 13.345706, 1);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2012-01-30 05:25:59', 'Frana', 5, 38.120108, 13.356156, 1);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2017-05-25 17:37:50', 'Uragano', 1, 38.105724, 13.373408, 1);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2002-11-04 20:03:45', 'Alluvione', 2, 38.113490, 13.328991, 1);

insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2007-06-13 02:14:39', 'Incendio', 8, 34.01948, 34.01948 -6.84333, 2);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2018-04-07 13:35:22', 'Frana', 1, 34.01125, -6.84127, 2);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2010-03-29 17:19:49', 'Terremoto', 7, 34.01831,  -6.82130, 2);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2013-10-04 13:51:49', 'Incendio', 6, 33.99887, -6.82516, 2);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2004-03-23 02:52:03', 'Frana', 2, 34.01996, -6.81304, 2);

insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2006-03-11 10:20:16', 'Alluvione', 4, 55.81059,  37.28196, 3);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2022-03-30 09:03:19', 'Frana', 2, 55.96474 , 37.92494, 3);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2002-11-06 11:32:44', 'Alluvione', 1, 55.60306,37.73259, 3);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2002-10-10 06:45:51', 'Frana', 6, 55.76422, 38.16124, 3);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2012-04-19 13:02:29', 'Uragano', 7, 55.68220, 37.55672, 3);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2020-10-10 06:45:51', 'Terremoto', 6, 55.76422, 38.16124, 3);

insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2010-12-05 22:25:23', 'Incendio', 5, 43.85198,18.38669, 4);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2008-09-20 20:01:08', 'Alluvione', 6, 43.85297,  18.37532, 4);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2005-04-03 03:39:48', 'Terremoto', 4, 43.85533, 18.40468, 4);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2004-11-02 18:33:21', 'Alluvione', 7, 43.84455, 18.39232, 4);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2020-09-24 17:32:22', 'Uragano', 3, 43.84963, 18.36179, 4);

insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2019-11-16 17:19:21', 'Frana', 2, -34.58911, -58.44177, 5);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2022-01-24 16:49:33', 'Incendio', 9, -34.67562, -34.67562, 5);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2021-02-15 09:09:07', 'Frana', 2, -34.59816, -58.38476, 5);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2013-04-29 04:25:55', 'Alluvione', 6, -34.60721 , -58.61007, 5);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2018-07-30 01:18:23', 'Uragano', 5, -34.75866, -58.53451, 5);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2018-04-30 01:18:23', 'Terremoto', 5, -34.75866, -58.53451, 5);

insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2000-09-02 15:50:01', 'Alluvione', 7, 43.63283, -79.42293, 6);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2005-01-28 09:15:21', 'Frana', 4, 43.64302, -79.34427, 6);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2015-01-28 08:44:23', 'Uragano', 2, 43.66664 ,-79.29791, 6);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2018-01-21 07:49:35', 'Terremoto', 6, 43.70366 ,-79.39030, 6);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2016-02-08 07:08:01', 'Incendio', 8, 43.65247, -79.49849, 6);



insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2023-03-15 16:15:01', 'Terremoto', 7, 38.115688, 13.361267, 1);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2023-03-01 17:19:49', 'Terremoto', 7, 34.01831,  -6.82130, 2);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2023-02-27 10:20:16', 'Terremoto', 4, 55.81059,  37.28196, 3);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2023-03-02 03:39:48', 'Terremoto', 4, 43.85533, 18.40468, 4);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2023-03-12 04:25:55', 'Terremoto', 6, -34.60721 , -58.61007, 5);
insert into Calamità (Timestamp, Tipo, Livello, Latitudine, Longitudine, Idarea) values ('2023-03-03 07:49:35', 'Terremoto', 6, 43.70366 ,-79.39030, 6);

-- REGISTRO RISCHIO

insert into RegistroRischio (DataInizio, DataFine, Valore, idArea) values ('2017-05-26', '2020-05-24', 2, 1);
insert into RegistroRischio (DataInizio, DataFine, Valore, idArea) values ('2020-05-25', NULL, 5, 1);
insert into RegistroRischio (DataInizio, DataFine, Valore, idArea) values ('2010-03-30', NULL, 6, 2);
insert into RegistroRischio (DataInizio, DataFine, Valore, idArea) values ('2006-03-12', '2012-04-19', 2, 3);
insert into RegistroRischio (DataInizio, DataFine, Valore, idArea) values ('2012-04-20', NULL, 4, 3);
insert into RegistroRischio (DataInizio, DataFine, Valore, idArea) values ('2010-12-06', '2020-09-24', 6, 4);
insert into RegistroRischio (DataInizio, DataFine, Valore, idArea) values ('2020-09-25',NULL, 7, 4);
insert into RegistroRischio (DataInizio, DataFine, Valore, idArea) values ('2022-01-24', NULL, 3, 5);
insert into RegistroRischio (DataInizio, DataFine, Valore, idArea) values ('2016-02-09', '2018-01-20', 4, 6);
insert into RegistroRischio (DataInizio, DataFine, Valore, idArea) values ('2018-01-21', NULL, 7, 6);

-- PROGETTO

insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (5542, 'Costruzione Edificio', '2004-09-28', '2004-11-09', '2005-05-26', '2008-09-13');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (1932, 'Ampliamento', '2012-05-07', '2016-07-03', '2016-12-10', '2018-04-10');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (123, 'Costruzione Edificio', '2018-09-05', '2019-03-06', '2020-10-13', '2022-06-23');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (7806, 'Ristrutturazione', '2022-09-08', '2022-10-07', '2022-11-30', '2022-12-31');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (1753, 'Costruzione Edificio', '2006-10-15', '2007-01-10', '2007-08-26', '2008-04-18');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (3636, 'Ampliamento', '2013-03-21', '2013-03-28', '2013-05-18', '2013-09-11');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (844, 'Costruzione Edificio', '2017-08-26', '2017-12-03', '2018-09-21', '2020-03-31');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (2574, 'Messa in sicurezza', '2021-12-24', '2022-01-26', '2022-02-09', '2022-04-02');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (3656, 'Costruzione Edificio', '2000-08-31', '2000-12-16', '2001-12-05', '2004-03-15');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (3679, 'Ristrutturazione', '2007-12-06', '2008-02-09', '2008-11-14', '2009-02-02');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (3593, 'Costruzione Edificio', '2015-05-02', '2015-07-01', '2015-09-26', '2017-02-26');
insert into Progetto (IDProgetto, TipoLavoro, DataPresentazione, DataApprovazione, DataInizio, StimaDataFine) values (593, 'Messa in sicurezza', '2019-05-14', '2019-06-18', '2019-09-06', '2019-11-15');

-- STADIO
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (164, '2005-05-26', '2005-12-20', '2005-12-20', '114660', '0', '5542');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (264, '2005-12-21', '2006-12-09', '2006-12-11', '177630', '0', '5542');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (364, '2006-12-10', '2008-09-13', '2008-09-01', '475024', '0', '5542');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (128, '2016-12-10', '2017-05-03', '2017-05-03', '22140', '0', '1932');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (228, '2017-05-04', '2017-10-18', '2017-10-18', '20500', '0', '1932');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (328, '2017-10-19', '2018-04-10', '2018-04-10', '25691', '0', '1932');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (179, '2020-10-13', '2021-03-26', '2021-03-26', '40570', '0', '123');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (279, '2021-03-27', '2021-08-21', '2021-08-21', '48200', '0', '123');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (379, '2021-08-22', '2022-01-11', '2022-01-11', '52300', '0', '123');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (479, '2022-01-12', '2022-06-23', '2022-06-23', '26900', '0', '123');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (186, '2022-11-30', '2022-12-05', '2022-12-05', '1340', '0', '7806');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (286, '2022-12-06', '2022-12-20', '2022-12-20', '1500', '0', '7806');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (386, '2022-12-21', '2022-12-31', NULL, '980', NULL, '7806');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (112, '2007-08-26', '2007-10-28', '2007-10-28', '45600', '0', '1753');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (212, '2007-10-29', '2007-12-20', '2007-12-27', '32000', '0', '1753');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (312, '2007-12-28', '2008-02-17', '2008-02-25', '26200', '0', '1753');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (412, '2008-02-26', '2008-04-18', '2008-04-22', '18500', '0', '1753');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (144, '2013-05-18', '2013-06-20', '2013-06-20', '1600', '0', '3636');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (244, '2013-06-21', '2013-07-27', '2013-07-27', '1550', '0', '3636');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (344, '2013-07-28', '2013-09-11', '2013-09-11', '2462', '0', '3636');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (104, '2018-09-21', '2018-12-30', '2018-12-30', '15300', '0', '844');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (204, '2018-12-31', '2019-04-29', '2019-04-29', '22400', '0', '844');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (304, '2019-04-30', '2019-10-22', '2019-10-25', '47450', '0', '844');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (404, '2019-10-26', '2020-03-31', '2020-03-31', '40700', '0', '844');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (118, '2022-02-09', '2022-02-27', '2022-02-27', '766', '0', '2574');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (218, '2022-02-28', '2022-03-18', '2022-03-18', '1430', '0', '2574');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (318, '2022-03-19', '2022-04-02', NULL, '3800', NULL, '2574');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (120, '2001-12-05', '2002-08-13', '2002-09-15', '48140', '0', '3656');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (220, '2002-09-16', '2003-06-06', '2003-07-06', '29459', '0', '3656');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (320, '2003-07-07', '2004-03-15', '2004-03-15', '25700', '0', '3656');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (136, '2008-11-14', '2008-12-15', '2008-12-15', '2150', '0', '3679');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (236, '2008-12-16', '2009-01-19', '2009-01-19', '1740', '0', '3679');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (336, '2009-01-20', '2009-02-02', '2009-02-02', '890', '0', '3679');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (154, '2015-09-26', '2016-03-20', '2016-03-20', '27670', '0', '3593');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (254, '2016-03-21', '2016-10-19', '2016-10-19', '42140',  '0',  '3593');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (354, '2016-10-20', '2017-02-26', '2017-02-26', '15300', '0', '3593');

insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (199, '2019-09-06', '2019-09-30', '2019-09-30', '1560', '0', '593');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (299, '2019-10-01', '2019-10-18', '2019-10-18', '3767', '0', '593');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (399, '2019-10-19', '2019-10-29', '2019-10-29', '2758', '0', '593');
insert into Stadio (IDStadio, DataInizio, DataFineStimata, DataFineEffettiva, CostoStimato, CostoEffettivo, IDProgetto) values (499, '2019-10-30', '2019-11-15', '2019-11-15', '5870', '0', '593');

-- RESPONSABILE

insert into Responsabile (CodFiscale, Nome, Cognome) values ('SCHMTT89E23B157P', 'Mattia', 'Schelotto');
insert into Responsabile (CodFiscale, Nome, Cognome) values ('NDRMRC86H10G842B', 'Marco', 'Andreolli');
insert into Responsabile (CodFiscale, Nome, Cognome) values ('LNGSML92A12L565W', 'Samuele', 'Longo');
insert into Responsabile (CodFiscale, Nome, Cognome) values ('CMPGUO80H27Z600W', 'Ugo', 'Campagnaro');
insert into Responsabile (CodFiscale, Nome, Cognome) values ('CSTLCU75L19E094O', 'Luca', 'Castellazzi');

-- CAPOCANTIERE

insert into CapoCantiere (CodFiscale, Nome, Cognome, OperaiMassimi) values ('RMNFNC86R16Z600B', 'Franco', 'Armani', 7);
insert into CapoCantiere (CodFiscale, Nome, Cognome, OperaiMassimi) values ('DNADNL74L10D037C', 'Daniele', 'Adani', 8);
insert into CapoCantiere (CodFiscale, Nome, Cognome, OperaiMassimi) values ('SCPNTN82L12A662K', 'Antonio', 'Sciapò', 6);
insert into CapoCantiere (CodFiscale, Nome, Cognome, OperaiMassimi) values ('RLNCST85M31H570P', 'Cristiano', 'Rolando', 5);
insert into CapoCantiere (CodFiscale, Nome, Cognome, OperaiMassimi) values ('PSNCRL90C16F335C', 'Carlo', 'Pinsoglio', 4);

-- LAVORO

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1164, 'Carotaggi e analisi', '28000', '2005-05-26', '2005-07-01', 164, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2164, 'Preparazione del terreno', '36060', '2005-07-02', '2005-08-27', 164, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3164, 'Rimozione del terreno', '50600', '2005-08-28', '2005-12-20', 164, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, NULL);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1264, 'Preparazione materiale', '20000', '2005-12-21', '2006-01-12', 264, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2264, 'Prime fondamenta', '80000', '2005-01-13', '2006-06-15', 264, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3264, 'Seconde fondamenta', '100000', '2006-06-16', '2006-12-11', 264, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, NULL);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1364, 'Costruzione pavimentazione', '166000', '2006-12-10', '2007-06-25', 364, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2364, 'Costruzione muri ', '180100', '2007-06-26', '2008-05-18', 364, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3364, 'Rafforzamento muratura', '124000', '2008-05-19', '2008-09-01', 364, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, NULL);




insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1128, 'Costruzione pavimentazione', '10000', '2016-12-10', '2017-02-15', 128, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, 19177);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2128, 'Costruzione muri', '9200', '2017-02-16', '2017-04-12', 128, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, 21719);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3128, 'Installazione rivestimento pavimentazione', '2940', '2017-04-13', '2017-05-03', 128, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, 2586);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1228, 'Imbiancatura', '8500', '2017-05-04', '2017-06-10', 228, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, 30890);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2228, 'Installazione rivestimento mura', '3000', '2017-06-11', '2017-08-25', 228, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, 7505);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3228, 'Installazione infissi', '9000', '2017-08-26', '2017-10-18', 228, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, 15712);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1328, 'Installazione completa sensori', '18601', '2017-10-19', '2017-12-12', 328, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, 1848);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2328, 'Test completo sensori', '3200', '2017-12-13', '2017-12-22', 328, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, 13905);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3328, 'Imbiancatura', '3890', '2017-12-23', '2018-04-10', 328, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 1, 27768);




















insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1179, 'Carotaggi e analisi',  '5070', '2020-10-13', '2020-11-26', 179, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2179, 'Preparazione del terreno', '17500', '2020-11-27', '2021-01-25', 179, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3179, 'Rimozione del terreno', '18000', '2021-01-26', '2021-03-26', 179, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);
                                                                                                                                                                     
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1279, 'Preparazione materiale', '3200', '2021-03-27', '2021-04-17', 279, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2279, 'Prime fondamenta', '25000', '2021-04-18', '2021-06-28', 279, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3279, 'Seconde fondamenta', '20000', '2021-06-29', '2021-08-21', 279, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);
                                                                                                                                                                     
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1379, 'Costruzione pavimentaznne', '18000', '2021-08-22', '2021-10-27', 379, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2379, 'Costruzione muri ', '28000', '2021-10-28', '2021-12-28', 379, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3379, 'Rafforzamento muratura', '6300', '2021-12-29', '2022-01-11', 379, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1479, 'Preparazione sensori', '5900', '2022-01-12', '2022-02-05', 479, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2479, 'Test sensori', '8000', '2022-02-06', '2022-03-01', 479, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3479, 'Installazione completa sensori', '13000', '2022-03-02', '2022-06-23', 479, 'SCHMTT89E23B157P', 'RMNFNC86R16Z600B', 2,NULL);





insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1186, 'Imbiancatura', '340', '2022-11-30', '2022-12-01', 186, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 2, 15372);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2186, 'Rafforzamento muratura', '600', '2022-12-02', '2022-12-03', 186, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 2, 22532);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3186, 'Sostituzione infissi', '400', '2022-12-04', '2022-12-05', 186, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 2, 25897);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1286, 'Installazione sensori posizione', '800', '2022-12-06', '2022-12-12', 286, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 2, 3803);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2286, 'Imbiancatura', '350', '2022-12-13', '2022-12-16', 286, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 2, 6020);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3286, 'Sostituzione rivestimento mura', '350', '2022-12-17', '2022-12-20', 286, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 2, 26006);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1386, 'Sostituzione sensori temperatura', '700', '2022-12-21', '2022-12-23', 386, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 2, 32118);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2386, 'Rafforzamento muratura', '250', '2022-12-27', '2022-12-29', 386, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 2, 25897);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3386, 'Rivestimento mura', NULL, '2022-12-30', NULL, 386, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 2, 15372 );











insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1112, 'Carotaggi e analisi', '5600', '2007-08-26', '2007-09-10', 112, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2112, 'Preparazione del terreno', '15000', '2007-09-11', '2007-09-25', 112, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3112, 'Rimozione del terreno', '25000', '2007-09-26', '2007-10-28', 112,'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1212, 'Preparazione materiale', '2600', '2007-10-29', '2007-11-03', 212, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2212, 'Prime fondamenta', '20400', '2007-11-04', '2007-11-26', 212, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3212, 'Seconde fondamenta',  '12000', '2007-11-28', '2007-12-27', 212, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1312, 'Costruzione pavimentazione', '12000', '2007-12-28', '2008-01-18', 312, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2312, 'Costruzione muri ',  '15000', '2008-01-19', '2008-02-15', 312, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3312, 'Rafforzamento muratura', '3000', '2008-02-16', '2008-02-25', 312, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1412, 'Preparazione sensori', '2000', '2008-02-26', '2008-03-10', 412,'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2412, 'Test sensori ','6000', '2008-03-11', '2008-03-18', 412,'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3412, 'Installazione completa sensori', '12000', '2008-03-19', '2008-04-22', 412, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3,NULL);





insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1144, 'Costruzione pavimentazione', '500', '2013-05-18', '2013-05-28', 144, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3, 12854);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2144, 'Costruzione muri','800', '2013-05-29', '2013-06-15', 144, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3, 13550);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3144, 'Installazione rivestimento pavimentazione' , '300', '2013-06-16', '2013-06-20', 144, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3, 19356);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1244, 'Imbiancatura', '350', '2013-06-21', '2013-06-28', 244, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3, 22738);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2244, 'Rivestimento mura' , '400', '2013-06-29', '2013-07-10', 244, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3, 9927);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3244, 'Installazione infissi', '800', '2013-07-11', '2013-07-27', 244, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3, 13101);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1344, 'Installazione completa sensori', '1400', '2013-07-28', '2013-08-20', 344, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3, 1340);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2344, 'Test completo sensori', '262', '2013-08-21', '2013-08-29', 344, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3, 5425);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3344, 'Imbiancatura', '800', '2013-08-30', '2013-09-11', 344, 'NDRMRC86H10G842B', 'DNADNL74L10D037C', 3, 7021);





insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1104, 'Carotaggi e analisi', '1300', '2018-09-21', '2018-10-01', 104, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2104, 'Preparazione del terreno', '6000', '2018-10-02', '2018-11-10', 104, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3104, 'Rimozione del terreno', '8000', '2018-11-11', '2018-12-30', 104, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1204, 'Preparazione materiale', '2400', '2018-12-31', '2019-01-10', 204, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2204, 'Prime fondamenta', '12000', '2019-01-11', '2019-03-07', 204, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3204, 'Seconde fondamenta', '8000', '2019-03-08', '2019-04-29', 204, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1304, 'Costruzione pavimentazione', '15000', '2019-04-30', '2019-06-28', 304, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2304, 'Costruzione muri ', '25000', '2019-06-29', '2019-09-12', 304, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3304, 'Rafforzamento muratura', '9000', '2019-09-13', '2019-10-25', 304, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1404, 'Preparazione sensori', '5500', '2019-10-26', '2019-11-25', 404, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2404, 'Test sensori', '4200', '2019-11-26', '2020-01-10', 404, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3404, 'Installazione completa sensori', '31000', '2020-01-11', '2020-03-31', 404, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4,NULL);





insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1118, 'Valutazione condizione mura', '200', '2022-02-09', '2022-02-12', 118, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4, 18471);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2118, 'Rimozione sensori posizione', '300', '2022-02-13', '2022-02-20', 118, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4, 18471);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3118, 'Rimozione giroscopi', '300', '2022-02-21', '2022-02-27', 118,'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4, 18471);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1218, 'Installazione sensori posizione', '600', '2022-02-28', '2022-03-05', 218, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4, 18471);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2218, 'Installazione giroscopi', '500', '2022-03-06', '2022-03-15', 218, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4, 30351);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3218, 'Primo test sensori', '330', '2022-03-16', '2022-03-18', 218, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4, 30351);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1318, 'Imbiancatura', '2500', '2022-03-19', '2022-04-02', 318, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4, 30351);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2318, 'Secondo test sensori', '450', '2022-04-02', '2022-04-20', 318, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4, 30351);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3318, 'Rafforzamento muratura', NULL, '2022-04-21', NULL, 318, 'LNGSML92A12L565W', 'SCPNTN82L12A662K', 4, 30351);





insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1120, 'Carotaggi e analisi', '5000', '2001-12-05', '2001-12-22', 120, 'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2120, 'Preparazione del terreno', '20000', '2001-12-23', '2002-03-12', 120,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3120, 'Rimozione del terreno', '30000', '2002-03-13', '2002-09-15', 120,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, NULL);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1220, 'Preparazione materiale', '2500', '2002-09-16', '2002-10-18', 220,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2220, 'Prime fondamenta', '20000', '2002-10-19', '2003-04-22', 220, 'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3220, 'Seconde fondamenta', '12500', '2003-04-23', '2003-07-06', 220,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, NULL);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1320, 'Costruzione pavimentazione', '8000', '2003-07-07', '2003-10-25', 320,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2320, 'Costruzione muri ', '12000', '2003-10-26', '2004-02-28', 320,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3320, 'Rafforzamento muratura', '5700', '2004-02-29', '2004-03-15', 320,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, NULL);





insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1136, 'Rimozione rivestimento muri', '250', '2008-11-14', '2008-11-25', 136,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, 21523);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2136, 'Imbiancatura', '600', '2008-11-26', '2008-12-03', 136,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, 21523);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3136, 'Rimozione completa sensori ', '1300', '2008-12-04', '2008-12-15', 136,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, 21523);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1236, 'Rafforzamento muratura', '540', '2008-12-16', '2009-01-03', 236,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, 21523);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2236, 'Installazione completa sensori', '800', '2009-01-04', '2009-01-12', 236,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, 21523);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3236, 'Rimozione infissi', '400', '2009-01-13', '2009-01-19', 236,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, 22700);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1336, 'Installazione infissi', '490', '2009-01-20', '2009-01-25', 336,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, 22700);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2336, 'Rimozione sensori temperatura', '200', '2009-01-26', '2009-01-28', 336,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, 22700);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3336, 'Installazione sensori temperatura', '200', '2009-01-29', '2009-02-02', 336,  'CMPGUO80H27Z600W', 'RLNCST85M31H570P', 5, 22700);





insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1154, 'Carotaggi e analisi', '5670', '2015-09-26', '2015-10-01', 154, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2154, 'Preparazione del terreno', '10000', '2015-10-02', '2015-12-28', 154, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3154, 'Rimozione del terreno', '12000', '2015-12-29', '2016-03-20', 154, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6,NULL);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1254, 'Preparazione materiale', '3140', '2016-03-21', '2016-04-01', 254, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2254, 'Prime fondamenta', '24000', '2016-04-02', '2016-08-12', 254, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3254, 'Seconde fondamenta', '15000', '2016-08-13', '2016-10-19', 254, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6,NULL);
                                                                                                                                                                    
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1354, 'Costruzione pavimentazione', '5000', '2016-10-20', '2016-12-22', 354, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2354, 'Costruzione muri ', '8000', '2016-12-23', '2017-02-15', 354, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6,NULL);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3354, 'Rafforzamento muratura', '2300', '2017-02-16', '2017-02-26', 354, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6,NULL);






insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1199, 'Valutazione stato muri', '160', '2019-09-06', '2019-09-10', 199,'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6, 9792);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2199, 'Installazione accelerometri ', '1000', '2019-09-11', '2019-09-25', 199, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6, 9792);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3199, 'Test sensori', '400', '2019-09-26', '2019-09-30', 199,'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6, 9792);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1299, 'Installazione sensori umidità', '1255', '2019-10-01', '2019-10-05', 299, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6, 16833);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2299, 'Installazione sensori temperatura', '1255', '2019-10-06', '2019-10-10', 299, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6, 16833);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3299, 'Installazione accellerometri', '1257', '2019-10-11', '2019-10-18', 299, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6,16833);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1399, 'Installazione giroscopi', '1255', '2019-10-19', '2019-10-22', 399,'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6, 19765);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2399, 'Valutazione stato muri', '248', '2019-10-23', '2019-10-25', 399, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6, 19765);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3399, 'Installazione sensori di posizione', '1255', '2019-10-26', '2019-10-29', 399, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6, 19765);

insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (1499, 'Rafforzamento muratura', '3800', '2019-10-30', '2019-11-07', 499, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6, 16833);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (2499, 'Rafforzamento muratura', '1570', '2019-11-08', '2019-11-12', 499, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C', 6, 19765);
insert into Lavoro (IDLavoro, Descrizione, Costo, DataInizio, DataFine, IDStadio, CodFiscaleResponsabile, CodFiscaleCapoCantiere, IDEdificio, IDVano) values (3499, 'Sostituzione infissi', '500', '2019-11-13', '2019-11-15', 499, 'CSTLCU75L19E094O', 'PSNCRL90C16F335C',6, 9792);

-- MATERIALE

insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8631, 'S.I.U.M Edilizia', '2005-04-11', 38, 697);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2380, 'Adam Motorola S.R.L', '2020-04-19', 47, 1305);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4546, 'Ankara S.R.L', '2006-06-29', 97, 470);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (507, 'Ankara S.R.L', '2020-08-09', 72, 346);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5953, 'Salini Impregilo', '2002-12-14', 41, 320);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7509, 'Futbol Costruzioni', '2013-10-26', 98, 731);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (44, 'Adam Motorola S.R.L', '2008-03-30', 38, 682);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (999, 'Salini Impregilo', '2009-11-29', 89, 956);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5234, 'S.I.U.M Edilizia', '2020-07-18', 32, 738);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6345, 'Salini Impregilo', '2019-03-21', 28, 689);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5750, 'Adam Motorola S.R.L', '2011-07-25', 21, 508);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1782, 'Salini Impregilo', '2012-02-16', 21, 1017);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5902, 'Ankara S.R.L', '2011-07-31', 14, 395);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5260, 'Ankara S.R.L', '2010-05-19', 64, 1157);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9025, 'Futbol Costruzioni', '2012-11-11', 39, 967);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6317, 'Ankara S.R.L', '2007-02-07', 88, 652);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4494, 'Adam Motorola S.R.L', '2009-06-01', 77, 1205);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1942, 'S.I.U.M Edilizia', '2010-05-14', 52, 1453);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5407, 'Adam Motorola S.R.L', '2009-08-07', 61, 884);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6805, 'S.I.U.M Edilizia', '2016-01-05', 61, 1040);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8010, 'Futbol Costruzioni', '2011-02-25', 99, 1072);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (768, 'Futbol Costruzioni', '2006-10-15', 37, 980);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8651, 'Ankara S.R.L', '2007-03-09', 74, 435);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (776, 'S.I.U.M Edilizia', '2007-07-14', 87, 476);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5421, 'Adam Motorola S.R.L', '2004-06-05', 59, 1307);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8505, 'S.I.U.M Edilizia', '2005-04-04', 58, 500);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6010, 'Ankara S.R.L', '2005-05-17', 16, 959);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8621, 'Salini Impregilo', '2002-11-04', 44, 1310);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9301, 'Ankara S.R.L', '2002-07-19', 19, 1223);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1677, 'Futbol Costruzioni', '2021-11-08', 97, 448);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4099, 'Adam Motorola S.R.L', '2009-01-28', 49, 1362);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9954, 'Salini Impregilo', '2011-02-26', 12, 379);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9461, 'Salini Impregilo', '2008-04-11', 100, 398);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4464, 'S.I.U.M Edilizia', '2002-01-03', 52, 627);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3978, 'Futbol Costruzioni', '2017-06-12', 26, 1253);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6336, 'S.I.U.M Edilizia', '2017-12-30', 52, 570);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3118, 'Adam Motorola S.R.L', '2002-03-07', 44, 331);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4726, 'Salini Impregilo', '2007-01-07', 82, 662);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (773, 'S.I.U.M Edilizia', '2003-03-25', 56, 798);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5870, 'Futbol Costruzioni', '2007-08-29', 95, 1455);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5037, 'Adam Motorola S.R.L', '2011-07-15', 65, 481);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (892, 'S.I.U.M Edilizia', '2010-07-02', 52, 809);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3774, 'Ankara S.R.L', '2022-07-04', 89, 981);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3236, 'S.I.U.M Edilizia', '2008-05-12', 48, 815);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3333, 'Salini Impregilo', '2010-04-16', 83, 855);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4052, 'S.I.U.M Edilizia', '2017-07-21', 42, 350);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (270, 'Salini Impregilo', '2011-08-25', 68, 727);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9171, 'Salini Impregilo', '2011-12-17', 38, 782);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3794, 'Futbol Costruzioni', '2014-03-18', 11, 1051);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8945, 'Adam Motorola S.R.L', '2017-09-29', 91, 327);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1407, 'Ankara S.R.L', '2013-10-10', 78, 960);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4951, 'Futbol Costruzioni', '2017-12-29', 65, 1203);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7340, 'Futbol Costruzioni', '2003-06-02', 82, 492);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4507, 'Salini Impregilo', '2012-09-09', 91, 1053);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7714, 'Ankara S.R.L', '2018-09-27', 67, 1341);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3725, 'S.I.U.M Edilizia', '2013-12-06', 55, 1186);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8151, 'Adam Motorola S.R.L', '2011-09-24', 50, 1323);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8192, 'Ankara S.R.L', '2009-10-29', 28, 1133);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5899, 'Salini Impregilo', '2003-11-03', 51, 1180);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4310, 'Ankara S.R.L', '2011-08-20', 100, 1065);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (766, 'S.I.U.M Edilizia', '2006-01-05', 20, 1173);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3459, 'Futbol Costruzioni', '2006-07-23', 85, 1257);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8483, 'S.I.U.M Edilizia', '2013-09-30', 24, 1187);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6107, 'Ankara S.R.L', '2011-06-08', 82, 695);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3142, 'Adam Motorola S.R.L', '2017-10-24', 82, 855);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (423, 'Futbol Costruzioni', '2007-11-25', 91, 560);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9739, 'S.I.U.M Edilizia', '2014-03-08', 58, 775);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9794, 'S.I.U.M Edilizia', '2021-01-14', 66, 526);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9572, 'Adam Motorola S.R.L', '2016-01-23', 58, 906);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9830, 'S.I.U.M Edilizia', '2007-05-20', 96, 1252);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8460, 'Ankara S.R.L', '2004-02-24', 62, 897);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8648, 'Salini Impregilo', '2002-01-12', 76, 1346);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3160, 'S.I.U.M Edilizia', '2020-09-18', 88, 1028);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3777, 'Adam Motorola S.R.L', '2009-07-30', 52, 523);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8647, 'Adam Motorola S.R.L', '2017-06-12', 63, 746);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (952, 'Futbol Costruzioni', '2022-09-20', 98, 1462);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2429, 'Ankara S.R.L', '2003-07-20', 40, 1407);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7650, 'S.I.U.M Edilizia', '2010-03-14', 100, 782);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7121, 'Salini Impregilo', '2011-09-20', 44, 564);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3290, 'Adam Motorola S.R.L', '2020-03-09', 76, 466);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7507, 'Ankara S.R.L', '2014-07-26', 72, 1026);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6000, 'Ankara S.R.L', '2013-07-25', 44, 1451);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (101, 'S.I.U.M Edilizia', '2003-09-25', 52, 1175);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5151, 'Futbol Costruzioni', '2001-10-14', 86, 1452);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1672, 'Salini Impregilo', '2002-12-07', 23, 390);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8449, 'Ankara S.R.L', '2003-12-07', 46, 1162);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3916, 'Futbol Costruzioni', '2004-05-25', 84, 1001);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2080, 'Futbol Costruzioni', '2020-10-22', 92, 1447);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8992, 'S.I.U.M Edilizia', '2021-04-23', 97, 1171);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7133, 'Futbol Costruzioni', '2019-07-18', 71, 646);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5898, 'Ankara S.R.L', '2006-10-21', 63, 1354);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (258, 'S.I.U.M Edilizia', '2018-04-28', 99, 535);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7294, 'Adam Motorola S.R.L', '2022-04-26', 30, 447);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3469, 'Futbol Costruzioni', '2009-04-24', 70, 364);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7265, 'Ankara S.R.L', '2008-10-05', 49, 1030);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9304, 'S.I.U.M Edilizia', '2011-02-28', 67, 505);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (826, 'Futbol Costruzioni', '2022-11-05', 85, 953);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8507, 'S.I.U.M Edilizia', '2019-12-12', 27, 424);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3882, 'Salini Impregilo', '2014-10-31', 48, 922);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3519, 'Futbol Costruzioni', '2002-04-04', 58, 873);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7705, 'Salini Impregilo', '2014-05-26', 73, 1190);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7836, 'Ankara S.R.L', '2020-10-19', 27, 387);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2066, 'Salini Impregilo', '2007-09-03', 91, 640);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2731, 'S.I.U.M Edilizia', '2015-05-04', 92, 1349);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8052, 'Adam Motorola S.R.L', '2020-12-17', 35, 1287);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9681, 'Futbol Costruzioni', '2020-12-26', 90, 401);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6145, 'Futbol Costruzioni', '2004-03-02', 89, 692);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3056, 'Salini Impregilo', '2017-07-28', 84, 1265);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (816, 'S.I.U.M Edilizia', '2021-04-14', 34, 1171);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (803, 'Adam Motorola S.R.L', '2022-04-26', 26, 996);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7307, 'S.I.U.M Edilizia', '2005-12-25', 93, 885);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (474, 'Salini Impregilo', '2007-08-05', 68, 1013);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2771, 'S.I.U.M Edilizia', '2015-12-21', 17, 987);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4091, 'Salini Impregilo', '2011-02-03', 79, 1492);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9503, 'Ankara S.R.L', '2018-07-02', 12, 527);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (579, 'Adam Motorola S.R.L', '2020-09-10', 99, 1078);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8049, 'Salini Impregilo', '2003-11-10', 10, 326);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1769, 'Salini Impregilo', '2007-03-29', 71, 1385);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9847, 'S.I.U.M Edilizia', '2019-06-16', 28, 351);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4127, 'Futbol Costruzioni', '2004-08-30', 18, 1317);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3351, 'Salini Impregilo', '2009-12-12', 33, 451);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7932, 'Ankara S.R.L', '2019-08-23', 55, 1225);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (152, 'Ankara S.R.L', '2018-05-20', 87, 389);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1075, 'Salini Impregilo', '2007-12-31', 98, 1144);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1789, 'S.I.U.M Edilizia', '2020-08-03', 29, 711);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6367, 'Adam Motorola S.R.L', '2019-12-16', 100, 1053);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7416, 'Salini Impregilo', '2003-03-31', 88, 552);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3573, 'Futbol Costruzioni', '2021-03-10', 34, 1092);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6659, 'Salini Impregilo', '2012-06-08', 15, 424);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6587, 'Salini Impregilo', '2003-12-28', 39, 1105);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8718, 'Ankara S.R.L', '2013-05-10', 25, 1039);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2632, 'Salini Impregilo', '2022-08-20', 86, 425);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7503, 'Salini Impregilo', '2002-08-05', 35, 1388);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9244, 'Futbol Costruzioni', '2022-08-31', 95, 635);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9004, 'S.I.U.M Edilizia', '2019-05-22', 74, 541);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4914, 'Adam Motorola S.R.L', '2005-10-02', 49, 899);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5282, 'Salini Impregilo', '2016-07-03', 14, 1229);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1273, 'Adam Motorola S.R.L', '2014-11-10', 61, 894);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8126, 'Futbol Costruzionia', '2006-01-15', 54, 736);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8639, 'S.I.U.M Edilizia', '2021-11-01', 43, 337);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9479, 'Ankara S.R.L', '2016-10-01', 41, 1238);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (900, 'Adam Motorola S.R.L', '2015-05-09', 93, 1378);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2225, 'S.I.U.M Edilizia', '2007-10-22', 79, 530);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4304, 'Futbol Costruzioni', '2018-06-22', 28, 990);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5642, 'Adam Motorola S.R.L', '2004-12-23', 32, 769);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5009, 'Salini Impregilo', '2008-03-10', 92, 356);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9369, 'S.I.U.M Edilizia', '2012-01-30', 92, 614);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7952, 'Ankara S.R.L', '2017-02-10', 39, 887);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8816, 'Adam Motorola S.R.L', '2021-05-31', 27, 521);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8061, 'S.I.U.M Edilizia', '2007-03-20', 59, 1431);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3701, 'Salini Impregilo', '2021-07-16', 74, 1282);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4608, 'Salini Impregilo', '2010-10-08', 25, 644);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9471, 'Futbol Costruzioni', '2009-03-07', 19, 529);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2425, 'Ankara S.R.L', '2020-01-08', 68, 643);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6766, 'Futbol Costruzioni', '2011-09-18', 74, 1210);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5746, 'Salini Impregilo', '2006-12-22', 48, 1434);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6695, 'S.I.U.M Edilizia', '2002-12-29', 87, 472);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8726, 'Adam Motorola S.R.L', '2016-12-10', 74, 915);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1324, 'Salini Impregilo', '2019-02-27', 18, 992);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2130, 'Futbol Costruzioni', '2009-08-11', 19, 439);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5149, 'Salini Impregilo', '2003-04-27', 18, 736);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7254, 'Ankara S.R.L', '2022-05-05', 98, 1379);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4663, 'Adam Motorola S.R.L', '2011-12-02', 76, 678);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6330, 'Futbol Costruzioni', '2003-11-30', 78, 1191);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4753, 'S.I.U.M Edilizia', '2014-10-03', 19, 333);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9062, 'Futbol Costruzioni', '2021-12-21', 41, 640);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9586, 'Salini Impregilo', '2014-04-30', 18, 1254);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1015, 'Ankara S.R.L', '2009-09-20', 40, 663);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1014, 'S.I.U.M Edilizia', '2016-01-21', 23, 704);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2274, 'Salini Impregilo', '2005-09-24', 52, 1083);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3429, 'Adam Motorola S.R.L', '2013-05-17', 55, 731);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1415, 'Futbol Costruzioni', '2018-11-11', 29, 1321);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (894, 'Ankara S.R.L', '2022-06-06', 24, 1008);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1570, 'Ankara S.R.L', '2004-03-03', 59, 840);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5012, 'Adam Motorola S.R.L', '2002-10-03', 71, 466);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (341, 'Futbol Costruzioni', '2006-09-01', 44, 770);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7334, 'S.I.U.M Edilizia', '2007-12-10', 77, 526);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (165, 'Salini Impregilo', '2010-06-24', 41, 645);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7142, 'S.I.U.M Edilizia', '2021-06-19', 96, 1168);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6795, 'Salini Impregilo', '2016-02-05', 87, 1252);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5273, 'Futbol Costruzioni', '2002-10-09', 26, 370);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4898, 'Ankara S.R.L', '2002-11-21', 41, 1215);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1417, 'S.I.U.M Edilizia', '2006-03-03', 20, 1418);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9792, 'Adam Motorola S.R.L', '2012-03-01', 86, 893);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5619, 'Futbol Costruzioni', '2015-09-28', 24, 356);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8408, 'S.I.U.M Edilizia', '2002-11-24', 38, 1027);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7589, 'Futbol Costruzioni', '2010-11-27', 70, 355);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9663, 'Salini Impregilo', '2013-08-09', 47, 342);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (573, 'Salini Impregilo', '2015-05-19', 96, 786);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6148, 'Ankara S.R.L', '2015-06-30', 32, 378);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6304, 'S.I.U.M Edilizia', '2013-07-19', 46, 410);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7632, 'Ankara S.R.L', '2008-03-01', 33, 666);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (613, 'Futbol Costruzioni', '2002-01-30', 58, 321);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3398, 'S.I.U.M Edilizia', '2010-12-11', 80, 697);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4026, 'Ankara S.R.L', '2012-11-27', 22, 744);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4950, 'Ankara S.R.L', '2011-06-29', 54, 476);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8374, 'Salini Impregilo', '2004-06-18', 24, 1331);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2961, 'Futbol Costruzioni', '2011-03-29', 26, 1203);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1876, 'Futbol Costruzioni', '2012-05-08', 88, 1091);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7180, 'S.I.U.M Edilizia', '2006-06-25', 18, 957);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5186, 'Adam Motorola S.R.L', '2014-06-03', 53, 1015);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8356, 'Salini Impregilo', '2007-07-17', 29, 978);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7324, 'S.I.U.M Edilizia', '2007-02-22', 18, 1373);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9796, 'Salini Impregilo', '2007-11-05', 70, 1390);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9993, 'Futbol Costruzioni', '2015-08-27', 14, 634);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9034, 'S.I.U.M Edilizia', '2009-05-26', 34, 891);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6864, 'Salini Impregilo', '2003-11-27', 15, 360);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3090, 'Ankara S.R.L', '2020-05-11', 43, 842);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1495, 'Adam Motorola S.R.L', '2002-02-10', 55, 1005);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5241, 'Salini Impregilo', '2010-10-24', 30, 455);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6861, 'Salini Impregilo', '2004-07-05', 50, 1452);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (473, 'Futbol Costruzioni', '2013-03-08', 15, 863);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4400, 'Salini Impregilo', '2007-01-25', 85, 741);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4186, 'Ankara S.R.L', '2022-10-30', 20, 807);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (601, 'S.I.U.M Edilizia', '2022-02-10', 33, 503);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6675, 'Futbol Costruzioni', '2010-07-09', 29, 1304);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1201, 'Salini Impregilo', '2020-08-28', 73, 627);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2403, 'Salini Impregilo', '2011-08-22', 37, 1491);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8640, 'Futbol Costruzioni', '2003-04-25', 48, 458);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3470, 'S.I.U.M Edilizia', '2018-05-24', 75, 1297);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2313, 'Ankara S.R.L', '2015-07-07', 39, 1494);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8510, 'S.I.U.M Edilizia', '2022-10-22', 29, 608);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5441, 'Futbol Costruzioni', '2000-06-27', 26, 788);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6173, 'Salini Impregilo', '2000-11-06', 28, 528);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9777, 'Adam Motorola S.R.L', '2001-10-28', 72, 421);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7341, 'S.I.U.M Edilizia', '2011-01-24', 74, 508);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4338, 'Adam Motorola S.R.L', '2000-12-24', 23, 841);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6491, 'Salini Impregilo', '2000-05-12', 84, 721);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4896, 'Salini Impregilo', '2011-06-20', 56, 1188);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5414, 'Adam Motorola S.R.L', '2008-09-14', 18, 901);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2065, 'Salini Impregilo', '2000-10-07', 21, 519);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8920, 'Salini Impregilo', '2018-04-13', 68, 1163);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6243, 'S.I.U.M Edilizia', '2000-12-30', 66, 1052);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9228, 'Salini Impregilo', '2022-06-30', 37, 836);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8848, 'Salini Impregilo', '2003-11-04', 81, 1017);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8344, 'Futbol Costruzioni', '2004-02-14', 12, 989);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4867, 'S.I.U.M Edilizia', '2022-03-04', 41, 1291);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3421, 'Ankara S.R.L', '2022-07-23', 27, 773);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8667, 'Futbol Costruzioni', '2000-08-03', 53, 1371);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6821, 'Salini Impregilo', '2000-06-01', 100, 961);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7681, 'Futbol Costruzioni', '2000-07-24', 98, 1048);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (88, 'Salini Impregilo', '2000-04-13', 87, 1400);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7608, 'Futbol Costruzioni', '2019-07-22', 93, 772);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8858, 'Adam Motorola S.R.L', '2019-08-28', 13, 1433);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5915, 'Salini Impregilo', '2020-07-22', 63, 744);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5370, 'Ankara S.R.L', '2000-04-21', 95, 349);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2093, 'S.I.U.M Edilizia', '2013-05-02', 61, 823);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2012, 'Futbol Costruzioni', '2009-10-07', 99, 621);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1449, 'Ankara S.R.L', '2000-05-19', 28, 1479);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4849, 'Adam Motorola S.R.L', '2000-03-26', 59, 914);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9024, 'Futbol Costruzioni', '2015-11-10', 99, 1483);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8545, 'Ankara S.R.L', '2000-05-04', 61, 570);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6890, 'Salini Impregilo', '2013-05-28', 15, 658);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8891, 'Adam Motorola S.R.L', '2008-05-13', 18, 650);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2738, 'Salini Impregilo', '2008-07-14', 13, 449);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8750, 'Futbol Costruzioni', '2009-03-20', 95, 1039);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (687, 'S.I.U.M Edilizia', '2020-05-12', 68, 384);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (567, 'Salini Impregilo', '2000-02-09', 34, 1445);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (589, 'Futbol Costruzioni', '2000-02-25', 92, 1244);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9756, 'S.I.U.M Edilizia', '2015-06-02', 62, 884);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7077, 'Futbol Costruzioni', '2019-05-04', 94, 758);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5756, 'Ankara S.R.L', '2019-01-23', 24, 1194);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4140, 'Adam Motorola S.R.L', '2016-05-27', 78, 1271);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6013, 'S.I.U.M Edilizia', '2000-09-02', 55, 312);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8609, 'Futbol Costruzioni', '2022-08-23', 51, 702);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8411, 'Salini Impregilo', '2000-01-25', 54, 1275);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2290, 'Ankara S.R.L', '2016-11-23', 46, 866);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7778, 'S.I.U.M Edilizia', '2012-08-17', 65, 351);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4570, 'Futbol Costruzioni', '2019-10-17', 14, 1087);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3228, 'S.I.U.M Edilizia', '2020-09-08', 31, 435);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (640, 'Ankara S.R.L', '2016-02-26', 24, 520);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2724, 'Futbol Costruzioni', '2000-11-15', 80, 1026);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4897, 'Adam Motorola S.R.L', '2000-05-20', 72, 977);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7594, 'S.I.U.M Edilizia', '2008-05-23', 56, 670);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (806, 'Salini Impregilo', '2016-01-28', 55, 641);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (52, 'Ankara S.R.L', '2000-10-06', 96, 1363);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2356, 'S.I.U.M Edilizia', '2000-03-18', 68, 544);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3660, 'Salini Impregilo', '2013-02-24', 34, 933);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1266, 'Salini Impregilo', '2000-05-19', 91, 431);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9113, 'Futbol Costruzioni', '2017-09-17', 28, 1496);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8413, 'Futbol Costruzioni', '2014-05-09', 68, 600);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2198, 'Adam Motorola S.R.L', '2006-12-06', 57, 311);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4294, 'Adam Motorola S.R.L', '2000-08-25', 34, 645);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (7994, 'Salini Impregilo', '2017-11-15', 47, 415);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (4182, 'Ankara S.R.L', '2014-07-29', 21, 836);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2154, 'Salini Impregilo', '2000-10-05', 33, 752);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (6001, 'Adam Motorola S.R.L', '2021-10-16', 97, 531);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (240, 'Ankara S.R.L', '2021-04-24', 55, 1019);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (286, 'Adam Motorola S.R.L', '2000-01-16', 68, 819);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (8469, 'Salini Impregilo', '2010-08-26', 64, 666);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (5412, 'Adam Motorola S.R.L', '2002-04-16', 65, 1360);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (519, 'Ankara S.R.L', '2000-09-06', 41, 954);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (9494, 'Salini Impregilo', '2000-02-22', 91, 485);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (370, 'Salini Impregilo', '2014-05-13', 67, 724);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2985, 'Ankara S.R.L', '2012-08-31', 100, 1265);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (3461, 'Salini Impregilo', '2017-08-14', 38, 661);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (22, 'Futbol Costruzioni', '2017-10-22', 66, 1142);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (1980, 'Futbol Costruzioni', '2010-03-07', 74, 1151);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (2973, 'Adam Motorola S.R.L', '200-04-26', 76, 450);
insert into Materiale (CodiceLotto, NomeFornitore, DataAcquisto, QuantitàAcquistata, CostoTotale) values (991, 'S.I.U.M Edilizia', '200-08-13', 99, 1272);

-- UTILIZZO

-- Carotaggi e Analisi
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1104', '88', '37');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1104', '473', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1112', '5370', '25');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1112', '8640', '10');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1120', '9777', '40');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1154', '7681', '16');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1154', '5414', '6');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1154', '4400', '3');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1164', '8344', '12');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1164', '8640', '20');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1179', '5915', '27');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1179', '687', '10');


-- Preparazione del terreno

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2104', '6491', '17');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2104', '4026', '3');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2112', '6491', '17');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2112', '519', '3');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2120', '9777', '9');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2120', '9494', '4');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2154', '6173', '20');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2154', '4950', '4');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2164', '5412', '30');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2164', '8374', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2179', '8848', '40');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2179', '370', '15');


-- Prime Fondamenta

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2204', '1876', '30');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2204', '22', '18');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2204', '6675', '8');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2212', '6864', '15');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2212', '4897', '24');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2212', '5441', '8');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2220', '1495', '10');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2220', '6013', '35');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2220', '5441', '6');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2254', '5186', '28');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2254', '7778', '17');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2254', '2403', '7');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2264', '6861', '20');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2264', '2724', '16');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2264', '8640', '4');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2279', '3090', '30');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2279', '3228', '19');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2279', '1201', '23');



-- Seconde Fondamenta

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3204', '9993', '8');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3204', '3470', '10');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3204', '4897', '4');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3212', '9796', '31');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3212', '6013', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3212', '8640', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3220', '1495', '10');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3220', '2724', '6');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3220', '5441', '10');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3254', '5186', '25');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3254', '4140', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3254', '2313', '11');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3264', '6861', '20');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3264', '4897', '5');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3264', '8640', '8');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3279', '3090', '12');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3279', '3228', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3279', '1201', '8');



-- Costruzione muri

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2128', '1876', '20');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2128', '6805', '15');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2128', '9572', '32');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2144', '9796', '15');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2144', '4507', '18');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2144', '7650', '22');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2304', '5241', '22');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2304', '7714', '28');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2304', '258', '35');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2312', '8356', '29');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2312', '423', '35');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2312', '9830', '40');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2320', '1495', '12');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2320', '4464', '20');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2320', '5151', '25');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2354', '1876', '25');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2354', '6805', '34');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2354', '7705', '40');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2364', '7180', '18');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2364', '3118', '28');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2364', '3519', '32');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2379', '6001', '32');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2379', '507', '41');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2379', '8992', '50');



-- Costruzione pavimentazione

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1128', '8750', '10');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1128', '5282', '14');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1128', '3882', '12');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1144', '5241', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1144', '8718', '8');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1144', '3469', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1304', '8413', '23');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1304', '9503', '12');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1304', '258', '16');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1312', '7324', '18');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1312', '4914', '30');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1312', '101', '22');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1320', '1495', '5');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1320', '7503', '12');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1320', '5151', '8');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1354', '8413', '20');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1354', '2066', '25');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1354', '8460', '22');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1364', '1495', '10');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1364', '7416', '20');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1364', '5898', '15');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1379', '8750', '24');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1379', '6367', '30');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1379', '7650', '26');




-- Imbiancatura

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1228', '3794', '8');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1228', '7509', '20');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1228', '1407', '25');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1244', '9461', '2');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1244', '4546', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1244', '4310', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1318', '4546', '22');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1318', '5870', '25');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1318', '4507', '30');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2136', '8505', '10');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2136', '4464', '10');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2136', '5953', '12');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2286', '3774', '5');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2286', '507', '7');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2286', '6345', '9');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3328', '999', '8');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3328', '1407', '6');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3328', '1782', '7');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3344', '8631', '9');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3344', '8651', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3344', '9025', '7');



-- Installazione sensori

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2199', '9993', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2199', '6345', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2199', '7714', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3299', '8413', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3299', '4951', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3299', '4052', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1328', '7594', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1328', '8483', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1328', '4507', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1344', '1876', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1344', '270', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1344', '9171', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2236', '8891', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2236', '776', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2236', '44', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3404', '9993', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3404', '3142', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3404', '8945', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3412', '6861', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3412', '423', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3412', '9461', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3479', '6001', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3479', '1677', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3479', '507', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1399', '4182', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1399', '6345', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1399', '7714', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2218', '6001', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2218', '507', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2218', '1677', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3399', '4182', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3399', '6336', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3399', '3142', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1218', '4182', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1218', '6336', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1218', '3142', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1286', '4182', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1286', '6336', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1286', '3142', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2299', '4182', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2299', '6336', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2299', '3142', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3336', '9796', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3336', '773', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3336', '5899', '2');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1299', '9796', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1299', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1299', '5899', '5');




-- Rafformzamento muratura

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1236', '9796', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1236', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1236', '5899', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1499', '9796', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1499', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1499', '5899', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2186', '9796', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2186', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2186', '5899', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2386', '9796', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2386', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2386', '5899', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2499', '9796', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2499', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2499', '5899', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3304', '9796', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3304', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3304', '5899', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3312', '1495', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3312', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3312', '5899', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3318', '1495', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3318', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3318', '5899', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3320', '4464', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3320', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3320', '3118', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3354', '6861', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3354', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3354', '7340', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3364', '6861', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3364', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3364', '7340', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3379', '7594', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3379', '773' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3379', '7340', '5');




-- Installazione rivestimento mura/pavimento

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2228', '4052', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2228', '3725', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2228', '8413', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3128', '9479', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3128', '900', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3128', '6766', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3144', '8126', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3144', '4608', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3144', '5642', '5');




-- Infissi

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1336', '9494', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1336', '613' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1336', '7632', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3228', '9494', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3228', '613' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3228', '7632', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3244', '9494', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3244', '613' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3244', '7632', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3186', '9494', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3186', '613' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3186', '7632', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3499', '9494', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3499', '613' , '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3499', '7632', '5');

-- rimozioni sensori/rivestimenti
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3136', '4464', '5');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3136', '3118', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3118', '4464', '5');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3118', '3118', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1136', '4464', '5');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('1136', '4546', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2244', '3459', '5');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('2244', '4546', '5');

insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3236', '3459', '3');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3386', '4546', '4');
insert into Utilizzo (IDLavoro, CodiceLotto, QuantitaUtilizzata) values ('3286', '7340', '5');


-- INTONACO
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Bianco', 		8631);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Grigio', 	2380);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	4546);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	507);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Rosa', 		5953);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	7509);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	44);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		999);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Rosa', 	5234);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Rosa', 		6345);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	5750);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		1782);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Bianco', 		5902);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	5260);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Verde', 		9025);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Bianco', 		6317);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		4494);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Giallo', 	1942);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Rosa', 	5407);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Giallo', 		6805);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Giallo', 		8010);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	768);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Bianco', 		8651);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Verde', 		776);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Giallo', 	5421);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Grigio', 	8505);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		6010);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	8621);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Rosa', 		9301);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Giallo', 	1677);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Blu', 	4099);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Grigio', 	9954);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	9461);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		4464);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	3978);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Rosa', 	6336);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Grigio', 		3118);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		4726);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Rosa', 		773);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		5870);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	5037);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Blu', 	892);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Bianco', 		3774);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		3236);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Bianco', 		3333);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Bianco', 		4052);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		270);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Grigio', 		9171);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	3794);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		8945);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	1407);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Rosso', 		4951);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Blu', 	7340);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Grigio', 	4507);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Bianco', 		7714);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco a base di gesso', 'Rosa', 		3725);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	8151);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	8192);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('intonaco a base di calce', 'Grigio', 		5899);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Rosa', 	4310);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Grigio', 	766);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	3459);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	8483);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Bianco', 	6107);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Grigio', 	3142);
insert into Intonaco (Tipo, Colore, CodiceLotto) values ('Intonaco misto cemento-calce', 'Giallo', 	423);

-- MATTONI

insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 9739);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 9794);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 9572);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 9830);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 8460);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 8648);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 3160);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 3777);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 8647);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 952);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 2429);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone Pieno', 'No', '0.06', '0.25', '0.12', 7650);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',7121);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',3290);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',7507);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',6000);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',101);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',5151);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',1672);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',8449);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',3916);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',2080);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',8992);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone in laterizio', 'No', '0.055', '0.25', '0.12',7133);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 5898);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 258);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 7294);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 3469);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 7265);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 9304);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 826);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 8507);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 3882);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 3519);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 7705);
insert into Mattoni (Tipo, Alveolatura, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Mattone forato in laterizio', 'Forato', '0.05', '0.27', '0.13', 7836);

-- PIASTRELLE

insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrato', 0.02, '4', 0.33, 2066);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrato', 0.01, '4', 0.28, 2731);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrato', 0.02, '4', 0.45, 8052);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrato', 0.02, '4', 0.37, 9681);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrato', 0.01, '4', 0.34, 6145);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrato', 0.03, '4', 0.37,3056);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrato', 0.01, '4', 0.23,816);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrato', 0.01, '4', 0.44,803);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrato', 0.03, '4', 0.27,7307);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrato', 0.02, '4', 0.25,474);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrato', 0.02, '4', 0.39, 2771);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrato', 0.02, '4', 0.26,4091);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Triangolare', 0.01, '3', 0.42, 9503);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Triangolare', 0.01, '3', 0.47, 579);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Triangolare', 0.01, '3', 0.48, 8049);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Triangolare', 0.03, '3', 0.25, 1769);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Triangolare', 0.02, '3', 0.39, 9847);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Triangolare', 0.02, '3', 0.21,4127);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Triangolare', 0.02, '3', 0.32, 3351);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Triangolare', 0.02, '3', 0.3, 7932);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Triangolare', 0.02, '3', 0.24, 152);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Triangolare', 0.03, '3', 0.3,  1075);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Triangolare', 0.01, '3', 0.36,1789);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Triangolare', 0.03, '3', 0.24, 6367);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrata con motivo floreale', 0.02, '4', 0.34, 7416);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrata con motivo floreale', 0.01, '4', 0.4, 	3573);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrata con motivo floreale', 0.02, '4', 0.48, 6659);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrata con motivo floreale', 0.03, '4', 0.39, 6587);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrata con motivo floreale', 0.01, '4', 0.36, 	8718);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrata con motivo floreale', 0.02, '4', 0.44, 2632);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrata con motivo floreale', 0.03, '4', 0.31, 7503);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrata con motivo floreale', 0.02, '4', 0.33, 9244);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla bianca', 'Quadrata con motivo floreale', 0.01, '4', 0.5, 	9004);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrata con motivo floreale', 0.01, '4', 0.3, 	4914);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrata con motivo floreale', 0.03, '4', 0.42, 	5282);
insert into Piastrelle (Composizione, Disegno, Fuga, NumeroLati, LunghezzaLato, CodiceLotto) values ('Argilla Rossa', 'Quadrata con motivo floreale', 0.01, '4', 0.44, 	1273);

-- PARQUET

insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di acacia', 0.01, 0.26, 0.07, 	8126);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di ciliegio', 0.02, 0.72, 0.06, 	8639);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di noce', 0.01, 0.71, 0.04, 	9479);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di frassino', 0.03, 0.73, 0.1, 	900);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di acero', 0.02, 0.45, 0.05, 	2225);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di acacia', 0.03, 0.52, 0.15, 	4304);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di noce', 0.03, 0.46, 0.06, 	5642);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di quercia', 0.01, 0.2, 0.14, 	5009);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di frassino', 0.01, 0.54, 0.11, 	9369);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di noce', 0.02, 0.47, 0.14, 	7952);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di acero', 0.02, 0.73, 0.11, 	8816);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di frassino', 0.02, 0.32, 0.06, 	8061);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di acacia', 0.01, 0.26, 0.13, 	3701);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di ciliegio', 0.03, 0.45, 0.11, 	4608);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di quercia', 0.02, 0.85, 0.06, 	9471);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di ciliegio', 0.01, 0.35, 0.05, 	2425);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di acero', 0.01, 0.2, 0.1, 		6766);
insert into Parquet (TipoLegno, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno di quercia', 0.01, 0.45, 0.08, 	5746);

-- MURO

insert into Muro (Tipologia, IDVano) values ('Soffitto', 599);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 599);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 599);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 599);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 599);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 599);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 1848);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 1848);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 1848);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 1848);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 1848);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 1848);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 2586);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 2586);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 2586);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 2586);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 2586);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 2586);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 6126);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 6126);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 6126);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 6126);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 6126);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 6126);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 7505);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 7505);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 7505);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 7505);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 7505);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest',7505);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 12853);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 12853);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 12853);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 12853);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 12853);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 12853);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 13905);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 13905);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 13905);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 13905);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 13905);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 13905);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 15712);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 15712);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 15712);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 15712);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 15712);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 15712);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 19177);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 19177);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 19177);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 19177);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 19177);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 19177);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 21719);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 21719);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 21719);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 21719);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 21719);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 21719);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 23257);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 23257);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 23257);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 23257);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 23257);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 23257);


insert into Muro (Tipologia, IDVano) values ('Soffitto', 24767);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 24767);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 24767);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 24767);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 24767);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 24767);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 27768);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 27768);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 27768);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 27768);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 27768);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest',27768);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 30890);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 30890);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 30890);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 30890);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 30890);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 30890);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 32499);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 32499);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 32499);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 32499);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 32499);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 32499);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 3803);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 3803);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 3803);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 3803);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 3803);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 3803);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 6020);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 6020);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 6020);
insert into Muro (Tipologia, IDVano) values ('Muro Sud',6020);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 6020);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 6020);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 15372);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 15372);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 15372);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 15372);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 15372);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 15372);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 22532);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 22532);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 22532);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 22532);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 22532);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 22532);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 25897);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 25897);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 25897);
insert into Muro (Tipologia, IDVano) values ('Muro Sud',25897);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 25897);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 25897);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 26006);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 26006);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 26006);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 26006);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 26006);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 26006);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 32118);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 32118);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 32118);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 32118);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 32118);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 32118);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 1340);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 1340);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 1340);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 1340);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 1340);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 1340);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 5425);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 5425);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 5425);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 5425);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 5425);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 5425);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 7021);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 7021);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 7021);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 7021);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 7021);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 7021);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 9927);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 9927);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 9927);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 9927);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 9927);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 9927);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 12854);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 12854);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 12854);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 12854);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 12854);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 12854);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 13101);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 13101);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 13101);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 13101);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 13101);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 13101);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 13550);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 13550);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 13550);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 13550);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 13550);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 13550);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 19356);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 19356);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 19356);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 19356);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 19356);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 19356);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 22738);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 22738);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 22738);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 22738);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 22738);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 22738);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 27267);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 27267);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 27267);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 27267);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 27267);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 27267);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 18471);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 18471);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 18471);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 18471);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 18471);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 18471);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 30351);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 30351);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 30351);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 30351);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 30351);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 30351);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 21523);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 21523);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 21523);
insert into Muro (Tipologia, IDVano) values ('Muro Sud',21523);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 21523);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 21523);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 22700);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 22700);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 22700);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 22700);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 22700);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 22700);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 9792);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 9792);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 9792);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 9792);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 9792);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 9792);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 16833);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 16833);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 16833);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 16833);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 16833);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 16833);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 19765);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 19765);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 19765);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 19765);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 19765);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 19765);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 15714);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 15714);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 15714);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 15714);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 15714);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 15714);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 19117);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 19117);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 19117);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 19117);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 19117);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 19117);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 23719);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 23719);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 23719);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 23719);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 23719);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 23719);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 24567);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 24567);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 24567);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 24567);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 24567);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 24567);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 30880);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 30880);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 30880);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 30880);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 30880);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 30880);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 32469);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 32469);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 32469);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 32469);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 32469);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 32469);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 59966);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 59966);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 59966);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 59966);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 59966);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 59966);

insert into Muro (Tipologia, IDVano) values ('Soffitto', 258613);
insert into Muro (Tipologia, IDVano) values ('Pavimento', 258613);
insert into Muro (Tipologia, IDVano) values ('Muro Nord', 258613);
insert into Muro (Tipologia, IDVano) values ('Muro Sud', 258613);
insert into Muro (Tipologia, IDVano) values ('Muro Est', 258613);
insert into Muro (Tipologia, IDVano) values ('Muro Ovest', 258613);

-- PIETRA

insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Granito', 0.03, 0.17, 0.1,   	6695,	  12,8 , 'naturale', 'Rivestimento', 'Muro Est', 19765);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Granito', 0.04, 0.14, 0.11,  	8726,	  14,5, 'orizzontale', 'Rivestimento', 'Muro Sud', 23719);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Granito', 0.02, 0.11, 0.09, 		1324, 25,3 , 'naturale', 'Rivestimento', 		'Muro Sud',599);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Granito', 0.03, 0.12, 0.08, 		2130, 10,4 , 'naturale', 'Rivestimento', 		'Muro Sud',1340);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Granito', 0.04, 0.11, 0.09, 		5149, 17,7 , 'orizzontale', 'Rivestimento', 	'Muro Sud',1848);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Basalto', 0.02, 0.11, 0.12, 		7254, 9,5 , 'orizzontale', 'Rivestimento', 	'Muro Sud',2586);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Basalto', 0.02, 0.13, 0.09,		4663, 15,6 , 'naturale', 'Rivestimento', 		'Muro Sud',3803);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Basalto', 0.03, 0.13, 0.11, 		6330, 22,6 , 'naturale', 'Rivestimento', 		'Muro Sud',5425);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Basalto', 0.02, 0.12, 0.07, 		4753, 14,13 , 'verticale', 'Rivestimento', 		'Muro Sud',6126);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Basalto', 0.02, 0.14, 0.08, 		9062, 14,8 , 'naturale', 'Rivestimento', 		'Muro Ovest',	6126);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Quarzite', 0.03, 0.13, 0.08, 		9586, 21,17 , 'naturale', 'Rivestimento', 		'Muro Ovest',	7021);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Quarzite', 0.04, 0.14, 0.08, 		1015, 10,14 , 'orizzontale', 'Rivestimento', 	'Muro Ovest',	7505);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Quarzite', 0.02, 0.11, 0.1, 		1014, 28,7 , 'orizzontale', 'Rivestimento', 	'Muro Ovest',	9792);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Quarzite', 0.01, 0.16, 0.09, 		2274, 18,11 , 'verticale', 'Rivestimento', 		'Muro Ovest',	9927);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Quarzite', 0.03, 0.14, 0.08, 		3429, 24,13 , 'naturale', 'Rivestimento', 		'Muro Ovest',	12853);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Ardesia', 0.05, 0.15, 0.07, 		1415, 9,10 , 'orizzontale', 'Rivestimento', 	'Muro Ovest',	12854);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Ardesia', 0.04, 0.13, 0.08, 		894,   14,5 , 'orizzontale', 'Rivestimento', 	'Muro Nord',6126);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Ardesia', 0.04, 0.15, 0.1, 		1570, 40,9 , 'orizzontale', 'Rivestimento', 	'Muro Nord',7021);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Ardesia', 0.04, 0.12, 0.07, 		5012, 7,6 , 'verticale', 'Rivestimento', 		'Muro Nord',7505);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Ardesia', 0.03, 0.13, 0.1, 		341,   6,11 , 'verticale', 'Rivestimento', 		'Muro Nord',9792);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Travertino', 0.01, 0.17, 0.09, 	7334, 12,9 , 'naturale', 'Rivestimento', 		'Muro Nord',9927);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Travertino', 0.03, 0.15, 0.09, 	165,   11,0 , 'orizzontale', 'Rivestimento', 	'Muro Nord',12853);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Travertino', 0.03, 0.1, 0.09, 		7142, 10,4 , 'orizzontale', 'Rivestimento', 	'Muro Nord',12854);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Travertino', 0.05, 0.12, 0.09, 	6795, 5,7  ,'naturale', 'Rivestimento', 		'Muro Nord',13101);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Travertino', 0.03, 0.13, 0.09, 	5273, 15,7 , 'naturale', 'Rivestimento', 		'Muro Est',30351);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Arenaria', 0.02, 0.12, 0.07, 		4898, 9,12 , 'naturale', 'Rivestimento', 		'Muro Est',30880);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Arenaria', 0.02, 0.12, 0.08, 		1417, 24,9 , 'naturale', 'Rivestimento', 		'Muro Est',30890);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Arenaria', 0.05, 0.11, 0.1, 		9792, 15,7 , 'naturale', 'Rivestimento', 		'Muro Est',32118);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Arenaria', 0.05, 0.12, 0.09, 		5619, 15,8 , 'naturale', 'Rivestimento', 		'Muro Est',32469);
insert into Pietra (Tipo, Altezza, Lunghezza, Larghezza, CodiceLotto, Superficie, PesoMedio, Disposizione, Utilizzo, Tipologia, IDVano) values ('Arenaria', 0.03, 0.14, 0.08, 		8408, 12,6 , 'orizzontale', 'Rivestimento', 	'Muro Est',32499);

-- MATERIALEVARIO

insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 3, 1, 4, '7589');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 2, 7, 7, '9663');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 2, 7, 5, '573');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 1, 7, 8, '6148');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 4, 3, 4, '6304');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 1, 4, 7, '7632');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 3, 5, 2, '613');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 8, 7, 8, '3398');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 2, 5, 2, '4026');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 3, 5, 5, '4950');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 6, 5, 7, '8374');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 4, 4, 8, '2961');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 2, 7, 7, '1876');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 5, 6, 4, '7180');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 1, 3, 6, '5186');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 3, 5, 6, '8356');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 8, 2, 7, '7324');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 3, 5, 7, '9796');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 7, 6, 2, '9993');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 8, 8, 6, '9034');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 6, 4, 4, '6864');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 6, 3, 5, '3090');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 1, 6, 6, '1495');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 5, 4, 1, '5241');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 8, 3, 4, '6861');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 3, 2, 6, '473');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 1, 5, 4, '4400');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 6, 3, 4, '4186');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 7, 1, 4, '601');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 7, 8, 7, '6675');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 3, 2, 2, '1201');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 1, 1, 4, '2403');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 8, 6, 1, '8640');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 4, 7, 1, '3470');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 5, 1, 8, '2313');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 7, 6, 3, '8510');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 4, 8, 8, '5441');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 1, 4, 6, '6173');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 5, 7, 8, '9777');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 7, 2, 8, '7341');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 2, 7, 3, '4338');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 5, 3, 7, '6491');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 8, 8, 8, '4896');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 2, 5, 2, '5414');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 5, 7, 1, '2065');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 8, 8, 1, '8920');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 6, 4, 3, '6243');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 8, 7, 6, '9228');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 5, 8, 4, '8848');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 6, 3, 3, '8344');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 8, 7, 7, '4867');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 2, 5, 1, '3421');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 6, 8, 8, '8667');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 8, 4, 3, '6821');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 8, 8, 3, '7681');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 1, 5, 6, '88');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 6, 3, 4, '7608');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 5, 4, 5, '8858');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 4, 6, 2, '5915');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 8, 3, 2, '5370');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 5, 1, 4, '2093');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghisa', 4, 3, 8, '2012');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghisa', 4, 5, 5, '1449');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghisa', 7, 7, 4, '4849');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghisa', 2, 3, 7, '9024');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghisa', 1, 2, 8, '8545');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghisa', 5, 6, 1, '6890');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 2, 7, 7, '8891');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 1, 2, 4, '2738');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 4, 7, 7, '8750');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 4, 4, 8, '687');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghisa', 6, 4, 7, '567');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghisa', 3, 7, 7, '589');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 8, 4, 6, '9756');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 6, 4, 7, '7077');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 3, 7, 2, '5756');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 3, 5, 2, '4140');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 7, 8, 7, '6013');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 4, 6, 3, '8609');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 8, 6, 8, '8411');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 6, 4, 1, '2290');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 5, 8, 1, '7778');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 8, 5, 3, '4570');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 5, 7, 8, '3228');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 6, 8, 1, '640');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 8, 4, 5, '2724');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 6, 7, 7, '4897');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 5, 4, 1, '7594');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Acciaio', 5, 1, 7, '806');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Acciaio', 4, 6, 2, '52');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Acciaio', 8, 5, 7, '2356');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Acciaio', 4, 3, 1, '3660');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Acciaio', 4, 2, 8, '1266');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Acciaio', 4, 6, 1, '9113');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 2, 2, 6, '8413');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Acciaio', 1, 5, 6, '2198');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Acciaio', 1, 8, 4, '4294');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Acciaio', 2, 6, 2, '7994');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 4, 7, 7, '4182');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Acciaio', 6, 7, 4, '2154');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 1, 4, 1, '6001');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Cemento', 2, 5, 3, '240');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 5, 6, 6, '286');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 4, 2, 1, '8469');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Sabbia', 5, 8, 8, '5412');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 3, 7, 3, '519');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 5, 2, 6, '9494');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Legno', 1, 3, 5, '370');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 1, 1, 4, '2985');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ghiaia', 2, 2, 7, '3461');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 5, 5, 3, '22');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Ferro', 4, 7, 4, '1980');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 2, 4, 4, '2973');
insert into MaterialeVario (Nome, Altezza, Lunghezza, Larghezza, CodiceLotto) values ('Terra', 4, 6, 5, '991');

-- OPERAIO

insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('ZTIRNZ62P02D612Q', 'Renzo', 'Zito', 			'1962-09-02');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('MLNVTI65H29F205T', 'Vito', 'Milani', 		'1965-06-29');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('RCRRND67E09E625O', 'Rolando', 'Arcuri', 		'1967-05-09');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('NGLFVN70A23H294L', 'Flaviano', 'Angelo', 	'1970-01-23');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('NPLSFN70D04G702O', 'Serafino', 'Napolitano', '1970-04-04');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('SPSGCH70H29L190F', 'Gioacchino', 'Esposito', '1970-06-29');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('DMTBRS71L02B157G', 'Demetrio', 'Baresi', 	'1971-07-02');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('MRNRNU71T11I754C', 'Uranio', 'Marino', 		'1971-12-11');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('GLLBNC72M04D969U', 'Brancaleone', 'Gallo', 	'1972-08-04');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('CNTDGI73H21A326R', 'Diego', 'Conti', 		'1973-06-21');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('LNGGTN74E06A944O', 'Gastone', 'Longo', 		'1974-05-06');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('BLLNNZ75M27D548P', 'Nunzio', 'Belli', 		'1975-08-27');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('RCRFDN81A24G482Z', 'Frediano', 'Arcuri', 	'1978-01-24');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('BNVZEI87D15E202W', 'Ezio', 'Benventi', 		'1987-04-15');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('GNLGNI88M22H703T', 'Gino', 'Agnello', 		'1988-08-22');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('LGGCST90E16L378S', 'Cristiano', 'Loggia', 	'1990-05-16');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('FRNMRN91H27L117O', 'Mariano', 'Franco', 		'1991-06-27');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('CSTLDL91T12G337L', 'Landolfo', 'Costa', 		'1991-12-11');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('PGNNDM92D13G942F', 'Nicodemo', 'Pagnotto', 	'1992-04-13');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('CTTBTE93D17D643F', 'Beato', 'Cattaneo', 		'1993-04-17');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('PLRRRG94B22G273G', 'Arrigo', 'Palerma', 		'1994-02-22');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('RSSNNI95S21I726F', 'Nino', 'Rossi', 			'1995-11-22');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('BNORMG96D07A794V', 'Remigo', 'Boni', 		'1996-04-07');
insert into Operaio (CodFiscale, Nome, Cognome, DataNascita) values ('NOIMRL77C03M297H', 'Maurilio', 'Onio', 		'1997-03-03');


-- TURNO

DROP PROCEDURE IF EXISTS PopolamentoTurno;

DELIMITER $$
CREATE PROCEDURE PopolamentoTurno ()
BEGIN

DECLARE i INTEGER DEFAULT 1;
DECLARE Dataturno DATE DEFAULT CURRENT_DATE;

WHILE i<100 DO

IF ( (dayofweek(Dataturno) <> 1) AND (dayofweek(Dataturno)<> 7) ) THEN
BEGIN
-- LAVORO 1
CALL InserimentoTurni('BLLNNZ75M27D548P',Dataturno,'08:00:00','12:00:00',3318);
CALL InserimentoTurni('BLLNNZ75M27D548P',Dataturno,'14:00:00','18:00:00',3318);

CALL InserimentoTurni('BNORMG96D07A794V',Dataturno,'08:00:00','12:00:00',3318);
CALL InserimentoTurni('BNORMG96D07A794V',Dataturno,'14:00:00','18:00:00',3318);

CALL InserimentoTurni('BNVZEI87D15E202W',Dataturno,'08:00:00','12:00:00',3318);
CALL InserimentoTurni('BNVZEI87D15E202W',Dataturno,'14:00:00','18:00:00',3318);

CALL InserimentoTurni('CNTDGI73H21A326R',Dataturno,'08:00:00','12:00:00',3318);
CALL InserimentoTurni('CNTDGI73H21A326R',Dataturno,'14:00:00','18:00:00',3318);

CALL InserimentoTurni('CSTLDL91T12G337L',Dataturno,'08:00:00','12:00:00',3318);
CALL InserimentoTurni('CSTLDL91T12G337L',Dataturno,'14:00:00','18:00:00',3318);

CALL InserimentoTurni('CTTBTE93D17D643F',Dataturno,'08:00:00','12:00:00',3318);
CALL InserimentoTurni('CTTBTE93D17D643F',Dataturno,'14:00:00','18:00:00',3318);

-- LAVORO 2

CALL InserimentoTurni('DMTBRS71L02B157G',Dataturno,'08:00:00','12:00:00',3386);
CALL InserimentoTurni('DMTBRS71L02B157G',Dataturno,'14:00:00','18:00:00',3386);

CALL InserimentoTurni('FRNMRN91H27L117O',Dataturno,'08:00:00','12:00:00',3386);
CALL InserimentoTurni('FRNMRN91H27L117O',Dataturno,'14:00:00','18:00:00',3386);

CALL InserimentoTurni('GLLBNC72M04D969U',Dataturno,'08:00:00','12:00:00',3386);
CALL InserimentoTurni('GLLBNC72M04D969U',Dataturno,'14:00:00','18:00:00',3386);

CALL InserimentoTurni('GNLGNI88M22H703T',Dataturno,'08:00:00','12:00:00',3386);
CALL InserimentoTurni('GNLGNI88M22H703T',Dataturno,'14:00:00','18:00:00',3386);

CALL InserimentoTurni('LGGCST90E16L378S',Dataturno,'08:00:00','12:00:00',3386);
CALL InserimentoTurni('LGGCST90E16L378S',Dataturno,'14:00:00','18:00:00',3386);

CALL InserimentoTurni('LNGGTN74E06A944O',Dataturno,'08:00:00','12:00:00',3386);
CALL InserimentoTurni('LNGGTN74E06A944O',Dataturno,'14:00:00','18:00:00',3386);

CALL InserimentoTurni('MLNVTI65H29F205T',Dataturno,'08:00:00','12:00:00',3386);
CALL InserimentoTurni('MLNVTI65H29F205T',Dataturno,'14:00:00','18:00:00',3386);

CALL InserimentoTurni('MRNRNU71T11I754C',Dataturno,'08:00:00','12:00:00',3386);
CALL InserimentoTurni('MRNRNU71T11I754C',Dataturno,'14:00:00','18:00:00',3386);


SET i = i + 1;
END ;
END IF ;

SET Dataturno = Dataturno + INTERVAL 1 DAY;

END WHILE ;

END $$
DELIMITER ;

CALL PopolamentoTurno;

-- SENSORE 

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (124767, 'Livello Precipitazioni', 1, 1, 1, 1, 24767);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (224767, 'Accelerometro', 1, 1, 1, 1, 24767);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (324767, 'Giroscopio', 1, 1, 1, 1, 24767);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (121719, 'Posizione', 1, 1, 1, 1, 21719);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (221719, 'Temperatura Interna', 1, 1, 1, 1, 21719);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (119177, 'Temperatura Esterna', 1, 1, 1, 1, 19177);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (219177, 'Umidità Interna', 1, 1, 1, 1, 19177);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (130890, 'Umidità Esterna', 1, 1, 1, 1, 30890);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (230890, 'Livello Precipitazioni', 1, 1, 1, 1, 30890);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (330890, 'Accelerometro', 1, 1, 1, 1, 30890);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (1599, 'Giroscopio', 1, 1, 1, 1, 599);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (2599, 'Posizione', 1, 1, 1, 1, 599);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (12586, 'Temperatura Interna', 1, 1, 1, 1, 2586);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (22586, 'Temperatura Esterna', 1, 1, 1, 1, 2586);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (115712, 'Umidità Interna', 1, 1, 1, 1, 15712);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (215712, 'Umidità Esterna', 1, 1, 1, 1, 15712);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (132499, 'Livello Precipitazioni', 1, 1, 1, 1, 32499);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (232499, 'Accelerometro', 1, 1, 1, 1, 32499);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (17505, 'Giroscopio', 1, 1, 1, 1, 7505);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (27505, 'Posizione', 1, 1, 1, 1, 7505);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (11848, 'Temperatura Interna', 1, 1, 1, 1, 1848);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (21848, 'Temperatura Esterna', 1, 1, 1, 1, 1848);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (112853, 'Umidità Interna', 1, 1, 1, 1, 12853);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (212853, 'Umidità Esterna', 1, 1, 1, 1, 12853);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (113905, 'Livello Precipitazioni', 1, 1, 1, 1, 13905);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (213905, 'Accelerometro', 1, 1, 1, 1, 13905);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (123257, 'Giroscopio', 1, 1, 1, 1, 23257);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (223257, 'Posizione', 1, 1, 1, 1, 23257);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (16126, 'Temperatura Interna', 1, 1, 1, 1, 6126);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (26126, 'Temperatura Esterna', 1, 1, 1, 1, 6126);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (115372, 'Umidità Interna', 1, 1, 1, 1, 15372);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (215372, 'Umidità Esterna', 1, 1, 1, 1, 15372);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (315372, 'Livello Precipitazioni', 1, 1, 1, 1, 15372);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (125897, 'Accelerometro', 1, 1, 1, 1, 25897);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (225897, 'Giroscopio', 1, 1, 1, 1, 25897);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (122532, 'Posizione', 1, 1, 1, 1, 22532);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (222532, 'Temperatura Interna', 1, 1, 1, 1, 22532);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (132118, 'Temperatura Esterna', 1, 1, 1, 1, 32118);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (232118, 'Umidità Interna', 1, 1, 1, 1, 32118);	

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (16020, 'Umidità Esterna', 1, 1, 1, 1, 6020);	
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (26020, 'Livello Precipitazioni', 1, 1, 1, 1, 6020);	
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (36020, 'Accelerometro', 1, 1, 1, 1, 6020);	

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (126006, 'Giroscopio', 1, 1, 1, 1, 26006);	
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (226006, 'Posizione', 1, 1, 1, 1, 26006);	

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (13803, 'Temperatura Interna', 1, 1, 1, 1, 3803);	

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (113550, 'Temperatura Esterna', 1, 1, 1, 1, 13550);	
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (213550, 'Umidità Interna', 1, 1, 1, 1, 13550);	

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (127267, 'Umidità Esterna', 1, 1, 1, 1, 27267);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (227267, 'Livello Precipitazioni', 1, 1, 1, 1, 27267);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (119356, 'Accelerometro', 1, 1, 1, 1, 19356);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (219356, 'Giroscopio', 1, 1, 1, 1, 19356);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (112854, 'Posizione', 1, 1, 1, 1, 12854);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (212854, 'Temperatura Interna', 1, 1, 1, 1, 12854);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (122738, 'Temperatura Esterna', 1, 1, 1, 1, 22738);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (222738, 'Umidità Interna', 1, 1, 1, 1, 22738);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (19927, 'Umidità Esterna', 1, 1, 1, 1, 9927);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (29927, 'Livello Precipitazioni', 1, 1, 1, 1, 9927);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (39927, 'Accelerometro', 1, 1, 1, 1, 9927);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (113101, 'Giroscopio', 1, 1, 1, 1, 13101);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (213101, 'Posizione', 1, 1, 1, 1, 13101);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (15425, 'Temperatura Interna', 1, 1, 1, 1, 5425);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (25425, 'Temperatura Esterna', 1, 1, 1, 1, 5425);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (11340, 'Umidità Interna', 1, 1, 1, 1, 1340);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (21340, 'Umidità Esterna', 1, 1, 1, 1, 1340);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (31340, 'Livello Precipitazioni', 1, 1, 1, 1, 1340);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (17021, 'Accelerometro', 1, 1, 1, 1, 7021);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (27021, 'Giroscopio', 1, 1, 1, 1, 7021);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (118471, 'Posizione', 1, 1, 1, 1, 18471);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (218471, 'Temperatura Interna', 1, 1, 1, 1, 18471);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (130351, 'Temperatura Esterna', 1, 1, 1, 1, 30351);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (230351, 'Umidità Interna', 1, 1, 1, 1, 30351);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (121523, 'Umidità Esterna', 1, 1, 1, 1, 21523);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (221523, 'Livello Precipitazioni', 1, 1, 1, 1, 21523);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (321523, 'Accelerometro', 1, 1, 1, 1, 21523);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (122700, 'Giroscopio', 1, 1, 1, 1, 22700);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (222700, 'Posizione', 1, 1, 1, 1, 22700);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (119765, 'Temperatura Interna', 1, 1, 1, 1, 19765);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (219765, 'Temperatura Esterna', 1, 1, 1, 1, 19765);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (116833, 'Umidità Interna', 1, 1, 1, 1, 16833);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (216833, 'Umidità Esterna', 1, 1, 1, 1, 16833);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (19792, 'Livello Precipitazioni', 1, 1, 1, 1, 9792);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (29792, 'Accelerometro', 1, 1, 1, 1, 9792);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (39792, 'Giroscopio', 1, 1, 1, 1, 9792);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (124567, 'Posizione', 1, 1, 1, 1, 24567);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (224567, 'Temperatura Interna', 1, 1, 1, 1, 24567);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (123719, 'Temperatura Esterna', 1, 1, 1, 1, 23719);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (223719, 'Umidità Interna', 1, 1, 1, 1, 23719);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (119117 ,'Umidità Esterna', 1, 1, 1, 1, 19117);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (219117, 'Livello Precipitazioni', 1, 1, 1, 1, 19117);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (130880, 'Accelerometro', 1, 1, 1, 1, 30880);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (230880, 'Giroscopio', 1, 1, 1, 1, 30880);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (159966, 'Posizione', 1, 1, 1, 1, 59966);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (259966, 'Temperatura Interna', 1, 1, 1, 1, 59966);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (1258613, 'Temperatura Esterna', 1, 1, 1, 1, 258613);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (2258613, 'Umidità Interna', 1, 1, 1, 1, 258613);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (115714, 'Umidità Esterna', 1, 1, 1, 1, 15714);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (215714, 'Livello Precipitazioni', 1, 1, 1, 1, 15714);

insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (132469, 'Accelerometro', 1, 1, 1, 1, 32469);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (232469, 'Giroscopio', 1, 1, 1, 1, 32469);
insert into Sensore (idSensore, TipoSensore, PosizioneX, PosizioneY, PosizioneZ, SogliaDiSicurezza, IDVano) values (332469, 'Posizione', 1, 1, 1, 1, 32469);
																			

-- COLLEGAMENTO



INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 	24767, 759);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 21719, 759);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 21719, 924);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 19177, 924);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 19177, 1226);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 24767, 1226);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 24767, 522);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 599, 1342);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 2586, 1342);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 2586, 1864);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 30890, 1864);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 30890, 2018);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 599, 2018);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 599, 556);



INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 15712, 2188);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 7505, 2188);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 7505, 2425);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 32499, 2425);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 32499, 3011);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 15712, 3011);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 15712, 978);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 1848, 3097);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 12853, 3097);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 12853, 3170);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 13905, 3170);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 13905, 3200);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 1848, 3200);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 1848, 980);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 23257, 3212);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 6126, 3212);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 6126, 3349);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 27768, 3349);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 27768, 3693);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 23257, 3693);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 23257, 1052);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 22532, 3747);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 32118, 3747);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 32118, 3831);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 25897, 3831);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 25897, 4605);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 15372, 4605);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 22532, 1369);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',6020 , 4712);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 26006, 4712);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 26006, 4751);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 3803, 4751);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 3803, 5069);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 6020, 5069);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 6020, 1398);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 19356, 5080);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 13550, 5080);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 13550, 5173);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 27267, 5173);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 12854, 5203);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 27267, 5203);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 27267, 1610);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',22738 , 5293);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 13101, 5293);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 13101, 5325);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 9927, 5325);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 9927, 5357);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 22738, 5357);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 22738, 1686);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',1340 , 5364);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 7021, 5364);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 7021, 5462);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 5425, 5462);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 5425, 5600);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 1340, 5600);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 1340, 1728);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',18471 , 6058);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 30351, 6058);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 18471, 9783);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 30351, 2148);






INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',21523 , 6476);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 22700, 6476);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 21523, 2242);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 22700, 2279);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',19765 , 6724);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 16833, 6724);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 16833, 6817);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 9792, 6817);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 9792, 6893);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Sud', 19765, 6893);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Nord', 19765, 2280);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',23719 , 7027);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 24567, 7027);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 23719, 2412);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 24567, 2482);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',19117 , 7348);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 30880, 7348);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 19117, 2486);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 30880, 3003);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',59966 , 7402);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 258613, 7402);

INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est', 59966, 3671);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 258613, 4682);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',15714 , 4964);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 15714, 5019);





INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Est',32469 , 5144);
INSERT INTO Collegamento (Tipologia, IDVano, idAccesso) VALUES ('Muro Ovest', 32469, 5186);




                                                                                                                                                                                              









                                                                                        



