directory = dir('/Users/hannahillman/Desktop/research/sophia_ext/robot_data/');

row = 1;

% columns for dataframe
vid = [];
vprotocol = [];
vpt_rot = [];
vtrial = [];
vtrial_type = [];
vrot = [];
vonline_fb = [];
vendpt_fb = [];
vpathx = []; 
vpathy = [];
vpath_angle = [];
vvs_fbx = [];
vvs_fby = [];        
vevent = [];
vvel = [];





baseline = false;
learning = false;
catch_trial = 0;
washout = false;



big_struct = struct();
c = 1;
for f = 4:length(directory)

    dat = exam_load('dir', sprintf('/Users/hannahillman/Desktop/research/sophia_ext/robot_data/%s', directory(f).name ));
    subdir = sprintf('/Users/hannahillman/Desktop/research/sophia_ext/robot_data/%s', directory(f).name );
    pat = fileread(subdir + "/pat.dat");

    notEmpty = ~cellfun(@isempty, {dat.c3d}); % skips empty files (kinarm bug) 
    dat = dat(notEmpty);

    % % madlab id get
    getid = splitlines(pat);
    idcell = getid(1);
    idchar = char(idcell);
    id_foo = idchar(7:end); % 7 because of the num charachers in id=msl...
    id = str2num(id_foo);
