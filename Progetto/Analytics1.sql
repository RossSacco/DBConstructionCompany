
-- ANALYTICS 1 --

-- stored function che associa ad ogni tipologia di sensore un livello d'importanza -- 

drop function if exists LivelloSensore;
delimiter $$
CREATE FUNCTION LivelloSensore(_TipoSensore varchar(45))
RETURNS double DETERMINISTIC
BEGIN
    DECLARE livello double DEFAULT 0;
    
    CASE
        WHEN _TipoSensore = 'Temperatura Interna' THEN
            SET livello = 5;
        WHEN _TipoSensore = 'Temperatura Esterna' THEN
            SET livello = 3;
        WHEN _TipoSensore = 'Umidità Interna' THEN
            SET livello = 7;
        WHEN _TipoSensore = 'Umidità Esterna' THEN
            SET livello = 3;
        WHEN _TipoSensore = 'Livello Precipitazioni' THEN
            SET livello = 2;
        WHEN _TipoSensore = 'Posizione' THEN
            SET livello = 9;
        WHEN _TipoSensore = 'Giroscopio' OR _TipoSensore = 'Accelerometro' THEN
            SET livello = 10;
    END CASE;
    
    RETURN livello;
END $$
delimiter ;


--  funzione che associa ad ogni sensore un rischio 

drop function if exists RischioTipologia;
delimiter $$
CREATE FUNCTION RischioTipologia(_TipoSensore varchar(45))
RETURNS varchar(255) DETERMINISTIC
BEGIN
    DECLARE TipoRischio varchar(255) DEFAULT '';
    
    CASE
        WHEN _TipoSensore = 'Temperatura Interna' THEN
            SET TipoRischio = 'Isolamento Termico Interno';
        WHEN _TipoSensore = 'Temperatura Esterna' THEN
            SET TipoRischio = 'Isolamento Termico Esterno';
        WHEN _TipoSensore = 'Umidità Interna' THEN
            SET TipoRischio = 'Rischio Muffa';
        WHEN _TipoSensore = 'Umidità Esterna' THEN
            SET TipoRischio = 'Rischio Indebolimento Struttura';
        WHEN _TipoSensore = 'Livello Precipitazioni' THEN
            SET TipoRischio = 'Rischio Allagamenti';
        WHEN _TipoSensore = 'Posizione' THEN
            SET TipoRischio = 'Rischio crollo';
        WHEN _TipoSensore = 'Giroscopio' OR _TipoSensore = 'Accelerometro' THEN
            SET TipoRischio ='Rischio strutturale di carattere sismico';
    END CASE;
    
    RETURN TipoRischio;
    
END $$
delimiter ;

-- funzione che associa al rischio di ogni vano una fascia --

drop function if exists FasciaRischioVano;
delimiter $$
CREATE FUNCTION FasciaRischioVano(_rischio float)
RETURNS varchar(255) DETERMINISTIC
BEGIN
    DECLARE fascia varchar(255) DEFAULT '';
    
    CASE
        when _rischio < 15000 then
			set fascia = 'Molto Basso';
		when _rischio between 15000 and 49999 then
			set fascia = 'Basso';
		when _rischio between 50000 and 99999 then
			set fascia = 'Quasi Basso';
		when _rischio between 100000 and 299999 then
			set fascia = 'Medio Basso';
		when _rischio between 300000 and 499999 then
			set fascia = 'Medio';
		when _rischio between 500000 and 999999 then
			set fascia = 'Medio Alto';
		when _rischio between  1000000 and 1499999 then
			set fascia = 'Elevato';
		when _rischio > 1500000 then
			set fascia = 'Estremo';
			
    END CASE;
    
    RETURN fascia;
    
END $$
delimiter ;

-- funzione che associa ad ogni lavoro una fascia di urgenza --

drop function if exists FasciaUrgenzaLavoro;
delimiter $$
CREATE FUNCTION FasciaUrgenzaLavoro(_rischio float)
RETURNS varchar(255) DETERMINISTIC
BEGIN
    DECLARE fascia varchar(255) DEFAULT '';
    
    CASE
        when _rischio < 10000 then
			set fascia = 'Molto Basso';
		when _rischio between 10000 and 24999 then
			set fascia = 'Basso';
		when _rischio between 25000 and 74999 then
			set fascia = 'Quasi Basso';
		when _rischio between 75000 and 299999 then
			set fascia = 'Medio';
		when _rischio between 300000 and 499999 then
			set fascia = 'Medio Alto';
		when _rischio between  500000 and 1000000 then
			set fascia = 'Elevato';
		when _rischio > 1000000 then
			set fascia = 'Estremo';
			
    END CASE;
    
    RETURN fascia;
    
