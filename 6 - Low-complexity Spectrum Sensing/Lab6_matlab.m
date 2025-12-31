clear; 
close all; 
clc;

j=sqrt(-1);


%8-point approximate DFT (ADFT) matix
F8=[1         1           1           1           1          1            1         1        ;...
    1     (3/4)*(1-j)    (-j)   -(3/4)*(1+j)    (-1)   -(3/4)*(1-j)       j    (3/4)*(1+j)   ;...
    1       (-j)         (-1)         j           1        (-j)         (-1)        j        ;...
    1     (3/4)*(-1-j)     j     (3/4)*(1-j)    (-1)    (3/4)*(1+j)     (-j)  -(3/4)*(1-j)   ;...
    1       (-1)           1         (-1)         1        (-1)           1        (-1)      ;...
    1    -(3/4)*(1-j)    (-j)    (3/4)*(1+j)    (-1)    (3/4)*(1-j)       j   -(3/4)*(1+j)   ;...
    1         j           -1         -j           1          j          (-1)       (-j)         ;...
    1     (3/4)*(1+j)      j    -(3/4)*(1-j)    (-1)   -(3/4)*(1+j)     (-j)   (3/4)*(1-j)]  ;



%NUmber of time samples considered. This can be changed based on the simulink end time for simulation.
NN=256;



%sampling frequency
fs = 2e5;             % Sampling frequency 200(kHz)
t = 0:1/fs:NN-1/fs;   % Time vector 

%five different signal frequencies
f_bin = fs/8;
f1 = 1*f_bin;   % 25 kHz
f2 = 2*f_bin;   % 50 kHz
f3 = 3*f_bin;   % 75 kHz
f4 = 5*f_bin;   % 125 kHz
f5 = 1.5*f_bin; % 37.5 kHz (off-bin example)

%%Three distinct test cases, each featuring different complex sinusoidal input signals. Students
%%can create different test signals with the above frequencies for testing.

testcase = 1;  % <-- change between 1, 2, or 3

switch testcase
    case 1
        %--------------------------------------------------------------
        % TEST CASE 1: Three zero-mean tones at exact DFT bins
        %--------------------------------------------------------------
        x = exp(1j*2*pi*f1*t) + 0.7*exp(1j*2*pi*f2*t) + 0.4*exp(1j*2*pi*f3*t);
        title_suffix = 'Case 1: Zero-mean, exact-bin tones (k=1,2,3)';

    case 2
        %--------------------------------------------------------------
        % TEST CASE 2: With DC component + 2 exact-bin tones
        %--------------------------------------------------------------
        x = 0.5 + 0.45*exp(1j*2*pi*f2*t) + 0.25*exp(1j*2*pi*f3*t);
        title_suffix = 'Case 2: Non-zero mean, exact-bin tones (k=0,2,3)';

    case 3
        %--------------------------------------------------------------
        % TEST CASE 3: Zero-mean, off-bin tones
        %--------------------------------------------------------------
        x = 0.7*exp(1j*2*pi*f5*t);
        title_suffix = 'Case 3: Zero-mean, off-bin tones (1.5 bins)';

    otherwise
        error('Invalid test case number');
end


%8-point DFT
nfft=8;


xsf=zeros(NN-8,nfft);
xsfa=zeros(NN-8,nfft);


%Software Simulation
%Computing DFT & ADFT for each 8 samples.

for k=1:NN-8
    %DFT
    xsf(k,:)=(fft(x(k:k+7), nfft))/nfft;
    
    %ADFT
    xsfa(k,:)=F8*x(k:k+7).'/nfft;

end


%%%Display sequence, Any number can be chosen; the output will be the same for every sequence. 
S=12;

%DFT Results
figure(1)
stem(0:7,(abs(xsf(S,:))),'r');
xlabel("frequency bins");
ylabel("Normalized power");
title("FFT SW Results")

%ADFT Results
figure(2)
stem(0:7,(abs(xsfa(S,:))),'r');
xlabel("frequency bins");
ylabel("Normalized power");
title("ADFT SW Results")

%HW simulation: Design ADFT hardware using HDL coder blocks and load the input signals from the workspace. 

% word length selection
W=16;
D=11;
stop = 276;


