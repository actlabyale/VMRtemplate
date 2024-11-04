clear all;close all;clc;

directory = dir('/Users/hannahillman/Desktop/research/sophia_ext/data/robot_raw');

row = 1;
% trial_count = 1;
trial_type_tracker = [];

tlst = [];
baseline = false;
learning = false;
catch_trial = 0;
washout = false;

%%%% columns
tkinId = [];
tid = [];
ttrial = [];
trotDir = [];
trot = []; 
tonline = [];
%ttype = [];
%tphase = {};
%tphaseChunk = [];
trt = [];
tmt = [];
thandAng = [];
theadAng = [];
tvelAng = [];
tcursAng = [];
ttargIdx = [];
ttargAng = [];
thandx = [];
thandy = [];
tfb = [];
ttargx = [];
ttargy = [];
thandAngErr = [];
thandAngErrAbs = [];

big_struct = struct();
at = 1; %% start all trials index at 1
id = 0;
for f = 4:length(directory)
    dat = exam_load('dir', sprintf('/Users/hannahillman/Desktop/research/sophia_ext/data/robot_raw/%s', directory(f).name ));
    subdir = sprintf('/Users/hannahillman/Desktop/research/sophia_ext/data/robot_raw/%s', directory(f).name );

    pat = fileread(subdir + "/pat.dat");

    notEmpty = ~cellfun(@isempty, {dat.c3d}); % skips empty files (kinarm bug) 
    dat = dat(notEmpty);

    % % madlab id get
    startIndex = strfind(pat, 'msl00'); %% get the ID from pat string 
    endIndex = startIndex + 4; % 'msl00' is 5 characters long, but we add 4 because we start immediately after 'msl00'
    kin_id = pat(endIndex + 1 : endIndex + 4);
    kin_id = str2num(kin_id);
    % disp(['ID: ', kin_id]);
    id = id + 1;

    dat = KINARM_add_friction(dat); %friction inherent to motors of the robot
    dat = KINARM_add_hand_kinematics(dat); %use motors to calculate applied forces
    dat = filter_double_pass(dat, 'enhanced', 'fc', 10); %filtering is cracked

    for file = 1:length(dat)
        %disp(file)

        cc = dat(file).c3d;
        filelabel = dat(file).file_label;
        disp(filelabel)

        check_name = strfind(filelabel, 'vmr');

        if check_name >= 1
        
%       %%%% Make a easy TP Table for this file 
            tpstruct = cc(1).TP_TABLE; %% get the struct (just using the first entry as table is same for all)
            tpstruct = rmfield(tpstruct, 'USED'); %% remove the fields that are not 100 long
            tpstruct = rmfield(tpstruct, 'COLUMN_ORDER');
            tpstruct = rmfield(tpstruct, 'DESCRIPTIONS'); %% some are 1x100 and other are 100x1 bc kinarm is difficult
            fn = fieldnames(tpstruct);
            numfn = numel(fn);
            for i = 1:numfn %% reshape the struct by looping through entries
                field = fn{i};
                tpstruct.(field) = reshape(tpstruct.(field), 500, 1);
            end
            tptable = struct2table(tpstruct); %%% make a table from the struct 

            trial_count = 0;
            chunk_num = 0;


            for t = 1:length(cc) % each trial %% loop through everything just to future proof 
% %             % for t = 7 % each trial %% loop through everything just to future proof

        %%%% tptable variables 
                ct = cc(t); %% all the data 
                trial_tp_row = tptable(ct.TRIAL.TP_ROW,:); %% tp table data for that trial 
                instructions = trial_tp_row.instruction_index;
                online_fb = trial_tp_row.show_online_feedback;
                rot = trial_tp_row.magnitude_of_rot_or_clamp;
                targ_idx = trial_tp_row.Destination_Target;
                exam_trial = ct.TRIAL.TRIAL_RUN_COUNT;
                % trot(at) = rot; %add to list


