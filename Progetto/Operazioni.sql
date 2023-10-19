DROP PROCEDURE IF EXISTS CostoTotaleDiUnProgetto; 
DROP PROCEDURE IF EXISTS LavoriDirettiDaUnCapoCantiere; 
DROP PROCEDURE IF EXISTS SuperficieEdificio; 
DROP PROCEDURE IF EXISTS InserimentoTurni; 
DROP PROCEDURE IF EXISTS CalendarioOperaio; 
DROP PROCEDURE IF EXISTS EdificioARischio; 
DROP PROCEDURE IF EXISTS SensoriAlert; 
DROP PROCEDURE IF EXISTS CostoMaterialiLavoro; 


-- Inserimento turni di un operaio --

DELIMITER $$

CREATE PROCEDURE InserimentoTurni ( IN _CodFiscaleOp varchar(16) , IN _Data date, in _OraInizio time, in _OraFine time, in _Lavoro int)
BEGIN

	#abbiamo un trigger che controlla non ci siano turni sovrapposti
   
    
	#controlliamo che non vengano superati gli operai massimi di un capocantiere
    
	DECLARE MaxOperai int default 0;
    DECLARE OperaiAttuali int default 0;
    
    set MaxOperai = (	select CC.OperaiMassimi
						from Lavoro L inner join CapoCantiere CC on L.CodFiscaleCapoCantiere = CC.CodFiscale
                        where L.IDLavoro = _Lavoro
					);

	set OperaiAttuali = (	select count(distinct T.CodFiscaleOperaio)
							from Turno T
                            where T.IDLavoro = _Lavoro and T.CodFiscaleOperaio <> _CodFiscaleOp
						);
                        
	if OperaiAttuali = MaxOperai then
		signal sqlstate '45000'
        set message_text = 'Impossibile inserire operaio';
	end if;
	 
    #controlliamo l'operaio esista
    
    if _CodFiscaleOp not in (	select O.CodFiscale
								from Operaio O
							) then
								signal sqlstate '45000'
                                set message_text = 'Operaio non valido';
    end if;
    
    #gli orari devono essere coerenti
    
    if _OraInizio > _OraFine then
		signal sqlstate '45000'
        set message_text = 'Ricontrollare i parametri';
    end if;    
	
    insert into Turno values (_Data, _OraInizio, _OraFine, _Lavoro, _CodFiscaleOp);

END $$

DELIMITER ;


-- Costo totale di un progetto, finito o in corso -- 

DELIMITER $$

CREATE PROCEDURE  CostoTotaleDiUnProgetto (IN _Progetto int)
BEGIN

	if _Progetto not in (
						  select IDProgetto
						  from Progetto
						)	then signal 
									sqlstate '45000'
                                    set message_text = 'Progetto inesistente';
	end if;

	SELECT sum(S.CostoEffettivo) AS CostoDelProgetto
    FROM Stadio S
    WHERE S.IDProgetto = _Progetto
		and S.CostoEffettivo is not null;

END $$

DELIMITER ;  



-- Lavori diretti da un capocantiere --

DELIMITER $$

CREATE PROCEDURE LavoriDirettiDaUnCapoCantiere (IN _CapoCantiere varchar(16), IN _anno int)
BEGIN

	if _CapoCantiere not in (	select CodFiscale
								from CapoCantiere
							 ) then signal 
									sqlstate '45000'
                                    set message_text = 'CapoCantiere non presente';
	end if;
    
	
	SELECT L.IDLavoro
	FROM Lavoro L
    where L.CodFiscaleCapoCantiere = _CapoCantiere
		and _anno between year(L.DataInizio) and  year(L.DataFine);
		
END $$

DELIMITER ;




-- Calcolo della superficie di un edificio, più semplice con la ridondanza-- 

DELIMITER $$

CREATE PROCEDURE SuperficieEdificio(IN _Edificio int)
BEGIN

	if _Edificio not in (
						  select IDEdificio
						  from Edificio
						)	then signal 
									sqlstate '45000'
                                    set message_text = 'Edificio inesistente';
	end if;

	SELECT SUM(P.Superficie) AS SuperficieEdificio
	FROM Piano P 
    WHERE P.IDEdificio = _Edificio ;