END $$
delimiter ;


drop procedure if exists Analytics1;

-- creazione della tabella che conterrà i risultati --

drop table if exists ConsigliDiIntervento;
create table ConsigliDiIntervento(
	IdVano int,
    FasciaUrgenzaLavoro varchar(255),
    Intervento varchar(45),
    FasciaRischioVano varchar(255),
    RischioCorrenteTipologia varchar(255),
    UrgenzaLavoro int,
    UrgenzaVano int
)engine=innodb;

delimiter &&

create procedure Analytics1(in _Edificio int)
begin 

	if not exists (	select *
					from edificio e
                    where e.idedificio = _edificio
				  ) then 
						signal sqlstate '45000'
                        set message_text = 'Edificio Inesistente!';
	end if;

	truncate table ConsigliDiIntervento;
    insert into ConsigliDiIntervento
        with LivelloSensori as
    (
		select s.*, r.valore as RischioArea ,LivelloSensore(s.TipoSensore) as Livello -- uso la funzione per associare il proprio livello d'importanza ad ogni sensore a seconda della tipologia 
		from sensore s inner join vano v on v.idvano = s.idvano
					   inner join edificio e on e.idedificio = v.idedificio
                       inner join RegistroRischio r on e.idarea = r.idarea
		where e.idEdificio = _Edificio
			and r.valore = (	select rr.valore
								from registroRischio rr
                                where rr.idarea = r.idarea
									and rr.datainizio = (	select max(rr2.DataInizio)
															from registroRischio rr2
                                                            where rr2.idarea = rr.idarea
														)
							)
        
	), AlertCompleti as   -- qui ho tutti gli alert con il valore che l'ha causato (SogliaStimata), con i dati necessari dei sensori
    (
		select a.*, S.TipoSensore, S.Livello, S.sogliaDiSicurezza, S.idVano, S.RischioArea
		from	(SELECT  r.idsensore, r.timestamp, r.sogliastimata
				 FROM alert A1 natural join registro r
					UNION
				 SELECT *
				 FROM alertmultivalore AM1 natural join (	select rm.idsensore, rm.timestamp, rm.sogliastimata
															from registromultivalore rm
														 ) as d) as a natural join LivelloSensori S
    ), gravita as   -- calcolo del delta di gravità, si fa per tipo di sensore per ogni vano 
    (
		select a.idvano, a.tiposensore, (	select sum(a2.SogliaStimata)
										from alertCompleti a2
                                        where a2.idvano = a.idvano
                                         and a2.TipoSensore = a.TipoSensore
									  ) - (
											 select sum(a3.SogliaDiSicurezza)
											 from alertCompleti a3
											 where a3.idvano = a.idvano
                                               and a3.TipoSensore = a.TipoSensore
										  ) as gravita
		from AlertCompleti a
        group by a.idvano, a.TipoSensore
    ), CoefficienteRischio as -- calcolo coefficiente di rischio per tipologia di sensore in ogni vano
    (
		select a.idVano, a.TipoSensore, (a.Livello * count(*) * a.RischioArea * g.Gravita) as coeffDiRischioTipo
		from AlertCompleti a natural join gravita g
        group by a.idvano, a.TipoSensore, a.RischioArea
    ), rischioVano as
    (
		select c.idvano, sum(c.coeffDiRischioTipo) as rischioVano
		from coefficienteRischio c
        group by c.idVano
    )
    
		select c.idVano, FasciaUrgenzaLavoro(c.CoeffDiRischioTipo), c.TipoSensore, FasciaRischioVano(r.RischioVano), RischioTipologia(c.TipoSensore) , dense_rank() over( partition by c.idvano
																																											order by c.coeffDiRischioTipo desc
																																											)as UrgenzaLavoro,
																																											dense_rank() over(
																																											order by r.RischioVano desc
																																											)as UrgenzaVano
        from CoefficienteRischio c natural join RischioVano r;

end &&
delimiter ;

call analytics1(1);

select *
from ConsigliDiIntervento;



