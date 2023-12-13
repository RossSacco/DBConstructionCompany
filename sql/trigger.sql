
DROP TRIGGER IF EXISTS Val_PuntoCardinale; 
DROP TRIGGER IF EXISTS MaxOperaiCC; 
DROP TRIGGER IF EXISTS Date_Progetto;
DROP TRIGGER IF EXISTS Date_Stadio;
DROP TRIGGER IF EXISTS Date_Lavoro;
DROP TRIGGER IF EXISTS TurniSov_Operaio; 
DROP TRIGGER IF EXISTS Val_Collegamento;
DROP TRIGGER IF EXISTS Stesso_Piano; 
DROP TRIGGER IF EXISTS Altezza_finestra; 
DROP TRIGGER IF EXISTS Eta_Operaio; 
DROP TRIGGER IF EXISTS Lunghezza_turno;
DROP TRIGGER IF EXISTS Pos_Sensori;
DROP TRIGGER IF EXISTS QuantitaUtilizzoMateriale;
DROP TRIGGER IF EXISTS DataUtilizzoMateriale; 
DROP TRIGGER IF EXISTS CostoMaterialeLavoro;


-- trigger per l'aggiornamento delle ridondanze -- 

DROP TRIGGER IF EXISTS CostoEffettivoProg;
DROP TRIGGER IF EXISTS SuperficiePiano;




-- L'attributo Punto Cardinale di Finestra può assumere solo i valori: N, NE, NW, S, SE, SW, E, W; --

delimiter &&

CREATE TRIGGER Val_PuntoCardinale
BEFORE INSERT ON Finestra
FOR EACH ROW
BEGIN

	if new.PuntoCardinale <> 'N' and new.PuntoCardinale <> 'NE' and
	new.PuntoCardinale <> 'NW' and new.PuntoCardinale <> 'S' and
    new.PuntoCardinale <> 'SE' and new.PuntoCardinale <> 'SW' and
    new.PuntoCardinale <> 'E' and new.Puntocardinale <> 'W'
    then
		signal sqlstate '45000'
        set MESSAGE_TEXT = 'Dominio di Punto Cardinale non compatibile';
	
    end if;

END &&

DELIMITER ;

-- Non si può superare il numero di operai massimi di un capo cantiere durante un turno --


DELIMITER &&

CREATE TRIGGER MaxOperaiCC
BEFORE INSERT ON Turno
FOR EACH ROW
BEGIN

	DECLARE NumeroOperai INTEGER DEFAULT 0;
    DECLARE NumeroMaxOperai INTEGER DEFAULT 0;
    
    SET NumeroOperai = (  select count(*)
						  from Turno t 
                          where t.Data = new.Data
							and T.OraInizio = new.OraInizio
                            and t.IdLavoro = new.IdLavoro
						);
	set NumeroMaxOperai = (
						     select CC.OperaiMassimi
						     from Lavoro L inner join CapoCantiere CC on L.CodFiscaleCapoCantiere = CC.CodFiscale
							 where L.IDLavoro = new.IDLavoro
							);

	if NumeroMaxOperai - NumeroOperai = 0 then
		signal sqlstate '45000'
        set MESSAGE_TEXT = 'Impossibile aggiungere Operai';
    end if;

END &&
DELIMITER ;


-- Le Date di Progetto devono essere coerenti --

DELIMITER &&

CREATE TRIGGER Date_Progetto
BEFORE INSERT ON Progetto
FOR EACH ROW
BEGIN

	IF new.DataPresentazione > new.DataApprovazione or 
	   new.DataPresentazione > new.DataInizio or
       new.DataPresentazione > new.StimaDataFine or
       new.DataApprovazione > new.DataInizio or
       new.DataApprovazione > new.StimaDataFine or
       new.DataInizio > new.StimaDataFine then
       
       signal sqlstate '45000'
       set MESSAGE_TEXT = 'Date non coerenti';
	end if;

END &&
DELIMITER ;


-- Le date di Stadio devono essere coerenti --

DELIMITER &&

CREATE TRIGGER Date_Stadio
BEFORE INSERT ON Stadio
FOR EACH ROW
BEGIN

	if new.DataFineStimata <= new.DataInizio or
	   new.DataFineEffettiva <= new.DataInizio then
       
       signal sqlstate '45000'
       set message_text = 'Date non compatibili';
    
    end if;
END &&
DELIMITER ;

-- Le date di Lavoro devono essere coerenti --

DELIMITER &&

CREATE TRIGGER Date_Lavoro
BEFORE INSERT ON Lavoro
FOR EACH ROW
BEGIN

	if new.DataFine <= new.DataInizio then
       signal sqlstate '45000'
       set message_text = 'Date non compatibili';
    
    end if;
