%Create dummy original signals. Use CSVread to import from recovered files
data = readmatrix('15s_EMG_four_channels.csv');
column1 = data(:,12);
r=size(column1,1);
plot(column1)

