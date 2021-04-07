function [] = insertDataFile(df, dataQuality, experimentNotes)

    df.paper_key = -1;
    df.data_stretch_key = -1;

    df.emg_data_quality = "NULL"; %populate with data quality
    df.neural_data_quality = "NULL"; %populate with data quality
    df.behavior_notes = "NULL"; %populate with data quality
    df.other_notes = "NULL"; %populate with data quality
    df.sub_task = "NULL"; 
    df.cds_server_location = "NULL"; 
    %insert!
    insert(limblab_db.DataFile, df)
    disp([df.nev_file_name ' was added to the database'])