END $$

DELIMITER ;


-- Calendario dei turni di un lavoratore per i sette giorni successivi --


DROP FUNCTION IF EXISTS GiornoSettimana;
DELIMITER $$
CREATE FUNCTION GiornoSettimana( _NumeroGiorno INTEGER)
RETURNS VARCHAR(45) DETERMINISTIC
BEGIN

DECLARE NomeGiorno VARCHAR(45);

    CASE
        WHEN _NumeroGiorno = 2 THEN
            SET NomeGiorno = 'Lunedì';
        WHEN _NumeroGiorno = 3 THEN
            SET NomeGiorno = 'Martedì';
        WHEN _NumeroGiorno = 4 THEN
            SET NomeGiorno = 'Mercoledì';
        WHEN _NumeroGiorno = 5 THEN
            SET NomeGiorno = 'Giovedì' ;
        WHEN _NumeroGiorno = 6 THEN
            SET NomeGiorno = 'Venerdì';

    END CASE;
    RETURN NomeGiorno;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS CalendrioOperaio;
DELIMITER $$
CREATE PROCEDURE CalendrioOperaio(IN _Operaio VARCHAR(16))
BEGIN

IF _Operaio NOT IN (
						SELECT O.CodFiscale
                        FROM operaio O
					)
						THEN
						BEGIN
							SIGNAL SQLSTATE '45000'
							SET MESSAGE_TEXT = 'Operaio non esistente';
						END ;
END IF;


SELECT T.Data ,GiornoSettimana(dayofweek(T.Data)) AS GiornoDellaSettimana, T.OraInizio,T.OraFine, T.IdLavoro
FROM turno T
WHERE T.CodFiscaleOperaio=_Operaio AND
	  T.Data> CURRENT_DATE AND
      T.Data< CURRENT_DATE + INTERVAL 8 DAY;

END $$
DELIMITER ;





-- Trovare l'area geografica più a rischio in quel momento --

DELIMITER $$
CREATE PROCEDURE EdificioARischio (IN _Data date)
BEGIN

    select RR.idArea,RR.Valore
	from RegistroRischio RR
    where RR.datainizio < _data
        and RR.Valore = (	select max(RR2.Valore)
							from RegistroRischio RR2
                            where
								RR2.DataInizio < _Data
						);
    
END $$

DELIMITER ;



-- Determinare qual è il sensore che ha generato più alert --

DELIMITER &&
CREATE PROCEDURE SensoriAlert()
BEGIN

WITH AlertCompleti AS
(
	SELECT *
	FROM alert A1
		UNION
			SELECT *
			FROM alertmultivalore AM1
), MaxAlert AS
(

	SELECT COUNT(*) AS NumAlert
	FROM AlertCompleti Ac
	GROUP BY Ac.idSensore

)

	SELECT AC1.idSensore, COUNT(*) AS NumeroAlert
	FROM AlertCompleti AC1
	GROUP BY AC1.idSensore
	HAVING COUNT(*) = (
						SELECT MAX(MA.NumAlert)
						FROM MaxAlert MA
						);

END &&

DELIMITER ;


-- Determinare il costo dei materiali per un determinato lavoro --

DELIMITER $$
CREATE PROCEDURE CostoMaterialiLavoro(in _lavoro int)
BEGIN

	if _lavoro not in (
						  select IDLavoro
						  from Lavoro
						)	then signal 
									sqlstate '45000'
                                    set message_text = 'Progetto inesistente';
	end if;
	
    select sum(M.CostoTotale) AS CostoDeiMateriali
    from utilizzo U inner join Materiale M on U.CodiceLotto = M.CodiceLotto
    where U.IDLavoro = _lavoro;

END $$

DELIMITER ;

-- PROVA DELLE OPERAZIONI
/*
 call  CostoTotaleDiUnProgetto(844);
 call LavoriDirettiDaUnCapoCantiere('SCPNTN82L12A662K', 2020);
 call SuperficieEdificio(1);
 CALL CalendrioOperaio('BLLNNZ75M27D548P');
 call EdificioARischio(current_date);
 call SensoriAlert();
 call CostoMaterialiLavoro(1128);

*/






