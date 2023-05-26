CREATE OR REPLACE PROCEDURE transfer_data(chunkSize INT DEFAULT 10 ) 
--    Postgresql data migration between two table in same database
--    
--    author: Mert Yavasca
--    create_date: 24.05.2023
--    last_modify_date: 24.05.2023 / kesilirse kaldıgı yerden devam etmesi icin kontrol eklendi.
--    
LANGUAGE plpgsql
AS $$
DECLARE
    totalRows INT;
    iterationCount INT;
    destMaxId INT;    
    counter INT := 0;

BEGIN
                
    SELECT max(id) INTO destMaxId FROM destination_table;  --kesilirse nerden devam edecegini anlaması icin hedef tabloya bakiyor.
    
    if destMaxId is null then
        destMaxId := 0;
    end if;
    

    SELECT COUNT(*) INTO totalRows FROM b;

    iterationCount := CEIL((totalRows-destMaxId)::NUMERIC / chunkSize);  -- iterasyon sayisini bulmak icin 
                               
    FOR i IN 0..iterationCount-1 LOOP
        begin
                        INSERT INTO destination_table (id) 
                        SELECT id 
                        FROM source_table
                        ORDER BY id 
                        OFFSET ((i * chunkSize) + destMaxId) 
                        LIMIT chunkSize;
                        counter := counter + 1;
                        commit;                                              
        end;                                                              
    END LOOP;         

    raise notice '% kez iterasyon yapildi, % satir tasindi',counter,chunkSize*counter;

END;
$$;
