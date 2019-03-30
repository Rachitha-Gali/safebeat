clearvars

% Create the face detector object.
global faceDetector pointTracker numPts;
faceDetector = vision.CascadeObjectDetector();

% Create the point tracker object.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Create the webcam object.
cam = webcam();

% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

global window_len loop_var acc_red acc_green acc_blue ret_r ret_g ret_b;
window_len = 0;
loop_var = 0;
runLoop = true;
numPts = 0;
frameCount = 1;
t0 = clock; 
acc_red = [0];
acc_green = [0];
acc_blue = [0];
duration = 15;
heartRate = [0];
SNR = [0];
full_window = 300;
STFT = zeros((full_window/2)+1,1);
nwind = full_window;
fs_video = 20;


timestamps = [0];
t1 = clock;

try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%Code for Live heartRate detection%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%disp(' The video should atleast run for 15 seconds  ')
  
while runLoop && etime(clock, t1) <= duration %condition %etime(clock, t0) < duration   %&& frameCount < 400 the clock is for webcam
    [videoFrame, timestamps(frameCount)] = snapshot(cam);
    videoFrameGray = rgb2gray(videoFrame);
    frameCount = frameCount + 1;
    videoFrame =  face_tracker(videoFrame);
    position  = [(size(videoFrame,1)) (size(videoFrame,1) -fix(size(videoFrame,2)/7))];
    position1 = [(size(videoFrame,1)-fix(size(videoFrame,1)/15)) (size(videoFrame,1) -fix(size(videoFrame,2)/4.7))];
    videoFrame = insertText(videoFrame,position1,'Heart Rate','FontSize',24);
    videoFrame = insertText(videoFrame,position,heartRate(end),'FontSize',56);
    step(videoPlayer, videoFrame);
    runLoop = isOpen(videoPlayer);   
end
    
acc_red = acc_red(1, 2:end);
acc_green = acc_green(1, 2:end);
acc_blue = acc_blue(1, 2:end);
fs_video = 20;
samples = fs_video*duration;
ts_array = linspace(timestamps(1)+timestamps(1)/10,duration,samples);
ip_red = interp1(timestamps, acc_red , ts_array);
ip_green = interp1(timestamps, acc_green , ts_array);
ip_blue = interp1(timestamps, acc_blue , ts_array);
[HR, STFT(:,1), x_td_signal,HR2] = ppg_extraction(ip_red, ip_green, ip_blue);
heartRate = [heartRate, HR];
heartRate = heartRate(1, 2:end);
snr_individual = CalcSNR(x_td_signal,fs_video);
SNR = [SNR, snr_individual];
SNR = SNR(1, 2:end);
x_td_signal_final = x_td_signal; %.*hann(nwind);

window_len = 20;
win_duration = 1;
 while  runLoop && etime(clock, t1) > duration && etime(clock, t1) <=20 %condition1 %etime(clock, t0) <duration   %&& frameCount < 400 the clock is for webcam 
      loop_var = loop_var+1;     
      old_frame = frameCount;
      ret_r = [0];
      ret_g = [0];
      ret_b = [0];
      t2 = clock;
 while etime(clock, t2) <= win_duration
     [videoFrame, timestamps(frameCount)] = snapshot(cam);
     videoFrameGray = rgb2gray(videoFrame);
     frameCount = frameCount + 1;
     videoFrame =  face_tracker(videoFrame);
     position  = [(size(videoFrame,1)) (size(videoFrame,1) -fix(size(videoFrame,2)/7))];
     position1 = [(size(videoFrame,1)-fix(size(videoFrame,1)/25)) (size(videoFrame,1) -fix(size(videoFrame,2)/4.7))];
     videoFrame = insertText(videoFrame,position1,'Heart Rate','FontSize',24);
     videoFrame = insertText(videoFrame,position,heartRate(end),'FontSize',56);
    step(videoPlayer, videoFrame);
    runLoop = isOpen(videoPlayer);   
 end
 
new_frame = frameCount- old_frame;
fs_video = 20;
samples1 = fs_video*win_duration;
ts_array1 = linspace(timestamps(old_frame),timestamps(frameCount-1),samples1);
ret_r = ret_r(1, 2:end);
ret_g = ret_g(1, 2:end);
ret_b = ret_b(1, 2:end);
ip_red_frag = interp1(timestamps(old_frame:frameCount-1), ret_r , ts_array1);
ip_green_frag = interp1(timestamps(old_frame:frameCount-1), ret_g , ts_array1);
ip_blue_frag = interp1(timestamps(old_frame:frameCount-1), ret_b , ts_array1);
 
ip_red = [ip_red, ip_red_frag];
ip_green = [ip_green, ip_green_frag];
ip_blue = [ip_blue, ip_blue_frag];
[HR,STFT(:,loop_var), x_td_signal,HR2]  = ppg_extraction(ip_red(end-299:end), ip_green(end-299:end), ip_blue(end-299:end));
if ~((HR <= (heartRate(end)+5) && HR >= (heartRate(end)-5)) || HR == heartRate(end))
    if(HR2 <= (heartRate(end)+5) && HR2 >= (heartRate(end)-5)) || HR2 == heartRate(end)
        heartRate = [heartRate, HR2];
    else
        a = abs(heartRate(end) - HR2);
        b = abs(heartRate(end) - HR);
        if a<b
           heartRate = [heartRate, HR2];
        else
           heartRate = [heartRate, HR]; 
        end
    end
else
    heartRate = [heartRate, HR];
end

x_td_signal_final = [x_td_signal_final; zeros(window_len,1)];
x_td_signal_final(((loop_var* window_len)+1):end) = x_td_signal_final((loop_var* window_len)+1:end) + (x_td_signal.*hann(nwind));

 end
 
 
%disp ("Final Heart Rate -  ")
%sprintf("%d", int8(mean(heartRate)))


fileID = fopen('value.txt','w');
fprintf(fileID,'%d\n',int8(mean(heartRate)));
fclose(fileID);

catch ERR
    disp('')
    disp('')
    disp(' An error occured. Kindly Sit upright infront of the webcam incase of')
    disp(' Option 1 - Live detection (The Viola Jones face detector needs ')
    disp('the face to be upright to detect it correctly) and try again')
end
% Clean up. 
clear cam; 
release(videoPlayer); 
release(pointTracker);
release(faceDetector);


