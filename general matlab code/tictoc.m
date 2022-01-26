function [time_vector] = tictoc()

time_vector = [];
f = figure;
uicontrol('Style', 'text',...
       'String', 'Click to record time, press any key to exit.',...
       'Units','normalized',...
       'Position', [0.25 0.6 0.5 0.1],...
       'FontUnits', 'normalized',...
       'FontSize', 0.4);

tic;

while (1)
    w = waitforbuttonpress;
    if w == 0
        t = toc;
        time_vector = [time_vector, t];
        disp(t);
    else 
        break;
    end
end

close(f);