%prepare the input signals in the format of a 2D array to load it to the
%workspace
%% Parameters
Ts = 1e-6;              % Sample time (must match Simulink block)
NN_sim = 100;           % Number of frames
nfft = 8;               % FFT length

%% Prepare input signal (8 complex samples)
x_complex = x(1:nfft);
xin = [real(x_complex), imag(x_complex)];  % 1x16 vector (real + imag)

%% Build input for Simulink
simin.time = (0:NN_sim-1)' * Ts;
simin.signals.values = repmat(xin, NN_sim, 1);
simin.signals.dimensions = 16;

%% Run Simulink model
simStop = simin.time(end);
simOut = sim('Lab6_Optimised_simulink', 'StopTime', num2str(simStop));
%simOut = sim('Lab6_simulink', 'StopTime', num2str(simStop));
%% Get output data
outdata = simOut.simout;

if isa(outdata, 'timeseries')
    Y = outdata.Data;
elseif isstruct(outdata)
    Y = outdata.signals.values;
else
    Y = outdata;
end

%% Combine real & imag parts
Xout = complex(Y(:,1:8), Y(:,9:16));

%% Plot last frame
figure;
stem(0:nfft-1, abs(Xout(end,:))/nfft, 'r', 'filled');
grid on;
xlabel('Frequency bins');
ylabel('Normalized power');
title(['ADFT HW Results – ' title_suffix]);


%Create the codes to do the simulation of the design and load the outputs
% of the design to this workspace.

%% -------------------------------------------------------------------------
%  Hardware Co-simulation on Nexys 4 board
% -------------------------------------------------------------------------

disp('Running FPGA-in-the-loop co-simulation...');

% Model name 
mdl_name = 'gm_Lab6_Optimised_fil';

% Stop time equals the end of the simin time vector
simStop = simin.time(end);

% Run the Simulink model and capture all workspace outputs
simOut = sim(mdl_name, 'StopTime', num2str(simStop));

%% -------------------------------------------------------------------------
%  Retrieve data from 'To Workspace' block named simout1
% -------------------------------------------------------------------------
outdata = simOut.get('simout1');

% Handle multiple data formats (Simulink can store different types)
if isa(outdata, 'timeseries')
    Y = outdata.Data;                       % timeseries -> extract Data
elseif isstruct(outdata)
    Y = outdata.signals.values;             % struct -> extract .signals.values
else
    Y = outdata;                            % matrix directly
end

% Combine real and imaginary parts into complex outputs
Xout = complex(Y(:,1:8), Y(:,9:16));        % assuming 8 complex channels

%% -------------------------------------------------------------------------
% Compare Software ADFT vs Hardware Co-simulation
% -------------------------------------------------------------------------

figure;
hold on; grid on;

% Software ADFT (red)
stem(0:7, abs(xsfa(S,:)), 'r', 'filled', 'DisplayName', 'ADFT Software');

% Hardware Co-simulation (blue)
stem(0:7, abs(Xout(end,:))/nfft, 'b', 'filled', 'DisplayName', 'ADFT Hardware (FPGA)');

xlabel('Frequency bins');
ylabel('Normalized power');
title(['ADFT: Software vs Hardware Co-simulation – ' title_suffix]);
legend('Location', 'best');


%%%%% The COE file generated code required for onboard testing. please
%%%%% uncomment the below code when you are generating the coe file

 
realdata=zeros(256,4);
imagdata=zeros(256,4);
 
for i =1:NN
    realdata(i,:)=hex(fi(real(x(i)),1,16,11));
    imagdata(i,:)=hex(fi(imag(x(i)),1,16,11));
end

% New txt file creation
fidr = fopen('ROMfreal.coe', 'wt');
fidi = fopen('ROMfimag.coe', 'wt');
% 
% 
% % Hex value write to the txt file
fprintf(fidr,'memory_initialization_radix=16;\n');
fprintf(fidr,'memory_initialization_vector=\n');
% 
% 
fprintf(fidi,'memory_initialization_radix=16;\n');
fprintf(fidi,'memory_initialization_vector=\n');
% 
for ll=1:256
     
    fprintf(fidr,char(realdata(ll,:)));
    fprintf(fidr,'\n');
%     
    fprintf(fidi,char(imagdata(ll,:)));
    fprintf(fidi,'\n');  
%    
end
% 
fclose(fidr);
fclose(fidi);