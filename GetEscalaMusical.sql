CREATE PROCEDURE GetEscalaMusical (
    IN in_Tom NVARCHAR(5),
    IN in_Escala NVARCHAR(50)
)
AS
BEGIN

    DECLARE baseID INT;
    DECLARE intervalos TABLE ("Ordem" INT, "Semitom" INT);
    DECLARE notas_escala NCLOB;

    -- Define os intervalos de acordo com a escala/modo
    IF :in_Escala = 'Maior' OR :in_Escala = 'Jônio' THEN
        notas_escala = '0,2,4,5,7,9,11';
    ELSEIF :in_Escala = 'Menor' OR :in_Escala = 'Eólio' THEN
        notas_escala = '0,2,3,5,7,8,10';
    ELSEIF :in_Escala = 'Pentatonica' THEN
        notas_escala = '0,2,4,7,9';
    ELSEIF :in_Escala = 'Menor Harmonica' THEN
        notas_escala = '0,2,3,5,7,8,11';
    ELSEIF :in_Escala = 'Menor Melodica' THEN
        notas_escala = '0,2,3,5,7,9,11';
    ELSEIF :in_Escala = 'Dórico' THEN
        notas_escala = '0,2,3,5,7,9,10';
    ELSEIF :in_Escala = 'Frígio' THEN
        notas_escala = '0,1,3,5,7,8,10';
    ELSEIF :in_Escala = 'Lídio' THEN
        notas_escala = '0,2,4,6,7,9,11';
    ELSEIF :in_Escala = 'Mixolídio' THEN
        notas_escala = '0,2,4,5,7,9,10';
    ELSEIF :in_Escala = 'Lócrio' THEN
        notas_escala = '0,1,3,5,6,8,10';
    END IF;

    -- Preenche a tabela de intervalos com a ordem
    INSERT INTO :intervalos
    SELECT ROW_NUMBER() OVER () - 1 AS Ordem, TO_INT("values") AS Semitom
    FROM STRING_SPLIT(:notas_escala, ',');

    -- Pega o ID da nota base
    SELECT "ID" INTO baseID FROM "Notas" WHERE "Nota" = :in_Tom;

    -- Exibe a escala com os graus
    SELECT
        ROW_NUMBER() OVER(ORDER BY i."Ordem") as "ID",
        n2."Nota",
        CASE i."Ordem"
            WHEN 0 THEN 'Tônica'
            WHEN 1 THEN 'Segundo Grau'
            WHEN 2 THEN 'Terceiro Grau'
            WHEN 3 THEN 'Quarto Grau'
            WHEN 4 THEN 'Quinto Grau'
            WHEN 5 THEN 'Sexto Grau'
            WHEN 6 THEN 'Sétimo Grau'
            ELSE 'Grau Adicional'
        END AS Grau
    FROM :intervalos i
    JOIN "Notas" n2 
        ON n2."ID" = MOD(:baseID - 1 + i."Semitom", 12) + 1
    ORDER BY i."Ordem";

END;
