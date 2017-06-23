function t=fixation(screenRes)
     % FIXATION -- usage: fixation([])
     %                    fixation([0 0 800 600])

     %% SCREEN SETUP
     % Removes the blue screen flash and minimize extraneous warnings.
     % http://psychtoolbox.org/FaqWarningPrefs
     Screen('Preference', 'Verbosity', 2); % remove cli startup message
     Screen('Preference', 'VisualDebugLevel', 3); % remove  visual logo
     %Screen('Preference', 'SuppressAllWarnings', 1);
     Screen('Preference', 'SkipSyncTests', 1);

     % same key names everywhere
     KbName('UnifyKeyNames')

     % Open a new window.
     screennum=max(Screen('Screens'));

     % open a PTB screen to draw thigns on
     defBgColor = [ 170 170 170]; % default background is a grey color
     [w, res] = Screen('OpenWindow', screennum,defBgColor,screenRes);
     

     % Set process priority to max to minimize lag or sharing process time with other processes.
     Priority(MaxPriority(w));

     HideCursor;

     % set font -- depends on version of matlab/ptb
     v=version();
     v=str2double(v(1:3));
     % if newer or are using octave
     if v>=8 || exist('OCTAVE_VERSION','builtin')
         Screen('TextFont', w, 'Arial');
         Screen('TextSize', w, 26);
     else
        % older matlab+linux:
        %Screen('TextFont', w, '-misc-fixed-bold-r-normal--13-100-100-100-c-70-iso8859-1');
        Screen('TextFont', w, '-misc-fixed-bold-r-normal--0-0-100-100-c-0-iso8859-16');
     end


     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     %% actual fixation
     Screen('TextSize',w, 96);
     DrawFormattedText(w,'+','center','center', [255 255 255]);
     fixonset=Screen('Flip', w,when);

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     %% wait for a keypress and then kill everything
     acceptkeysidx =  KbName({'Esc','Space','Qq'});
     pushed=0;
     while 1
       [keyPressed, keyonset, keyCode] = KbCheck;
       if any( keyCode(acceptkeysidx) )
         break
       end
       WaitSec(.01)
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    t=keyonset-fixonset;
end