END &&
DELIMITER ;
-- Un lavoratore non può avere turni sovrapposti

DELIMITER &&

CREATE TRIGGER TurniSov_Operaio
BEFORE INSERT ON Turno
FOR EACH ROW
BEGIN
		
        if exists (
					select *
					from Turno T
                    where T.Data = new.Data
						and T.CodFiscaleOperaio = new.CodFiscaleOperaio
                        and (
								(new.OraInizio between T.OraInizio and T.OraFine)
                                or
                                (new.OraFine between T.OraInizio and T.OraFine)
                        )
        
					) then
			signal sqlstate '45000'
			set message_text = 'Orari non compatibili';
		end if;

END &&
DELIMITER ;

-- L'attributo Collegamento in Punto d'accesso può assumere solo i valori 'Interno' o 'Esterno'

DELIMITER &&

CREATE TRIGGER Val_Collegamento
BEFORE INSERT ON PuntoDiAccesso
FOR EACH ROW
BEGIN

	if new.Collegamento <> 'Interno' and new.Collegamento <> 'Esterno'
		then
        signal sqlstate '45000'
        set message_text = 'Valore non coerente';
	end if;
END &&
DELIMITER ;



-- Un punto d'accesso collega due vani dello stesso piano dello stesso edificio --


DELIMITER &&

CREATE TRIGGER Stesso_Piano
BEFORE INSERT ON Collegamento
FOR EACH ROW
BEGIN

	DECLARE NumPianoUno integer default 0;
    declare NumPianoDue integer default 0;
    
    DECLARE Edificio1 INTEGER DEFAULT 0;
    DECLARE Edificio2 INTEGER DEFAULT 0;
    DECLARE NumeroVano2 INTEGER DEFAULT 0;
    
    SELECT V1.NumeroPiano,V1.IDEdificio INTO NumPianoUno, Edificio1
    FROM Vano V1
    WHERE V1.IDVano=NEW.IDVano;
    
    SELECT C.IDVano INTO NumeroVano2
    FROM collegamento C
    WHERE C.idAccesso=NEW.idAccesso;
    
    SELECT V2.NumeroPiano, V2.IDEdificio INTO NumPianoDue, Edificio2
    FROM Vano V2
    WHERE V2.IDVano=NumeroVano2;
    
    IF Edificio2 <> 0 THEN
    BEGIN
    
	if Edificio1 <> Edificio2 then
		signal sqlstate '45000'
        set message_text = 'I Vani risultano in due edifici differenti';
	end if;
    
    	if NumPianoUno <> NumPianoDue then
		signal sqlstate '45000'
        set message_text = 'I Vani risultano in due piani differenti';
	end if;
    
    END ;
    END IF;
                        

END &&
DELIMITER ;

-- L'altezza di una finestra non può essere più grande dell'altezza del vano a cui appartiene --


DELIMITER &&

CREATE TRIGGER Altezza_finestra
BEFORE INSERT ON Finestra
FOR EACH ROW
BEGIN

	DECLARE AltezzaVano integer default 0;
    
    set AltezzaVano = (		select V.Altezza
							from Finestra F inner join Vano V on F.IdVano = V.IdVano
                            where V.IdVano = new.idVano
						);
                        
	if new.Altezza > AltezzaVano then
		signal sqlstate '45000'
        set message_text = 'Impossibile! Finestra troppo grande';
	end if;

END &&
DELIMITER ;

-- Gli operai dovranno avere età maggiore di 18 --

DELIMITER &&

CREATE TRIGGER Eta_Operaio
BEFORE INSERT ON Operaio
FOR EACH ROW
BEGIN
	
   if new.DataNascita > current_date - interval 18 year then
		signal sqlstate '45000'
        set message_text = 'Assumiamo solo maggiorenni';
	end if;

END &&
DELIMITER ;


-- Un turno deve durare almeno un'ora --

DELIMITER &&

CREATE TRIGGER Lunghezza_turno
BEFORE INSERT ON Turno
FOR EACH ROW 
BEGIN

	if hour(new.OraFine) - hour(new.OraInizio) < 1 then
		signal sqlstate '45000'
        set message_text = 'Turno troppo breve';
    
    end if;

END &&
DELIMITER ;



-- Due sensori non possono essere nella stessa posizione all'interno dello stesso vano --

DELIMITER &&

CREATE TRIGGER Pos_Sensori
BEFORE INSERT ON Sensore
FOR EACH ROW 
BEGIN
	
    if exists ( select *
				from sensore S
                where S.IdVano = new.IdVano
					and S.PosizioneX = new.PosizioneX
                    and S.PosizioneY = new.PosizioneY
                    and S.PosizioneZ = new.PosizioneZ
				) then
		signal sqlstate '45000'
        set MESSAGE_TEXT = 'Posizione già occupata da un altro sensore';
	end if;

