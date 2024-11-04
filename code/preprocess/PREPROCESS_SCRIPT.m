clear all;close all;clc;

%%% set your directory to whatever folder the robot data is in 
baseDir = '../../data/robot_raw';
saveAs = '../../data/preprocessed/vmrMatPP.csv'
directory = dir(baseDir);


% id and trial info
id = [];
subTrial = [];
blkTrial = []; %%% special
kinTrial = [];

% target info 
targ = [];
targX = [];
targY = [];
targDeg = [];

% protocol info 
% tpRow = [];
contFB = [];
endptFB = [];
isRot = [];
rotDeg = [];
rotDir = [];
goDelay = [];
phase = [];

% performance info 
incomplete = [];
rtShow = [];
rtGoSig = [];
mt = []; 
handAng = [];
headAng = [];
velAng = [];
cursorAng = [];
err = []; 


%%% comb through directory for each subject folder
for f = 4:length(directory) %% for each folder in the directory 
    
    dat = exam_load('dir', fullfile(baseDir, directory(f).name)); %% load 'er up 
    subdir = fullfile(baseDir, directory(f).name);
    pat = fileread(fullfile(subdir, 'pat.dat'));
    notEmpty = ~cellfun(@isempty, {dat.c3d}); % skip empty files (kinarm bug) 
    dat = dat(notEmpty);
    dat = KINARM_add_friction(dat); %friction inherent to motors of the robot
    dat = KINARM_add_hand_kinematics(dat); %use motors to calculate applied forces
    dat = filter_double_pass(dat, 'enhanced', 'fc', 10); %filtering is cracked
    idfull = extractStrId(pat, 'msl00', 4);
    tid = str2double(idfull(end-3:end)); % gets ID (see func for details)
    tsubTrial = 1; % trial index for subject across files

    %%% for each file in a participant's folder 
    for file = 1:length(dat) %% for each file in the directory 
        cc = dat(file).c3d; %% for all trials 
        filelabel = dat(file).file_label; 
        t = 1; %% trial counter for each file - experimental trials only
        tblkTrial = t;

      %%% Make a easy TP Table for this file 
        tpstruct = cc(1).TP_TABLE; %% get the struct (just using the first entry as table is same for all)
        tpstruct = rmfield(tpstruct, 'USED'); %% remove the fields that are not 100 long
        tpstruct = rmfield(tpstruct, 'COLUMN_ORDER');
        tpstruct = rmfield(tpstruct, 'DESCRIPTIONS'); %% some are 1x100 and other are 100x1 bc kinarm is difficult
        fn = fieldnames(tpstruct);
        numfn = numel(fn);
        for i = 1:numfn %% reshape the struct by looping through entries
            field = fn{i};
            tpstruct.(field) = reshape(tpstruct.(field), 500, 1); % 500 = max rows in tp table (not your exp, max general)
        end
        tptab = struct2table(tpstruct); %%% make a table from the struct 
        
        %%% for each trial 
        for r = 1:length(cc) %22 
            tkinTrial = r; %% trial for each file, including non experimental trials 
            ct = cc(r); 
            tpRow = tptab(ct.TRIAL.TP_ROW,:); %% tp table data for that trial 
            trotDir = 1 - 2 * any(ct.TP_TABLE.deg(:, 1) < 0);
            instruct = tpRow.png; % id if it's an instruction trial - skip and do not count towards trials
            tincomplete_idx = find(strcmp(ct.EVENTS.LABELS, 'incomplete')); %% if they let go before crossing tgt dist it is incomplete
            if tincomplete_idx
                tincomplete = 1;
            else
                tincomplete = 0;
            end
            disp(tincomplete_idx);
            disp(tincomplete)


            %%% skip instruction trials 
            if instruct == 0
                %%% target info 
                ttarg = tpRow.target; % target shown
                ttargX = ct.TARGET_TABLE.X(ttarg);
                ttargY = ct.TARGET_TABLE.Y(ttarg);
                targRad = atan2(ttargY, ttargX); % not saved but used further down in script
                ttargDeg = rad2deg(targRad);
                targDist = sqrt((ttargX - 0).^2 + (ttargY - 0).^2);

                %%% protocol info 
                tcontFB = tpRow.cont_fb; % 
                tendptFB = tpRow.endpt_fb;
                tisRot = tpRow.is_rot;
                trotDeg = tpRow.deg;
                rotRad = deg2rad(trotDeg);
                tgoDelay = tpRow.go_delay;
                tphase = tpRow.phase;

                %%% timing info 
                idx_showtarg = find(strcmp(ct.EVENTS.LABELS, 'show target')); % target is shown but no go signal yet
                tshowtarg = round(1000*ct.EVENTS.TIMES(idx_showtarg));
                idx_goSig = find(strcmp(ct.EVENTS.LABELS, 'signal go')); % go signal (target turns colors) 
                tgoSig = round(1000*ct.EVENTS.TIMES(idx_goSig));
                idx_moving = find(strcmp(ct.EVENTS.LABELS, 'pt moving')); % participant moves out of home target
                tmoving = round(1000*ct.EVENTS.TIMES(idx_moving));
                idx_crossed = find(strcmp(ct.EVENTS.LABELS, 'end pt reached')); % participant crosses target dist threshold - fb turned off
                tcrossed = round(1000*ct.EVENTS.TIMES(idx_crossed));
                if tincomplete
                    trtShow = NaN; % if it is incomplete it means they let go of handle before end pt reached 
                    trtGoSig = NaN; %% therefore these variables are not calculable
                    tmt = NaN;   
                    thandAng = NaN; 
                    theadAng = NaN; 
                    tvelAng = NaN; 
                    tcursorAng = NaN; 
                else
                    trtShow = tmoving - tshowtarg;
                    trtGoSig = tmoving - tgoSig;
                    tmt = tcrossed - tmoving;
    
                    %%% position information
                    centerx = ct.TARGET_TABLE.X_GLOBAL(1);   
                    centery = ct.TARGET_TABLE.Y_GLOBAL(1);   
                    posx = (ct.Right_HandX*100) - centerx; %thanks to filtering, diff(posx) gives an excellent readout of velx
                    posy = (ct.Right_HandY*100) - centery; % now in cm
                    handx = posx(tmoving:tcrossed);
                    handy = posy(tmoving:tcrossed);
    
                    pathAngRad = atan2(handy, handx);
                    pathAng = rad2deg(pathAngRad); % path angle = angle of hand position in general
                    
                    handAngRad = pathAngRad - targRad; 
                    handAngRad = mod(handAngRad + pi, 2*pi) - pi; % this should take care of keeping it within -/+180
                    thandAng = rad2deg(handAngRad);  % hand angle = angle of hand position relative to target
    
                    cursorx = handx * cos(rotRad) - handy * sin(rotRad);
                    cursory = handx * sin(rotRad) + handy * cos(rotRad);
                    cursorAngRad = atan2(cursory, cursorx); % cursor angle = angle of cursor pt saw 
                    tcursorAng = rad2deg(cursorAngRad);
    
                    dist = sqrt((handx - 0).^2 + (handy - 0).^2);
                    distidx = (1:length(dist))';
                    distinfo = [distidx, dist];
                    distHalf = abs(dist - (targDist/2)); % Find the dist at halfway pt 
                    [minHalf, closestHalf] = min(distHalf);% Find the minimum difference and its index
                    theadAng = thandAng(closestHalf);  
    
                    delta_x = diff(handx); % Calculate Δx and Δy
                    delta_y = diff(handy);
                    velocity = sqrt(delta_x.^2 + delta_y.^2); % Calculate the velocity at each point (ignoring Δt since it's a constant factor)
                    [peakVel, peakIdx] = max(velocity); % Find the index of the peak velocity
                    peakAngIdx = peakIdx + 1; % Adjust the index for hand_angle (since diff reduces the array size by 1)
                    tvelAng = thandAng(peakAngIdx);% Return the hand_angle at the peak velocity
                end % end of incomplete loop 
                terr = round(max(ct.ACH0)); % error is an analog, nums correspond to ErrTypes.m script in dex task folder

                id(t) = tid; 
                subTrial(t) = tsubTrial; 
                blkTrial(t) = tblkTrial; 
                kinTrial(t) = tkinTrial; 
                targ(t) = ttarg; 
                targX(t) = ttargX; 
                targY(t) = ttargY; 
                targDeg(t) = ttargDeg; 
                contFB(t) = tcontFB; 
                endptFB(t) = tendptFB; 
                isRot(t) = tisRot; 
                rotDeg(t) = trotDeg * - trotDir; % multiplying them by -rotDir puts them all in thes same frame
                rotDir(t) = trotDir;
                goDelay(t) = tgoDelay; 
                phase(t) = tphase; 
                incomplete(t) = tincomplete; 
                rtShow(t) = trtShow; 
                rtGoSig(t) = trtGoSig; 
                mt(t) = tmt; 
                handAng(t) = thandAng(end) * - trotDir; 
                headAng(t) = theadAng(end) * - trotDir; 
                velAng(t) = tvelAng(end) * - trotDir; 
                cursorAng(t) = tcursorAng(end) * - trotDir; 
                err(t) = terr; 

                %%% proceed
                t = t + 1;
                
            end
        end
    end
end


df = table(...
    id', ... 
    subTrial', ... 
    blkTrial', ... 
    kinTrial', ... 
    targ', ... 
    targX', ... 
    targY', ... 
    targDeg', ... 
    contFB', ... 
    endptFB', ... 
    isRot', ... 
    rotDeg', ... 
    rotDir', ... 
    goDelay', ... 
    phase', ... 
    incomplete', ... 
    rtShow', ... 
    rtGoSig', ... 
    mt', ... 
    handAng', ... 
    headAng', ... 
    velAng', ... 
    cursorAng', ... 
    err', ... 
    'VariableNames', { ...
    'id', ... 
    'subTrial', ... 
    'blkTrial', ... 
    'kinTrial', ... 
    'targ', ... 
    'targX', ... 
    'targY', ... 
    'targDeg', ... 
    'contFB', ... 
    'endptFB', ... 
    'isRot', ... 
    'rotDeg', ...
    'rotDir', ...
    'goDelay', ... 
    'phase', ... 
    'incomplete', ... 
    'rtShow', ... 
    'rtGoSig', ... 
    'mt', ... 
    'handAng', ... 
    'headAng', ... 
    'velAng', ... 
    'cursorAng', ... 
    'err'});

writetable(df,saveAs)
