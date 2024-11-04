clear all;close all;clc;
% dataTable = table(...
%     ...
%     start2hold, hold2show, show2go,  go2move, show2move, move2crossed );
% resultTable = table(...
%     start2hold', hold2show', show2go', ...
%     go2move', show2move', move2crossed',rtShow', rtGo', mt', ...
%     'VariableNames', {'start2hold', 'hold2show', 'show2go',  'go2move', 'show2move', 'move2crossed',...
%     'rtShow', 'rtGo', 'mt'});


df = table(...
    atstart', ...
    debug1', ... 
    showtarg', ... 
    go', ... 
    moving', ... 
    crossed', ... 
    show2gosignal', ... 
    RTshow2move', ... 
    RTgo2move', ... 
    MT', ... 
    d1show', ... 
    d1go', ... 
    d1move', ... 
    d1cross', ... 
    'VariableNames', { ...
    'atstart', ... 
    'debug1', ...  
    'showtarg', ... 
    'go', ... 
    'moving', ... 
    'crossed', ...
    'show2gosignal', ... 
    'RTshow2move', ... 
    'RTgo2move', ... 
    'MT', ... 
    'd1show', ... 
    'd1go', ... 
    'd1move', ... 
    'd1cross'});



% start2hold = [];
% hold2show = [];
% show2go = []; 
% go2move = [];
% show2move = [];
% move2crossed = [];
% 
% %%%% testing
% idx_atstart = []; 
% idx_holding = []; 
% idx_showtarg = []; 
% start2hold = []; 
% hold2show = []; 
% show2go = []; 
% go2move = []; 
% show2move = []; 
% move2crossed = []; 
% rtShow = []; 
% rtGo = []; 
% mt = []; 
% 
% %%% temp
% show2gosignal = []; 
% RTshow2move = []; 
% RTgo2move = []; 
% MT = []; 
% d1show = []; 
% d1go = []; 
% d1move = []; 
% d1cross = []; 
% debug1 = [];

                % idx_holding = find(strcmp(ct.EVENTS.LABELS, 'holding'));
                % tholding = round(1000*ct.EVENTS.TIMES(idx_holding));
                % idx_atstart = find(strcmp(ct.EVENTS.LABELS, 'at start'));
                % tatstart = round(1000*ct.EVENTS.TIMES(idx_atstart));
                % 
                % idx_go = find(strcmp(ct.EVENTS.LABELS, 'signal go'));
                % tgo = round(1000*ct.EVENTS.TIMES(idx_go));
                % 
                % idx_moving = find(strcmp(ct.EVENTS.LABELS, 'pt moving'));
                % tmoving = round(1000*ct.EVENTS.TIMES(idx_moving));
                % 
                % idx_crossed = find(strcmp(ct.EVENTS.LABELS, 'end pt reached'));
                % tcrossed = round(1000*ct.EVENTS.TIMES(idx_crossed));
                % 
                % idx_debug1 = find(strcmp(ct.EVENTS.LABELS, 'debugger1'));
                % tdebug1 = round(1000*ct.EVENTS.TIMES(idx_debug1));
                % 
                % idx_debug2 = find(strcmp(ct.EVENTS.LABELS, 'debugger2'));
                % tdebug2 = round(1000*ct.EVENTS.TIMES(idx_debug2));
                % 
                % showtarg(blkTrial) = tshowtarg; 
                % go(blkTrial) = tgo; 
                % 
                % %%% temp
                % 
                % 
                % % %differences check
                % 
                % atstart(blkTrial) = tatstart; 
                % % holding(blkTrial) = tholding; 
                % debug1(blkTrial) = tdebug1; 
                % 
                % 
                % if ~tincomplete
                %     % debug2(blkTrial) = tdebug2; 
                %     % showtarg(blkTrial) = tshowtarg; 
                %     % go(blkTrial) = tgo; 
                %     moving(blkTrial) = tmoving; 
                %     crossed(blkTrial) = tcrossed;
                % 
                %     show2gosignal(blkTrial) = tgo-tshowtarg; 
                %     RTshow2move(blkTrial) = tmoving-tshowtarg; 
                %     RTgo2move(blkTrial) = tmoving-tgo; 
                %     MT(blkTrial) = tcrossed-tmoving; 
                %     d1show(blkTrial) = tshowtarg - tdebug1; 
                %     d1go(blkTrial) = tgo - tdebug1; 
                %     d1move(blkTrial) = tmoving - tdebug1; 
                %     d1cross(blkTrial) = tcrossed - tdebug1;
                % else
                %     % debug2(blkTrial) = NaN; 
                %     % showtarg(blkTrial) = NaN; 
                %     % go(blkTrial) = NaN; 
                %     moving(blkTrial) = NaN; 
                %     crossed(blkTrial) = NaN; 
                % 
                %     show2gosignal(blkTrial) = NaN; 
                %     RTshow2move(blkTrial) = NaN; 
                %     RTgo2move(blkTrial) = NaN; 
                %     MT(blkTrial) = NaN; 
                %     d1show(blkTrial) = NaN; 
                %     d1go(blkTrial) = NaN; 
                %     d1move(blkTrial) = NaN; 
                %     d1cross(blkTrial) = NaN;
                % end


                % start2hold(blkTrial) = holding - atstart;
                % hold2show(blkTrial) = showtarg - holding;
                % show2go(blkTrial) = go - showtarg; 
                % 
                % if ~tincomplete 
                %     go2move(blkTrial) = NaN; % RT
                %     show2move(blkTrial) = NaN; % kind of RT?
                %     move2crossed(blkTrial) = NaN; % MT 
                %     rtShow(blkTrial) = NaN;
                %     rtgo(blkTrial) = NaN;
                %     mt(blkTrial) = NaN;
                % 
                % else 
                %     go2move(blkTrial) = moving - go; % RT
                %     show2move(blkTrial) = go - showtarg; % kind of RT?
                %     move2crossed(blkTrial) = crossed - moving; % MT 
                % end
                % 
                % rtShow(blkTrial) = show2move(blkTrial);
                % rtGo(blkTrial) = go2move(blkTrial);
                % mt(blkTrial) = move2crossed(blkTrial); 


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% columns list
% cstart2hold = [];
% chold2show = [];
% cshow2go = []; 
% cgo2move = [];
% cshow2move = [];
% cmove2crossed = [];
% trial = ttrial;