%%%% check this on an example with negative rot 
        %%%% rotation direction (anti-/clockwise)
                % if any(ct.TP_TABLE.magnitude_of_rot_or_clamp(:, 1) < 0)
                %     rot_dir = -1;
                % else
                %     rot_dir = 1;
                % end

        %%%% trial_types 

                
                % if (instructions == 0) && (t >= 9) && (t < 48)
                %     trial_type = 1; % baseline 
                %     phase = 'baseline';
                %     trial_type_tracker(t) = trial_type;
                %     phase_chunk = 0;
                % elseif (instructions == 0) && (t > 48) && (t < 233) && (online_fb == 1)
                %     trial_type = 2; % learning
                %     trial_type_tracker(t) = trial_type;
                %     prev_type = trial_type_tracker(t-1);
                %     % disp(prev_type);
                %     if prev_type ~= trial_type
                %         chunk_num = chunk_num + 1; 
                %         disp(strcat("learn", num2str(chunk_num)));
                %     end
                %     phase = strcat("learn", num2str(chunk_num));
                % 
                % elseif  (instructions == 0) && (t > 48) && (t < 233) && (online_fb == 0)
                %     trial_type = 3;
                %     phase = strcat("catch", num2str(chunk_num));
                %     trial_type_tracker(t) = trial_type;
                % elseif (instructions == 0) && (t > 233) 
                %     trial_type = 4;
                %     phase = 'washout';
                %     trial_type_tracker(t) = trial_type;
                %     chunk_num = 0;
                % else 
                %     trial_type = 0;
                %     phase = 'instructions';
                %     trial_type_tracker(t) = trial_type;
                % end



                % if trial_type ~= prev_trial_type
                %     if trials(i).trial_type == 2  % Learning
                %         learn_num = learn_num + 1;
                %         trials(i).phase = ['learning_' num2str(learn_num)];
                %     elseif trials(i).trial_type == 3  % Catch
                %         catch_num = catch_num + 1;
                %         trials(i).phase = ['catch_' num2str(catch_num)];
                %     end
                % end


                % disp(['movement time: ', num2str(mvtime)]);


       %%%% events for experimental trials 
                % if ~strcmp(phase, 'instructions') && ~isempty(mvtime)
                    % disp(phase);
