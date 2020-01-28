function record_data

    f = figure('Visible', 'off', 'Position', [360, 500, 450, 285]);
    
    hsurf = uicontrol('Style', 'pushbutton',...
                    'String', 'Surf', 'Position', [315, 220, 70, 25]);
                
    htext = uicontrol('Style', 'text', 'String', 'Select Data',...
                     'Position', [325, 90, 60, 15]);
    
    align([hsurf, htext], 'Center', 'None');
    
    f.Visible = 'on';
    

end