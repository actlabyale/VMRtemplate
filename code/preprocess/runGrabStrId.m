function result = extractStrId(longStr, searchStr, nAfterSS)
    % Extracts a substring starting from searchStr and extending nAfterSS characters beyond it.
    % e.g. longStr = 's01retro_HKH_msl001234'
    %      searchStr = 'msl00'
    %      nAfterSS = 4
    % This would return 'msl001234'

    index = strfind(longStr, searchStr);
    
    if ~isempty(index)
        startIdx = index(1);
        endIdx = startIdx + length(searchStr) + nAfterSS - 1;  % Adjusting for MATLAB indexing
        result = longStr(startIdx:endIdx);
    else
        result = ''; % Return an empty string if not found
    end
end
% 
% a = 's01retro_HKH_msl001234xxx';
% b = grabStrId(a, 'msl00', 4);
% % disp(b);  % This will display 'msl001234'