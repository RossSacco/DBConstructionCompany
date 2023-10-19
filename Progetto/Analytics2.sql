-- ANALYTICS 2 --

DROP FUNCTION IF EXISTS LivelloRischio;
DELIMITER $$
CREATE FUNCTION LivelloRischio (_Fascia VARCHAR(45))
RETURNS INTEGER DETERMINISTIC
BEGIN
DECLARE Livello INTEGER;

CASE
	WHEN _Fascia = 'Molto Basso' THEN
		SET Livello = 1;
	WHEN _Fascia = 'Basso' THEN
		SET Livello = 2;
	WHEN _Fascia = 'Quasi Basso' THEN
		SET Livello = 3;
	WHEN _Fascia = 'Medio Basso' THEN
		SET Livello = 4;
	WHEN _Fascia = 'Medio' THEN
		SET Livello = 5;
	WHEN _Fascia = 'Medio Alto' THEN
		SET Livello = 6;
	WHEN _Fascia = 'Elevato' THEN
		SET Livello = 8;
	WHEN _Fascia = 'Estremo' THEN
		SET Livello = 10;

END CASE ;

RETURN Livello;

END $$
DELIMITER ;

DROP FUNCTION IF EXISTS FasciaSalute;
DELIMITER $$
CREATE FUNCTION FasciaSalute (_LivelloSalute FLOAT)
RETURNS VARCHAR(45) DETERMINISTIC
BEGIN
DECLARE _FasciaSalute VARCHAR(45);

CASE
	WHEN _LivelloSalute BETWEEN 0 AND 1.5	 	THEN
		SET _FasciaSalute = 'Ottimo';
	WHEN _LivelloSalute BETWEEN 1.51 AND 3   	THEN
		SET _FasciaSalute = 'Buono';
	WHEN _LivelloSalute BETWEEN 3.01 AND 4.5	THEN
		SET _FasciaSalute = 'Discreto';
	WHEN _LivelloSalute BETWEEN 4.51 AND 6  	THEN
		SET _FasciaSalute = 'Sufficiente';
	WHEN _LivelloSalute BETWEEN 6.01 AND 8 		THEN
		SET _FasciaSalute = 'Scarso';
	WHEN _LivelloSalute BETWEEN 8.01 AND 10		THEN
		SET _FasciaSalute = 'Pessimo';
	WHEN _LivelloSalute > 10					THEN
		SET _FasciaSalute = 'Crollo immediato';


END CASE ;

RETURN _FasciaSalute;

END $$
DELIMITER ;

DROP FUNCTION IF EXISTS FasciaDanni;
DELIMITER $$
CREATE FUNCTION FasciaDanni (_LivelloDanni FLOAT)
RETURNS VARCHAR(45) DETERMINISTIC
BEGIN
DECLARE _FasciaDanni VARCHAR(45);

CASE
	WHEN _LivelloDanni BETWEEN 0 AND 2	 		THEN
		SET _FasciaDanni = 'Nulli';
	WHEN _LivelloDanni BETWEEN 2.01 AND 4   	THEN
		SET _FasciaDanni = 'Bassi';
	WHEN _LivelloDanni BETWEEN 4.01 AND 5.50	THEN
		SET _FasciaDanni = 'Medi';
	WHEN _LivelloDanni BETWEEN 5.51 AND 6.50  	THEN
		SET _FasciaDanni = 'Consistenti';
	WHEN _LivelloDanni BETWEEN 6.51 AND 7.50 	THEN
		SET _FasciaDanni = 'Elevati';
	WHEN _LivelloDanni BETWEEN 7.51 AND 10		THEN
		SET _FasciaDanni = 'Catastrofici';



END CASE ;

RETURN _FasciaDanni;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS Analytics2;
DELIMITER $$
CREATE PROCEDURE Analytics2 (IN _Edificio INT)
BEGIN

DECLARE NumeroVani INTEGER DEFAULT 1;
DECLARE DataSismaPrecedente TIMESTAMP ;
DECLARE RIschioArea INTEGER DEFAULT 0;
DECLARE LivelloSismaPrecedente INTEGER DEFAULT 0;

IF _Edificio NOT IN (
						SELECT E1.IDEdificio
                        FROM edificio E1
					)
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Edificio inesistente';
END IF;

CALL Analytics1(_Edificio);
-- Metto dentro la variabile il numero di vani dell'edificio
SET NumeroVani = (
					SELECT COUNT(*)
                    FROM vano V1
                    WHERE V1.IDEdificio=_Edificio
				);
SET DataSismaPrecedente = (
							SELECT  MAX(C1.Timestamp)
                            FROM edificio E1 
								 NATURAL JOIN
                                 areageografica AG1
                                 INNER JOIN calamità C1 ON AG1.idArea=C1.idArea
							WHERE E1.IDEdificio= _Edificio
								  AND C1.Tipo='Terremoto'
						   );
SET RischioArea = (
					SELECT RR.Valore
                    FROM Edificio E 
						 NATURAL JOIN 
                         areageografica AG
                         NATURAL JOIN 
                         registrorischio RR
					WHERE E.IDEdificio= _Edificio
						  AND RR.DataFine IS NULL
					);
SET LivelloSismaPrecedente = (
							SELECT C1.Livello
                            FROM edificio E1 
								 NATURAL JOIN
                                 areageografica AG1
                                 INNER JOIN calamità C1 ON AG1.idArea=C1.idArea
							WHERE E1.IDEdificio= _Edificio
								  AND C1.Tipo='Terremoto'
                                  AND C1.Timestamp=DataSismaPrecedente
						   );


