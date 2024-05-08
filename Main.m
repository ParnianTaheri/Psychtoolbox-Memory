clc
clear
close all

%%
% Information
subject_ID = '99106352';
s = 1;          % session

% Parameters
num_session = 4;
num_trial = 144/2;
num_good = 12;
num_bad = 12;
DS = [3 5 7 9];
task_time = 3;
reward_time = 2;
ITI = 1.5;
ITI_no_reward = 0.2;
total_reward = 0;
last_reward = 0;
reject_reward.value = 1;
reject_reward.threshold = randi([2 4]);
good_reward = 3;
bad_reward = 1;
state = 0;
key_pressed = 'None';

%%
% Load Images 
frac_im_value = cell(1, 24);
frac_im_perceptual = cell(1, 24);
m = 1;
n = 1;
rnd_img = randperm(48,24);
for i=1:48
    string = sprintf('/Users/parniantaheri/Desktop/temp/class/term 8/آز علوم اعصاب/2/Assignment2/Assignment2_fractals/%02d.jpeg', i);
    if any(rnd_img == i) 
        frac_im_value{m} = imread(string);
        m = m + 1;
    else
        frac_im_perceptual{n} = imread(string);
        n = n + 1;
    end
end

dollor_im = imread('/Users/parniantaheri/Desktop/temp/class/term 8/آز علوم اعصاب/2/Assignment2/dollor.png');
[coin_s, f] = audioread('/Users/parniantaheri/Desktop/temp/class/term 8/آز علوم اعصاب/2/Assignment2/coin.mp3');

%%
% Show Screen                                  
Screen('Preference', 'SkipSyncTests', 1);
%[wPtr, rect] = Screen('OpenWindow', 0, [], [100 300 1500 700]); 
[wPtr, rect] = Screen('OpenWindow', 0, []); 
rect_main = [rect(3)/5+50, rect(2), rect(3), rect(4)];
rect_info = [rect(1), rect(2), rect(3)/5, rect(4)];
Screen('FillRect', wPtr, [0 0 0], rect);
Screen('Flip', wPtr); 

SC_size = [rect_main(3)-rect_main(1) rect_main(4)-rect_main(2)];

session = struct('subject_ID', subject_ID, 'session_number', s, 'fractal_size', 3.81, 'peripheral_circle', 13.77, 'screen_size', SC_size);
trial = struct('button_pressed', cell(1,num_trial), 'fractal_name', cell(1,num_trial), 'fractal_pos', cell(1,num_trial), 'display_size', cell(1,num_trial),'group_type', cell(1,num_trial), 'trial_cond', cell(1,num_trial), 'mouse_pos', cell(1,num_trial));

% generate randoms
random = randperm(num_good+num_bad,num_good);
fractals = zeros(1, num_good+num_bad);
fractals(random) = 1;
selected_fractals = zeros(4, num_good+num_bad);


KbQueueCreate(-1);
KbQueueStart();

%%
[display_size_value, trial_condition_value] = conditions(DS, num_trial);
[display_size_perceptual, trial_condition_perceptual] = conditions(DS, num_trial);
display_size_total = [display_size_value,display_size_perceptual];
trial_condition_total = [trial_condition_value, trial_condition_perceptual];
random_group = randperm(144);
%%
debug_mode = 1;
for tr=1:num_trial
    if random_group(tr)>72
        group = 'Perceptual';
        display_size = display_size_perceptual;
        trial_condition = trial_condition_perceptual;
        frac_im = frac_im_perceptual;
    else
        group = 'Value';
        display_size = display_size_value;
        trial_condition = trial_condition_value;
        frac_im = frac_im_value;
    end 

    % state machine
    if (state == 0)     % begin
        text = cat(2,'Press any key to begin session ', num2str(s), ' ...');
        Screen('TextSize', wPtr, 80);
        DrawFormattedText(wPtr, text, 'center', 'center', [255 255 255]);
        Screen('Flip', wPtr);
        [~, ~, ~] = KbWait();
        state = 1;
    end

    if (state == 1)     % fixation
        fixation_time = randi([300 500])/1000;
        x_center = rect_main(3)/2+rect_main(1)/2;
        y_center = rect_main(4)/2;
        
        Screen('FillOval', wPtr, [0 0 255], [x_center-20, y_center-20, x_center+20, y_center+20])
        Screen('Flip', wPtr);

        WaitSecs(fixation_time);
        Screen('Flip', wPtr);

        state = 2;
    end

    if (state == 2)     % onset  
        [selected_fractals, fractal_num, fractal_pos] = getFractal(fractals, selected_fractals, display_size(tr), trial_condition(tr),SC_size, rect_main);
        infBox(subject_ID, s, tr, key_pressed, last_reward, total_reward, wPtr, rect_info, dollor_im, group);
        [state, ITI_time, last_reward, reject_reward, key_pressed, ku, mouse_pos] = show(frac_im, fractal_num, fractal_pos, display_size(tr), trial_condition(tr), reject_reward, debug_mode, wPtr, rect_main);
    end
                                                
    if (state == 3)     % error    
        Beeper(1e3, 1, 0.5);
        state = 5;
    end

    if (state == 4)     % reward
        total_reward = total_reward + last_reward;
        showReward(last_reward, coin_s , f, reward_time, wPtr);
        state = 5;
    end

    if (state == 5)     % ITI
        Screen('Flip', wPtr);
        WaitSecs(ITI_time);
    end
    
    state = 1;
    [~, firstPress, ~, ~, ~] = KbQueueCheck(-1);
    % 41 = ESC
    if (firstPress(41)>0 || ku == 3)
        sca;
        return;
    end
    KbQueueFlush();
    
    % save struct
    trial(tr).button_pressed = key_pressed;
    trial(tr).fractal_name = fractal_num;
    trial(tr).fractal_pos = fractal_pos;
    trial(tr).display_size = display_size(tr);
    trial(tr).trial_cond = trial_condition(tr);
    trial(tr).mouse_pos = mouse_pos;
end
 
sca;
clear screen;

%                                               xx                 xxxx                                                              `                                                                   x                                                                                                                                       