END &&
DELIMITER ;


-- La quantita Di materiale che utilizziamo di un lotto non può essere superiore alla quantita disponibile

DELIMITER &&

CREATE TRIGGER QuantitaUtilizzoMateriale
BEFORE INSERT ON Utilizzo
FOR EACH ROW 
BEGIN

		DECLARE QuantitaUsata INTEGER DEFAULT 0;
        DECLARE QuantitaDisponibile INTEGER DEFAULT 0;
        SET QuantitaUsata=(
							SELECT SUM(QuantitaUtilizzata)
							FROM Utilizzo
							WHERE CodiceLotto=new.CodiceLotto
							);
		SET QuantitaUsata=QuantitaUsata+new.QuantitaUtilizzata;
        SET QuantitaDisponibile=(
									SELECT QuantitàAcquistata
                                    FROM materiale M
                                    WHERE M.CodiceLotto=new.CodiceLotto
								);
		IF QuantitaUsata>QuantitaDisponibile THEN
		signal sqlstate '45000'
        set message_text = 'Quantità disponibile del materiale superata';
    
    end if;

END &&
DELIMITER ;

-- L'acquisto del materiale deve essere precedente alla data di fine del lavoro

DELIMITER &&

CREATE TRIGGER DataUtilizzoMateriale
BEFORE INSERT ON Utilizzo
FOR EACH ROW 
BEGIN
DECLARE DataFineLavoro DATE DEFAULT NULL;
DECLARE DataAcquistoMateriale DATE DEFAULT NULL;

SET DataFineLavoro=(
						SELECT L.DataFine
                        FROM Lavoro L
                        WHERE L.IDLavoro=NEW.IDLavoro
                     );
                     
SET DataAcquistoMateriale=(
							SELECT M.DataAcquisto
                            FROM materiale M
                            WHERE M.CodiceLotto=NEW.CodiceLotto
                          );

IF DataFineLavoro<DataAcquistoMateriale THEN
	
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Il materiale è stato acquistato dopo la data di fine del lavoro';

END IF;
		
END &&
DELIMITER ;

-- Il costo dei materiali per un lavoro non può essere maggiore o uguale del costo del lavoro stesso

DELIMITER &&

CREATE TRIGGER CostoMaterialeLavoro
BEFORE INSERT ON Utilizzo
FOR EACH ROW 
BEGIN

DECLARE CostoLavoro INTEGER DEFAULT 0;
DECLARE CostoMateriali INTEGER DEFAULT 0;
DECLARE CostoTotaleMateriali INTEGER DEFAULT 0;

SET CostoLavoro=(
					SELECT L.Costo
                    FROM lavoro L 
                    WHERE L.IDLavoro=NEW.IDLavoro
				);

SET CostoMateriali=(
					SELECT round(SUM((M.CostoTotale/M.QuantitàAcquistata)*U.QuantitaUtilizzata) ,2)
                    FROM utilizzo U inner join materiale M ON U.CodiceLotto=M.CodiceLotto
                    WHERE U.IDLavoro=NEW.IDLavoro                 
				   );
                   
SET CostoMateriali=CostoMateriali+(
									SELECT round((m2.CostoTotale/m2.QuantitàAcquistata)*NEW.QuantitaUtilizzata ,2)
									FROM materiale m2
									WHERE m2.CodiceLotto=NEW.CodiceLotto
								   );



IF CostoMateriali>=CostoLavoro THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Costo del lavoro e dei materiali utilizzati non coerente';
    END IF;

END &&
DELIMITER ;

-- trigger aggiornamento ridondanze --

-- aggiornamento ridondanza 'superficie' situata in piano --

DELIMITER $$

CREATE TRIGGER SuperficiePiano
AFTER INSERT ON Vano
FOR EACH ROW
BEGIN

	declare SupNuovoVano int default 0;
    
    set SupNuovoVano = new.Lunghezza * new.Larghezza;
	
    UPDATE Piano 
    set Superficie = Superficie + SupNuovoVano
    where IDEdificio = new.IDEdificio
		  and NumeroPiano = new.NumeroPiano;

END $$

DELIMITER ;

-- aggiornamento ridondanza 'CostoEffettivo' situata in Stadio --

DELIMITER $$

CREATE TRIGGER CostoEffettivoProg
AFTER INSERT ON Lavoro
FOR EACH ROW
BEGIN

	UPDATE Stadio
    SET CostoEffettivo = IF(new.DataFine IS NULL,NULL,CostoEffettivo + new.costo)
    where IDStadio = new.IDStadio;


END $$

DELIMITER ;























