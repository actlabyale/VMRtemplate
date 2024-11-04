% function found = findField(structure, fieldNamePart)
%     found = []; % Initialize an empty array to store found locations
% 
%     % Check if the input is a structure
%     if isstruct(structure)
%         % Get the fields of the structure
%         fields = fieldnames(structure);
% 
%         % Loop through each field
%         for i = 1:length(fields)
%             currentField = fields{i};
%             % Check if the current field contains the target part
%             if contains(currentField, fieldNamePart)
%                 found = [found; {currentField, structure.(currentField)}]; % Store the field name and value
%             else
%                 % If it's not a match, check if the field is a structure or cell
%                 if isstruct(structure.(currentField)) || iscell(structure.(currentField))
%                     % Recursively search in the nested structure or cell
%                     nestedResults = findField(structure.(currentField), fieldNamePart);
%                     if ~isempty(nestedResults)
%                         found = [found; nestedResults]; % Append results
%                     end
%                 end
%             end
%         end
%     end
% end


function found = findField(structure, fieldNamePart, currentPath)
    if nargin < 3
        currentPath = {}; % Initialize current path if not provided
    end
    found = {}; % Initialize an empty cell array to store found paths

    % Check if the input is a structure
    if isstruct(structure)
        % Get the fields of the structure
        fields = fieldnames(structure);
        
        % Loop through each field
        for i = 1:length(fields)
            currentField = fields{i};
            % Update the path for the current field
            newPath = [currentPath, {currentField}];
            % Check if the current field contains the target part
            if contains(currentField, fieldNamePart)
                found = [found; {newPath, structure.(currentField)}]; % Store the path and value
            else
                % If it's not a match, check if the field is a structure or cell
                if isstruct(structure.(currentField)) || iscell(structure.(currentField))
                    % Recursively search in the nested structure or cell
                    nestedResults = findField(structure.(currentField), fieldNamePart, newPath);
                    if ~isempty(nestedResults)
                        found = [found; nestedResults]; % Append results
                    end
                end
            end
        end
    end
end

