%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gazepoint sample program for API communication
% Written in 2017 by Gazepoint www.gazept.com
%
% To the extent possible under law, the author(s) have dedicated all copyright 
% and related and neighboring rights to this software to the public domain worldwide. 
% This software is distributed without any warranty.
%
% You should have received a copy of the CC0 Public Domain Dedication along with this 
% software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% setup address and port
client_socket = tcpip('127.0.0.1', 4242); 

% setup line terminator
set(client_socket, 'InputBufferSize', 4096); 
fopen(client_socket); 
client_socket.Terminator = 'CR/LF';

% configure data server 
fprintf(client_socket, '<SET ID="ENABLE_SEND_COUNTER" STATE="1" />');
fprintf(client_socket, '<SET ID="ENABLE_SEND_POG_FIX" STATE="1" />');

fprintf(client_socket, '<SET ID="ENABLE_SEND_POG_LEFT" STATE="1" />');
fprintf(client_socket, '<SET ID="ENABLE_SEND_POG_RIGHT" STATE="1" />');

fprintf(client_socket, '<SET ID="ENABLE_SEND_PUPIL_LEFT" STATE="1" />');
fprintf(client_socket, '<SET ID="ENABLE_SEND_PUPIL_RIGHT" STATE="1" />');

fprintf(client_socket, '<SET ID="ENABLE_SEND_TIME" STATE="1" />');

% start data server sending data
fprintf(client_socket, '<SET ID="ENABLE_SEND_DATA" STATE="1" />');

pause(0.5);

% Data column of interest in the receive string
TIMEDATA = 4;
LPDDATA = 34;
RPDDATA = 44;

% clear any backlog of data, if not read fast enough the buffer queues old
flushinput(client_socket)

figure;
sp1 = subplot(1,1,1);
animatedPupil = animatedline('Color', [0.0000 0.4470 0.7410]);

time = [];
elapsed = [];
lpd = [];
rpd = [];

datetime('now')

clear last_fpog
while (1)
while (get(client_socket, 'BytesAvailable') > 0) 
DataReceived = fscanf(client_socket);
% parse 'DataReceived' string to extract data of interest
TmpStore = strsplit(DataReceived,'"'); % split on "
% TmpStore
% only parse if a data REC response was recieved (ignore CALib etc)
limit = 10;

if (strfind (TmpStore{1}, '<REC') == 1) 
    % pull out data of interest
    
    time = [time; datestr(now,'dd-mm-yyyy HH:MM:SS.FFF')];
    elapsed = [elapsed; str2num(TmpStore{TIMEDATA})];
    lpd = [lpd; str2num(TmpStore{LPDDATA})];
    rpd = [rpd; str2num(TmpStore{RPDDATA})];
    
    %addpoints(animatedPupil, time, lpd);
    
%     k = fix(time/limit);
%     xlim(sp1, [k*limit (k+1)*limit]);
%     ylim([10 25]);
end 
% clear any backlog of data, if not read fast enough the buffer queues old
flushinput(client_socket)
pause(0.000001) % delay to update UI
end
end

% clean up
fclose(client_socket); 
delete(client_socket); 
clear client_socket 