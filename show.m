function [state, ITI_time, reward, reject_reward, key_pressed, ku, mouse_pos] = show(frac_im, fractal_num, fractal_pos, display_size, trial_condition, reject_reward, debug_mode, wPtr, rect)
    x_center = rect(3)/2+rect(1)/2;
    y_center = rect(4)/2;
    SetMouse(x_center, y_center);
    
    % show fractals
    size_w = 100;
    if (trial_condition == "TP")
        good_ind = randi(display_size);
        im_rect = [fractal_pos(1, good_ind)-size_w, fractal_pos(2, good_ind)-size_w, fractal_pos(1, good_ind)+size_w, fractal_pos(2, good_ind)+size_w];
        faceTexture = Screen('MakeTexture', wPtr, frac_im{fractal_num.good});
        Screen('DrawTexture', wPtr, faceTexture, [], im_rect);
        if (debug_mode)
            border_rect = [fractal_pos(1, good_ind)-size_w*2/3, fractal_pos(2, good_ind)-size_w*2/3, fractal_pos(1, good_ind)+size_w*2/3, fractal_pos(2, good_ind)+size_w*2/3];
            Screen('FrameRect', wPtr, [0 255 0], border_rect, 4);
        end
    else
        good_ind = 0;
    end
    k = 0;
    for i=1:display_size
        if (i ~= good_ind)
            k = k + 1;
            im_rect = [fractal_pos(1, i)-size_w, fractal_pos(2, i)-size_w, fractal_pos(1, i)+size_w, fractal_pos(2, i)+size_w];
            faceTexture = Screen('MakeTexture', wPtr, frac_im{fractal_num.bad(k)});
            Screen('DrawTexture', wPtr, faceTexture, [], im_rect);
            if (debug_mode)
                border_rect = [fractal_pos(1, i)-size_w*2/3, fractal_pos(2, i)-size_w*2/3, fractal_pos(1, i)+size_w*2/3, fractal_pos(2, i)+size_w*2/3];
                Screen('FrameRect', wPtr, [255 0 0], border_rect, 4);
            end
        end
    end
    Screen('Flip', wPtr);
    
    buttons = 0;
    s = GetSecs;   
     while (GetSecs-s <= 3)
        while (~buttons(1)) && (GetSecs-s <= 3)
            [mouse_x, mouse_y, buttons] = GetMouse();

        end
    end
    mouse_pos = [mouse_x, mouse_y];
    
    % get response
    [keyIsDown, ~, keyCode] = KbCheck;

    ku = 4;
    if keyIsDown
        ku1 = KbName((keyCode));
        if ku1 == "space"
            ku = 1;
        elseif ku1 == "x"
            ku = 2;
        elseif ku1 == "ESCAPE"
            ku = 3;
        else
            ku = 0;
        end
    end
    if (ku==2)  % reject
        key_pressed = 'x';
        if (trial_condition == "TP")
            state = 5;
            ITI_time = 1.5;
            reward = 0;
        else
            if (reject_reward.value >= reject_reward.threshold)
                reject_reward.value = 1;
                reject_reward.threshold = randi([2 4]);
                state = 4;
                ITI_time = 1.5;
                reward = 1;
            else
                reject_reward.value = reject_reward.value + 1;
                state = 5;
                ITI_time = 0.2;
                reward = 0;
            end
        end

    elseif (ku == 1)     % select
        key_pressed = 'Space';
        o = MousPos(fractal_pos, good_ind, mouse_x, mouse_y, size_w);
        ITI_time = 1.5;
        if (o == 1)
            state = 4;
            reward = 1;
        elseif (o == 2)
            state = 4;
            reward = 3;
        else
            state = 3;
            reward = 0;
        end
    else
        state = 3;
        ITI_time = 1.5;
        key_pressed = KbName(keyCode);
        reward = 0;
    end
end
