function showReward(reward, coin_s, f, reward_time, wPtr)
    % text
    myText = cat(2, 'You earned ', num2str(reward), ' $');
    Screen('TextSize', wPtr, 80);
    DrawFormattedText(wPtr, myText,'center', 'center', [255 255 0]);
    
    % audio
    InitializePsychSound;
    pahandle = PsychPortAudio('Open', [], [], [], f);
    PsychPortAudio('FillBuffer', pahandle, coin_s');
    PsychPortAudio('Start', pahandle);
    
    Screen('Flip', wPtr);
    WaitSecs(reward_time);
end