WITH DatiPrimaAnalytics AS
(
SELECT CDI.IdVano,LivelloSensore(CDI.Intervento) AS LivelloSensore,LivelloRischio(CDI.FasciaRischioVano) AS LivelloRischio
FROM consiglidiintervento CDI
)
, CalcoloPerVano AS
(
SELECT SUM(DPA.LivelloSensore*DPA.LivelloRischio)/SUM(DPA.LivelloSensore) AS StatoPerVano
FROM DatiPrimaAnalytics DPA
GROUP BY DPA.IdVano
)
, StatoSaluteEdificio AS
(
SELECT SUM(CPV.StatoPerVano)/NumeroVani AS StatoSaluteAttuale
FROM CalcoloPerVano CPV
)
,AlertCompleti AS
(
	SELECT *
	FROM alert A1
		UNION
	SELECT *
	FROM alertmultivalore AM1
)
,
QueryLivelloSisma AS
(
SELECT 1 AS LivelloSisma UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 
)
, AlertSismaPrecedente AS
(
SELECT AC1.TimeStamp
FROM AlertCompleti AC1
     NATURAL JOIN
     sensore S1
     NATURAL JOIN
     vano V1
WHERE V1.IDEdificio=_Edificio
)
,AlertGiorniPrecedenti AS
(
SELECT COUNT(*) AS AlertPrecedenti
FROM AlertSismaPrecedente ASP1
WHERE ASP1.Timestamp BETWEEN DataSismaPrecedente-INTERVAL 15 DAY AND DataSismaPrecedente
)
,AlertGiorniSuccessivi AS
(
SELECT COUNT(*) AS AlertSuccessivi
FROM AlertSismaPrecedente ASP1
WHERE ASP1.Timestamp BETWEEN  DataSismaPrecedente AND DataSismaPrecedente+INTERVAL 15 DAY 
)
, AumentoPercentualeAlert AS
(
SELECT (AGS1.AlertSuccessivi-AGP1.AlertPrecedenti)*100/AGP1.AlertPrecedenti AS AumentoPercentuale
FROM AlertGiorniPrecedenti AGP1
	 CROSS JOIN 
     AlertGiorniSuccessivi AGS1
)
, 
MediaLivelloTerremotiPrecedenti AS
(
SELECT ROUND(SUM(C1.Livello)/COUNT(*)) AS LivelloMedio , ROUND(DATEDIFF(MAX(C1.Timestamp),MIN(C1.Timestamp))/COUNT(*)) AS GiorniPerTerremoto
FROM edificio E1 
NATURAL JOIN
areageografica AG1
INNER JOIN calamità C1 ON AG1.idArea=C1.idArea
WHERE E1.IDEdificio= _Edificio
AND C1.Tipo='Terremoto'
)
,
ProbabilitaTerremoto AS
(
SELECT MLTP.LivelloMedio, (365/MLTP.GiorniPerTerremoto)*RischioArea AS ProbabilitàLivelloMedio
FROM MediaLivelloTerremotiPrecedenti MLTP
)
, ProbabilitaMaggiori AS 
(
SELECT QLS.*, ROUND(PT.ProbabilitàLivelloMedio*POWER((RischioArea/100),QLS.LivelloSisma-PT.LivelloMedio),9)  AS ProbabilitàSisma
FROM QueryLivelloSisma QLS
	 CROSS JOIN
     ProbabilitaTerremoto PT
WHERE QLS.LivelloSisma>=PT.LivelloMedio
)
, ProbabilitaMinori AS
(
SELECT QLS.*, ROUND(PT.ProbabilitàLivelloMedio*LN(RischioArea*(PT.LivelloMedio-QLS.LivelloSisma)),3)  AS ProbabilitàSisma
FROM QueryLivelloSisma QLS
	 CROSS JOIN
     ProbabilitaTerremoto PT
WHERE QLS.LivelloSisma<PT.LivelloMedio
)
, StimaDeiDanni AS
(
SELECT SSE.StatoSaluteAttuale, QLS.LivelloSisma, (QLS.LivelloSisma*5 + SSE.StatoSaluteAttuale*3 + (APA.AumentoPercentuale/10)*1 + LivelloSismaPrecedente*1)/10 AS StimaDanni
FROM StatoSaluteEdificio SSE
	 CROSS JOIN QueryLivelloSisma QLS
     CROSS JOIN AumentoPercentualeAlert APA
     
)


SELECT FasciaSalute(ROUND(SSD.StatoSaluteAttuale,2)) AS StatoSaluteAttuale,SSD.LivelloSisma ,D.ProbabilitàSisma, FasciaDanni(ROUND(SSD.StimaDanni,2)) AS DanniStimati, FasciaSalute(ROUND(((SSD.StatoSaluteAttuale*SSD.StimaDanni)/100)*SSD.LivelloSisma + SSD.StatoSaluteAttuale,2)) AS StatoSalutePostSisma
FROM 	StimaDeiDanni SSD
		NATURAL JOIN
		(
		SELECT *
		FROM ProbabilitaMinori
		UNION
		SELECT *
		FROM ProbabilitaMaggiori
		) AS D;





END $$

DELIMITER ;

CALL Analytics2(1);



 