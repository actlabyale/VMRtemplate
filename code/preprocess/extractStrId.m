function result = extractStrId(longStr, searchStr, nAfterSS)
    % EXTRACTSTRID Extracts a substring starting from searchStr
    % and extending nAfterSS characters beyond it.
    %
    % Inputs:
    %   longStr   - The original string from which to extract.
    %   searchStr - The substring to search for within longStr.
    %   nAfterSS  - Number of characters to include after searchStr.
    %
    % Output:
    %   result    - The extracted substring or an empty string if searchStr is not found.
    %
    % Example:
    %   result = extractStrId('s01retro_HKH_msl001234', 'msl00', 4);
    %   % result will be 'msl001234'

    % Find the starting index of searchStr in longStr
    index = strfind(longStr, searchStr);
    
    % Check if searchStr was found
    if ~isempty(index)
        startIdx = index(1);  % First occurrence
        endIdx = startIdx + length(searchStr) + nAfterSS - 1;  % Calculate the end index
        result = longStr(startIdx:endIdx);  % Extract the substring
    else
        result = '';  % Return an empty string if searchStr is not found
    end
end