clear
close all
clc

%original signal
data = readmatrix('orig_data.csv');
column1_orig = data(:,4);
%data = readmatrix('15s_EMG_four_channels.csv');
%column1_orig = data(:,12);
%col1_length=size(column1_orig,1);
original_sig = column1_orig;
%figure(1)
%plot(original_sig)
%title('original signal')
%received signal
data_rx = readmatrix('adapter_board.csv');
column1_rx = data_rx(:,4);
%col1_rx_length=size(column1_rx,1);
received_sig = column1_rx;
%received_sig = received_sig +10*randn(1,length(received_sig));
%figure(2)
%plot(received_sig)
%title('received signal')
xc = xcorr(received_sig, original_sig); %Cross corellate the two signals
[max_val, max_ind] = max(xc); %Find the index that the data starts
l = length(received_sig);
max_ind = (max_ind+1 - length(received_sig)); %remove the offset from the xcorr

recovered_sig = received_sig(max_ind:max_ind-1+length(original_sig)); %Recover the signal from the offset

%Calculate sampling frequency and periods
fs = 1e3;
ts = 1/fs;
x_axis = ts*[0:length(recovered_sig)-1]; %create the xaxis
x_axis_rx = ts*[0:length(received_sig)-1];

%Plot Stuff

%Original signal
figure(1)
plot(x_axis_rx, received_sig)
title('received signal')
grid minor

%Crosscorelation
figure(2)
plot(xc)
title('crosscorrelation of original and recovered signals')
grid minor

%Original vs recovered signal
figure(3)
plot(x_axis,recovered_sig, x_axis, original_sig);
xlabel('Time(sec)')
ylabel('Input (V)')
legend('recovered signal', 'original signal')
grid minor

%Calculate rmse
rmse = sqrt(sum(original_sig - recovered_sig).^2/length(recovered_sig))