%                if (instructions == 0) && (exam_trial >= 8)
                if exam_trial == 3
                    tkinId(at) = kin_id;%add to list
                    tid(at) = id;%add to list
                    tlst(t) = t;
                    %ttype(at) = trial_type;
                    %tphase{at} = phase;
                    trotDir(at) = rot_dir;
                    tonline(at) = online_fb; %add to list
                    ttargIdx(at) = targ_idx;
                    trial_count = trial_count + 1; 
                    ttrial(at) = trial_count;
                    
               % % trial starts (target is shown, pt can move) 
                    intlabel = find(strcmp(ct.EVENTS.LABELS, 'in trial'));
                    inttime = round(1000*ct.EVENTS.TIMES(intlabel));
                    % disp(['in trial: ', num2str(inttime)]);

                % % end trial (passes the target) 
                    endlabel = find(strcmp(ct.EVENTS.LABELS, 'end trial'));
                    endtime = round(1000*ct.EVENTS.TIMES(endlabel));  
                    % disp(['end time: ', num2str(endtime)]);

                % % stop time (when they stop moving) 
                    % stoplabel = find(strcmp(ct.EVENTS.LABELS, 'between trials'));
                    % stoptime = round(1000*ct.EVENTS.TIMES(stoplabel));  

                % % participant starts moving (participant starts moving/reaction time) 
                    mvlabel = find(strcmp(ct.EVENTS.LABELS, 'Moving to target'));
                    mvtime = round(1000*ct.EVENTS.TIMES(mvlabel));
                
         %%%% calculate RT, MT, and feedback
                    reaction_time = mvtime - inttime; 
                    mvmt_time = endtime - mvtime;
                    trt(at) = reaction_time;
                    tmt(at) = mvmt_time;
    
                    if reaction_time > ct.TASK_WIDE_PARAMS.RT_threshold
                        tfb(at) = 1; % they were told to move sooner      %% used to be feedback
                    elseif (endtime - inttime) > ct.TASK_WIDE_PARAMS.MT_threshold
                        tfb(at) = 2; % they were told to move faster
                    else
                        tfb(at) = 0; % no feedback 
                    end
                    % tfb(at) = feedback;

         %%%% position information
                    centerx = ct.TARGET_TABLE.X_GLOBAL(1);   
                    centery = ct.TARGET_TABLE.Y_GLOBAL(1);   
                    % % hand angle 
                    posx = (ct.Right_HandX*100) - centerx; %thanks to filtering, diff(posx) gives an excellent readout of velx
                    posy = (ct.Right_HandY*100) - centery; % now in cm
                    handx = posx(mvtime:endtime);
                    handy = posy(mvtime:endtime);      

         %%%% angular error 
                    rad_rot = deg2rad(rot);
                    targx = ct.TARGET_TABLE.X(targ_idx);
                    targy = ct.TARGET_TABLE.Y(targ_idx);
                    targ_angle_rad = atan2(targy, targx); % targ angle = angle of target 
                    targ_angle = rad2deg(targ_angle_rad);

                    path_angle_rad = atan2(handy, handx);
                    path_angle = rad2deg(path_angle_rad); % path angle = angle of hand position in general

                    hand_angle_rad = path_angle_rad - targ_angle_rad; 
                    hand_angle_rad = mod(hand_angle_rad + pi, 2*pi) - pi; % this should take care of keeping it within -/+180
                    hand_angle = rad2deg(hand_angle_rad);  % hand angle = angle of hand position relative to target

                    cursorx = handx * cos(rad_rot) - handy * sin(rad_rot);
                    cursory = handx * sin(rad_rot) + handy * cos(rad_rot);
                    cursor_angle_rad = atan2(cursory, cursorx); % cursor angle = angle of cursor pt saw 
                    cursor_angle = rad2deg(cursor_angle_rad);

                    dist = sqrt((handx - 0).^2 + (handy - 0).^2);
                    distidx = (1:length(dist))';
                    distinfo = [distidx, dist];
                    diff_from_4 = abs(dist - 4); % Find the difference from 4
                    [min_diff4, closest4] = min(diff_from_4);% Find the minimum difference and its index
                    head_angle = hand_angle(closest4);               

             %%%% should double check velocity against old code 
                    delta_x = diff(handx); % Calculate Δx and Δy
                    delta_y = diff(handy);
                    velocity = sqrt(delta_x.^2 + delta_y.^2); % Calculate the velocity at each point (ignoring Δt since it's a constant factor)
                    [peak_vel, peak_idx] = max(velocity); % Find the index of the peak velocity
                    peak_ang_idx = peak_idx + 1; % Adjust the index for hand_angle (since diff reduces the array size by 1)
                    peak_vel_ang = hand_angle(peak_ang_idx);% Return the hand_angle at the peak velocity
                    % fprintf('The hand angle at the peak velocity is: %d degrees\n', peakHandAngle);
  %%% double check the *rot_dir for peak vel           
             %%%% adjust variables to be in same frame and take value 
                    thandAng(at) = hand_angle(end) * -rot_dir;
                    theadAng(at) = head_angle(end) * -rot_dir;
                    ttargAng(at)= targ_angle(end) * -rot_dir;
                    tcursAng(at) = cursor_angle(end) * -rot_dir;
                    tvelAng(at) = peak_vel_ang * -rot_dir;
                    trot(at) = rot * rot_dir; 
                    thandx(at) = handx(end);
                    thandy(at) = handy(end);
                    ttargx(at) = targx;
                    ttargy(at) = targy;
                    %tphaseChunk(at) = chunk_num;
                    thandAngErr(at) = (rot * rot_dir) - (hand_angle(end) * -rot_dir);
                    thandAngErrAbs(at) = abs((rot * rot_dir) - (hand_angle(end) * -rot_dir));
            
             %%%% progress to next trial for 
                    at = at + 1;

                end
            end
        end
    end
end


result_table = table(tkinId',tid',ttrial',trotDir', trot', tonline',trt',tmt', thandAng',theadAng',tvelAng',tcursAng',ttargIdx',ttargAng',thandx', thandy', ttargx', ttargy', tfb', thandAngErr', thandAngErrAbs', 'VariableNames', {'kinId', 'id', 'trial', 'rotDir', 'rot', 'online', 'type', 'phase', 'phaseChunk', 'rt', 'mt', 'handAng', 'headAng', 'velAng', 'cursAng', 'targIdx', 'targAng', 'handx', 'handy', 'targx', 'targy', 'fb', 'handAngErr', 'handAngErrAbs' });
%result_table = table(tkinId',tid',ttrial',trotDir', trot', tonline',ttype',tphase',tphaseChunk',trt',tmt', thandAng',theadAng',tvelAng',tcursAng',ttargIdx',ttargAng',thandx', thandy', ttargx', ttargy', tfb', thandAngErr', thandAngErrAbs', 'VariableNames', {'kinId', 'id', 'trial', 'rotDir', 'rot', 'online', 'type', 'phase', 'phaseChunk', 'rt', 'mt', 'handAng', 'headAng', 'velAng', 'cursAng', 'targIdx', 'targAng', 'handx', 'handy', 'targx', 'targy', 'fb', 'handAngErr', 'handAngErrAbs' });

%writetable(result_table,'/Users/hannahillman/Desktop/research/sophia_ext/data/pp_data.csv')