%    %%disp(id);

    dat = KINARM_add_friction(dat); %friction inherent to motors of the robot
    dat = KINARM_add_hand_kinematics(dat); %use motors to calculate applied forces
    dat = filter_double_pass(dat, 'enhanced', 'fc', 10); %filtering is cracked
    
    for file = 1:length(dat)
        %disp(file)

        cc = dat(file).c3d;
        filelabel = dat(file).file_label;

        check_adaptation = strfind(filelabel, 'adaptation');
        % disp('check', check_adaptation);

        if length(check_adaptation) == 0 % if practice just ignore
            disp('check');
            disp(filelabel);

        else % if it's an adaptation run the script
            proto_open = strfind(filelabel, '[') + 1;
            proto_close = strfind(filelabel, ']') - 1;
            protocol = filelabel(proto_open:proto_close);

      %%%% Make a easy TP Table for this file 
            tpstruct = cc(1).TP_TABLE; %% get the struct (just using the first entry as table is same for all)
            tpstruct = rmfield(tpstruct, 'USED'); %% remove the fields that are not 100 long
            tpstruct = rmfield(tpstruct, 'COLUMN_ORDER');
            tpstruct = rmfield(tpstruct, 'DESCRIPTIONS'); %% some are 1x100 and other are 100x1 bc kinarm is difficult
            fn = fieldnames(tpstruct);
            numfn = numel(fn);
            for i = 1:numfn %% reshape the struct by looping through entries
                field = fn{i};
                tpstruct.(field) = reshape(tpstruct.(field), 100, 1);
            end
            tptable = struct2table(tpstruct); %%% make a table from the struct 

            trial_count = 0;

     %%%% For each trial: %%%%%%% SWITCH THIS JUST FOR TESTING 
            for t = 1:length(cc) % each trial %% loop through everything just to future proof 
            % for t = 7 % each trial %% loop through everything just to future proof 

                trial_count = trial_count + 1;

          %%%% tptable variables 
                ct = cc(t); %% all the data 
                trial_tp_row = tptable(ct.TRIAL.TP_ROW,:); %% tp table data for that trial 
                instructions = trial_tp_row.instruction_index;
                online_fb = trial_tp_row.show_online_feedback;
                endpt_fb = trial_tp_row.show_endpoint_feedback;
                rot = trial_tp_row.magnitude_of_rot_or_clamp;
                targ_idx = trial_tp_row.Destination_Target;

 
    %%%% trial types 
                if instructions == 1
                    baseline = true;
                    trial_type = 0; %% 0 = instructions

                elseif instructions == 2
                    baseline = false;
                    learning = true;
                    trial_type = 0; %% 0 = instructions

                elseif instructions == 3
                    catch_trial = t + 1;
                    trial_type = 0; %% 0 = instructions

                elseif instructions == 4
                    learning = false;
                    % washout = true; 
                    trial_type = 0; %% 0 = instructions

                elseif instructions == 5 %% end experiment ? or washout instructions %%%%%%%%%%% check on robot
                    trial_type = 0; %% 0 = instructions

                else %% if instructions = 0 that means its experimental
                    if t == catch_trial
                        trial_type = 3; %% 3 = catch trial 
                    elseif baseline == true
                      trial_type = 1;   %% 1 = baseline
                    elseif learning == true
                      trial_type = 2;   %% 2 = learning
                    else
                      trial_type = 4;   %% 4 = washout
                    end
                end


   %%% events for experimental trials 
                if trial_type ~= 0  
           
                % % second state (get cue to move) 
                    golabel = find(strcmp(ct.EVENTS.LABELS, 'second state'));
                    gotime = round(1000*ct.EVENTS.TIMES(golabel));

                % % end trial (pass the target) 
                    endlabel = find(strcmp(ct.EVENTS.LABELS, 'end trial'));
                    endtime = round(1000*ct.EVENTS.TIMES(endlabel));  

                % % % between trials (actual end of trial = end_trial/pass the target + 500 or 1500)
                %     stoplabel = find(strcmp(ct.EVENTS.LABELS, 'between trials'));
                %     stoptime = round(1000*ct.EVENTS.TIMES(stoplabel));   
                %%%% get to final land position by looking at lowest velocity between targ and end 
    
            %%% get position information 
                    centerx = ct.TARGET_TABLE.X_GLOBAL(1);   
                    centery = ct.TARGET_TABLE.Y_GLOBAL(1);   

                    handx = (ct.Right_HandX*100) - centerx; %thanks to filtering, diff(posx) gives an excellent readout of velx
                    handy = (ct.Right_HandY*100) - centery; % now in cm
                    posx = handx(gotime:endtime);
                    posy = handy(gotime:endtime);

                    % compute RT and MT
                    vx = diff(posx)*1000;
                    vy = diff(posy)*1000;
                    vel = sqrt(vx.^2 + vy.^2);

            %%% angular error 
                    rad_rot = deg2rad(rot);
                    vs_targx = ct.TARGET_TABLE.X(targ_idx);
                    vs_targy = ct.TARGET_TABLE.Y(targ_idx);
                    % % path_radangle = atan2(posy - vs_targx, posx - vs_targy);
                    path_angle = atan2(posy, posx);
                    targ_angle = atan2(vs_targy, vs_targx);
                    pt_rad_rot = path_angle - targ_angle;
                    pt_rot = rad2deg(pt_rad_rot);
                   
                    vs_fbx = posx * cos(rad_rot) - posy * sin(rad_rot);
                    vs_fby = posx * sin(rad_rot) + posy * cos(rad_rot);

                    
                   %%%% For each ms
                    for ms = 1:length(posx) % for each moment 
                        vms(c) = ms;
                        vid(c) = id;
                        vprotocol(c) = protocol(file);
                        vtrial(c) = t;
                        vtrial_type(c) = trial_type;
                        vpt_rot(c) = pt_rot(ms);
                        vonline_fb(c) = online_fb;
                        vendpt_fb(c) = endpt_fb;
                        vpathx(c) = posx(ms);  
                        vpathy(c) = posy(ms);
                        vrot(c) = rot;
                        vvs_fbx(c) = vs_fbx(ms);
                        vvs_fby(c) = vs_fby(ms);           
                        if (ms == 1)
                            vevent(c) = 0; % ready and cue
                        elseif (ms > 1 && ms < length(posx))
                            vevent(c) = 2; % moving out
                        elseif (ms == length(posx))
                            vevent(c) = 3; % end point
                        end
                        % velocity
                        if (ms == 1) 
                            vvel(c) = 0;
                        else
                            vvel(c) = vel(ms-1);
                        end   
                        c = c+1;
                    end 
                end
            end
        end
    end
end
                    

df = struct( ...
    'id', vid.',...
    'trial', vtrial.',...
    'protocol', vprotocol.',...
    'trial_type', vtrial_type.',...
    'rot', vrot.',...
    'online_fb', vonline_fb.',...
    'endpt_fb', vendpt_fb.',...
    'pathx', vpathx.',...
    'pathy', vpathy.',...
    'ptrot', vpt_rot.',...
    'vs_fbx', vvs_fbx.',...
    'vs_fby', vvs_fby.',...
    'event', vevent.',...
    'vel', vvel.',...
    'ms', vms.');

myTable = struct2table(df); 




% writetable(myTable,'/Users/hannahillman/Desktop/research/MWM_project/data/preprocessed_active_adapt/all_matlab.csv')


