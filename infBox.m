function infBox(subject_ID, session_num, trial_num, key_pressed, last_reward, total_reward, wPtr, rect,dollor_im, group)
    Screen('FillRect', wPtr, [255 0 150], rect); 
    rect_box = [rect(1)+5, 50, rect(3)-5, 300];
    Screen('TextSize', wPtr, 23);
    [mouse_x, mouse_y, buttons] = GetMouse();
    text = cat(2, 'Subject ID: ', subject_ID, '\n', 'Session Num: ', num2str(session_num), '\n', 'Key Pressed: ', key_pressed, ...
        '\n', 'Last Trial Reward: ', num2str(last_reward), '\n', 'Group: ', group, '\n', 'Mouse X: ', num2str(mouse_x), '\n', 'Mouse Y: ', num2str(mouse_y));

    % fill
    Screen('FillRect', wPtr, [255 255 0], [rect_box(1), rect_box(2), rect_box(3), rect_box(2)+50]);
    Screen('TextStyle', wPtr, 1);
    DrawFormattedText(wPtr, 'Information Box', rect_box(1)+20, rect_box(2)+35, [0 0 0]);
    
    % box
    Screen('FrameRect', wPtr, [255 255 0], rect_box, 6);
    Screen('TextStyle', wPtr, 0);
    DrawFormattedText(wPtr, text, rect_box(1)+20, rect_box(2)+90, [255 255 255]);
    
    % trial
    Screen('FillOval', wPtr, [255 255 0], [rect_box(3)-50 50 rect_box(3)-10 90]);
    DrawFormattedText(wPtr, num2str(trial_num), 'center', 'center', [0 0 0], [], [], [], [], [], [rect_box(3)-50 50 rect_box(3)-10 90]);
    

    % image dollor
    faceTexture = Screen('MakeTexture', wPtr, dollor_im);
    im_rect = [rect(1)+15, rect(4)-280, rect(3)-15, rect(4)-100];
    Screen('FillRect', wPtr, [255 0 150], im_rect); 
    Screen('DrawTexture', wPtr, faceTexture, [], im_rect);

    myText2 = cat(2, 'Total Reward: ', num2str(total_reward), ' $');
    Screen('TextSize', wPtr, 23);
    DrawFormattedText(wPtr, myText2, rect(1) + 50, rect(4) - 30, [255 255 0]);
 
end

