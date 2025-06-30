clear
close all
clc

%Create dummy original signals. Use CSVread to import from recovered files
original_sig = 20*randn(1,1000);
%Create a signal that mimics the recovered signal from ESU - it's longer
%and it loops a couple of times 
rx_sig= [randn(1,200) original_sig randn(1,200) original_sig randn(1,200)];
%Add some noise to it
rx_sig = rx_sig + 10*randn(1,length(rx_sig));



xc = xcorr(rx_sig, original_sig); %Cross corellate the two signals
[max_val max_ind] = max(xc); %Find the index that the data starts
max_ind = max_ind+1 - length(rx_sig); %remove the offset from the xcorr

recovered_sig = rx_sig(max_ind:max_ind-1+length(original_sig)); %Recover the signal from the offset

%Calculate sampling frequency and periods
fs = 1e3;
ts = 1/fs;
x_axis = ts*[0:length(recovered_sig)-1]; %create the xaxis
x_axis_rx = ts*[0:length(rx_sig)-1];

%Plot Stuff

%Original signal
figure(1)
plot(x_axis_rx, rx_sig)
title('Received signal')
grid minor

%Crosscorelation
figure(2)
plot(xc)
title('Crosscorrelation of original and recovered signals')
grid minor

%Original vs recovered signal
figure(3)
plot(x_axis,recovered_sig, x_axis, original_sig);
xlabel('Time(sec)')
ylabel('Input (V)')
legend('Recovered Signal', 'Original Signal')
grid minor

%Calculate rmse
rmse = sqrt(sum(original_sig - recovered_sig).^2/length(recovered_sig))




