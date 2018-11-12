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
FPOGXDATA = 6;
FPOGYDATA = 8;
FPOGVDATA = 16;
LPOGXDATA = 18;
LPOGYDATA = 20;
LPOGVDATA = 22;
RPOGXDATA = 24;
RPOGYDATA = 26;
RPOGVDATA = 28;
LPDDATA = 34;
LPSDATA = 36;
LPVDATA = 38;
RPDDATA = 44;
RPSDATA = 46;
RPVDATA = 48;

% clear any backlog of data, if not read fast enough the buffer queues old
flushinput(client_socket)

time = [];
elapsed = [];
lpd = [];
lps = [];
rpd = [];
rps = [];
fpogx = [];
fpogy = [];
rpogx = [];
rpogy = [];
lpogx = [];
lpogy = [];

clear last_fpog
while (1)
while (get(client_socket, 'BytesAvailable') > 0) 
DataReceived = fscanf(client_socket);
% parse 'DataReceived' string to extract data of interest
TmpStore = strsplit(DataReceived,'"'); % split on "
% TmpStore
% only parse if a data REC response was recieved (ignore CALib etc)

if (strfind (TmpStore{1}, '<REC') == 1) 
    % pull out data of interest
    fpog = [str2double(TmpStore{FPOGXDATA}), str2double(TmpStore{FPOGYDATA})];
    fpogv = str2num(TmpStore{FPOGVDATA});

    rpog = [str2double(TmpStore{RPOGXDATA}), str2double(TmpStore{RPOGYDATA})];
    rpogv = str2num(TmpStore{RPOGVDATA});
    lpog = [str2double(TmpStore{LPOGXDATA}), str2double(TmpStore{LPOGYDATA})];
    lpogv = str2num(TmpStore{LPOGVDATA});
    
    if (rpogv == 1)
        rpogx = [rpogx; rpog(1)];
        rpogy = [rpogy; rpog(2)];
    else
        rpogx = [rpogx; -1];
        rpogy = [rpogy; -1];
    end
    
    if (lpogv == 1)
        lpogx = [lpogx; lpog(1)];
        lpogy = [lpogy; lpog(2)];
    else
        lpogx = [lpogx; -1];
        lpogy = [lpogy; -1];
    end
    
    if (fpogv == 1)
        fpogx = [fpogx; fpog(1)];
        fpogy = [fpogy; fpog(2)];
    else
        fpogx = [fpogx; -1];
        fpogy = [fpogy; -1];
    end
    
    time = [time; datestr(now,'dd-mm-yyyy HH:MM:SS.FFF')];
    elapsed = [elapsed; str2double(TmpStore{TIMEDATA})];
    
    lpv = str2num(TmpStore{LPVDATA});
    rpv = str2num(TmpStore{RPVDATA});
    
    if (lpv == 1)
        lpd = [lpd; str2double(TmpStore{LPDDATA})];
        lps = [lps; str2double(TmpStore{LPSDATA})];
    else
        lpd = [lpd; -1];
        lps = [lps; -1];
    end
    
    if (rpv == 1)
        rpd = [rpd; str2double(TmpStore{RPDDATA})];
        rps = [rps; str2double(TmpStore{RPSDATA})];
    else
        rpd = [rpd; -1];
        rps = [rps; -1];
    end
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

participant = 'S009';
path = ['data/', participant];
save(path, 'time', 'elapsed', 'lpd', 'lps', 'rpd', 'rps', 'fpogx', 'fpogy', 'rpogx', 'rpogy', 'lpogx', 'lpogy');