% ### matRec.m ###  07.02.15
% Works to record/playback on Mac laptop (syntax swiped from online
% record.m doc page)

% - To determine appropriate DeviceID, type: > devinfo = audiodevinfo
% (current laptop is a bit wonky since it only has a single 1/8 port which
% the OS seems to try to dynamically guess what is coming in)
% - When nothing is plugged into 1/8 port, default is internal mic
% (DeviceID=-1, though 0 seems to work too)
% - When something is plugged into the 1/8 port, it by-passes the internal
% mic but seems to keep the same DeviceID
% - To save the recorded waveform, you need to use getaudiodata (see xx
% below)

clear
myVoice = audiorecorder(44100,16,1,0);

% Define callbacks to show when
% recording starts and completes.
myVoice.StartFcn = 'disp(''Start speaking.'')';
myVoice.StopFcn = 'disp(''End of recording.'')';

record(myVoice, 2);
pause(2)

playerObj = play(myVoice);

%disp('Properties of playerObj:');
%xx= get(playerObj)

xx= getaudiodata(myVoice);
plot(xx)