% % id and trial info
% id = tid;
% subTrial = tsubTrial;
% blkTrial = tblkTrial; 
% kinTrial = tkinTrial;
% 
% % target info 
% targ = ttargIdx;
% targX = ttargx;
% targY = ttargy;
% targDeg = ttargDeg;
% 
% % protocol info 
% tpRow = ttpRow;
% contFB = tcontFB;
% endptFB = tendptFB;
% isRot = tisRot;
% rotDeg = trotDeg;
% goDelay = tgoDelay;
% phase = tphase;
% 
% % performance info 
% incomplete = tincomplete;
% err = terr; 
% rtShow = trtShow;
% rtGo = trtGo;
% mt = tmt; 
% thandAng = [];
% theadAng = [];
% tvelAng = [];
% tcursAng = [];


%% determine if trial was incomplete (sub let go during trial before crossing target dist) 
            % is_incomplete = 0;
            % idx_crossed = find(strcmp(ct.EVENTS.LABELS, 'end pt reached'));
            % if ~isempty(idx_crossed)
            %     is_incomplete = 1;
            % end%% TEMPORARY 

% clear all;close all;clc;
% 
% % baseDir = '../data/robot_raw';
% % directory = dir(baseDir);
% % directory = dir('../data/robot_raw');
% 
%     % % kin_id = grabStrID(pat,"id=",9);
%     % filename = directory(f).name;
%     % file_id = extractStrId(filename, "msl00", 4); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fix this in the function?
%     % consentId = 'msl00';
%     % idSearch = strfind()
%     id = id + 1
%     % disp(id);
%     idz = [idz, id];
% 
% 
% % row = 1
% idz = [];
% id = 0 
% 
% bitz = [];
% 
% vrot[]; 
% vt[];
% vms [];
% c = 1;
% 
% 
% %% %% %% set your directory to whatever folder the robot data is in 
% baseDir = '/Users/hannahillman/Desktop/research/VMR/template/data/robot_raw';
% 
% 
% %% load folders from the directory 
% directory = dir(baseDir);
% for f = 4:length(directory) %% for each folder in the directory 
% 
%     dat = exam_load('dir', fullfile(baseDir, directory(f).name)); %% load 'er up 
%     subdir = fullfile(baseDir, directory(f).name);
%     pat = fileread(fullfile(subdir, 'pat.dat'));
%     notEmpty = ~cellfun(@isempty, {dat.c3d}); % skip empty files (kinarm bug) 
%     dat = dat(notEmpty);
%     dat = KINARM_add_friction(dat); %friction inherent to motors of the robot
%     dat = KINARM_add_hand_kinematics(dat); %use motors to calculate applied forces
%     dat = filter_double_pass(dat, 'enhanced', 'fc', 10); %filtering is cracked
% 
% 
%     for file = 1:length(dat) %% for each file in the directory 
%         cc = dat(file).c3d;
%         filelabel = dat(file).file_label;
% 
%         for t = 10 %t = 1:length(cc)
%             ct = cc(t); 
%             rot = trial_tp_row.magnitude_of_rot_or_clamp;
% 
%             golabel = find(strcmp(ct.EVENTS.LABELS, 'second state'));
%             gotime = round(1000*ct.EVENTS.TIMES(golabel));
% 
%             posx = handx(gotime:endtime);
% 
%             for ms = 1:length(posx)
%                 vms(c) = ms;
%                 vrot(c) = rot;
%                 vt(c) = t; 
%             end
%         end
%     end
% end
% 
% 
% 
% resultTable = table(vms', vrot', vt', 'VariableNames', {'ms', 'rot', 't'});
% % df = struct( ...
% %     't', vt.');
% %     'rot', vrot.',...
% %     'ms', vms.');
% % 
% % myTable = struct2table(df); 
% 
% 
% for f = 4:length(directory) %% for each folder in the directory 
% 
% 
% 
% 
% % directory = dir('/Users/hannahillman/Desktop/research/VMR/template/preprocess')
% % 
% % for f = 4:length(directory)
% % 
% %     dat = exam_load('dir', fullfile(baseDir, directory(f).name));
% %     subdir = fullfile(baseDir, directory(f).name);
% %     pat = fileread(fullfile(subdir, 'pat.dat'));
% % 
% %     % dat = exam_load('dir', sprintf('/Users/hannahillman/Desktop/research/VMR/template/data/robot_raw/%s', directory(f).name ));
% %     % subdir = sprintf('/Users/hannahillman/Desktop/research/VMR/template/data/robot_raw/%s', directory(f).name );
% %     % pat = fileread(subdir + "/pat.dat");
% % 
% %     notEmpty = ~cellfun(@isempty, {dat.c3d}); % skips empty files (kinarm bug) 
% %     dat = dat(notEmpty);
% % 
% %     % % madlab id get
% %     getid = splitlines(pat);
% %     idcell = getid(1);
% %     idchar = char(idcell);
% %     id_foo = idchar(7:end); % 7 because of the num charachers in id=msl...
% %     id = str2num(id_foo);
% % %    %%disp(id);
% % 
% %     dat = KINARM_add_friction(dat); %friction inherent to motors of the robot
% %     dat = KINARM_add_hand_kinematics(dat); %use motors to calculate applied forces
% %     dat = filter_double_pass(dat, 'enhanced', 'fc', 10); %filtering is cracked
% % 
% %     for file = 1:length(dat)
% %         disp(file)
% %     end
% % end
% 
% 
% 
% 
% 
%             % tptab_row = tptable(ct.TRIAL.TP_ROW,:); %% tp table data for that trial 
%             % disp(tptab_row)
% 
% 
%             % trial_tp_row = ct.TRIAL.TP_ROW; %% tp table data for that trial 
% 
%             % tptab = ct.
%             % tptable(ct.TRIAL.TP_ROW,:);
%             % ttprow = tptable(ct.TRIAL.TP_ROW,:); %% tp table data for that trial 
%             % t_instruct = tptable.instruction_index;
%             %     online_fb = trial_tp_row.show_online_feedback;
%             %     endpt_fb = trial_tp_row.show_endpoint_feedback;
%             %     rot = trial_tp_row.magnitude_of_rot_or_clamp;
%             % 
%             % ttarget = trial_tp_row.Destination_Target;
% 
% 
%             % rot = trial_tp_row.magnitude_of_rot_or_clamp;
%             % 
%             % golabel = find(strcmp(ct.EVENTS.LABELS, 'second state'));
%             % gotime = round(1000*ct.EVENTS.TIMES(golabel));
%             % 
%             % posx = handx(gotime:endtime);
%             % 
%             % for ms = 1:length(posx)
%             %     vms(c) = ms;
%             %     vrot(c) = rot;
%             %     vt(c) = t; 
%             % end
% 
% 
% 
% 
% % resultTable = table(vms', vrot', vt', 'VariableNames', {'ms', 'rot', 't'});
% % % df = struct( ...
% % %     't', vt.');
% % %     'rot', vrot.',...
% % %     'ms', vms.');
% % % 
% % % myTable = struct2table(df); 
% % 
% % 
% % for f = 4:length(directory) %% for each folder in the directory 
% 
% 
% 
% 
% % directory = dir('/Users/hannahillman/Desktop/research/VMR/template/preprocess')
% % 
% % for f = 4:length(directory)
% % 
% %     dat = exam_load('dir', fullfile(baseDir, directory(f).name));
% %     subdir = fullfile(baseDir, directory(f).name);
% %     pat = fileread(fullfile(subdir, 'pat.dat'));
% % 
% %     % dat = exam_load('dir', sprintf('/Users/hannahillman/Desktop/research/VMR/template/data/robot_raw/%s', directory(f).name ));
% %     % subdir = sprintf('/Users/hannahillman/Desktop/research/VMR/template/data/robot_raw/%s', directory(f).name );
% %     % pat = fileread(subdir + "/pat.dat");
% % 
% %     notEmpty = ~cellfun(@isempty, {dat.c3d}); % skips empty files (kinarm bug) 
% %     dat = dat(notEmpty);
% % 
% %     % % madlab id get
% %     getid = splitlines(pat);
% %     idcell = getid(1);
% %     idchar = char(idcell);
% %     id_foo = idchar(7:end); % 7 because of the num charachers in id=msl...
% %     id = str2num(id_foo);
% % %    %%disp(id);
% % 
% %     dat = KINARM_add_friction(dat); %friction inherent to motors of the robot
% %     dat = KINARM_add_hand_kinematics(dat); %use motors to calculate applied forces
% %     dat = filter_double_pass(dat, 'enhanced', 'fc', 10); %filtering is cracked
% % 
% %     for file = 1:length(dat)
% %         disp(file)
% %     end
% % end