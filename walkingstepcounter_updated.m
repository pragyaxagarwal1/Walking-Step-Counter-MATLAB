clc; clear; close all;

% Simulated accelerometer data (Assuming 100 Hz sampling rate)
fs = 100; % Sampling frequency in Hz
t = 0:1/fs:10; % 10 seconds of data
num_steps = 20; % Approximate number of steps

% Simulate walking steps using a sinusoidal pattern + noise
acc_z = 1 + 0.5 * sin(2 * pi * num_steps * t / max(t)) + 0.2 * randn(size(t));

% Create a figure for both plots
figure;

% Plot raw accelerometer data (Top plot)
subplot(2,1,1); % 2 rows, 1 column, 1st plot
plot(t, acc_z);
title('Simulated Accelerometer Data');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
grid on;

% Apply a low-pass filter to remove high-frequency noise
fc = 3; % Cutoff frequency in Hz (adjust as needed)
[b, a] = butter(2, fc/(fs/2), 'low');
filtered_acc = filtfilt(b, a, acc_z);

% Peak detection for step counting
[peaks, locs] = findpeaks(filtered_acc, 'MinPeakHeight', 1.2, 'MinPeakDistance', fs/2);

% Plot filtered data with detected steps (Bottom plot)
subplot(2,1,2); % 2nd plot
plot(t, filtered_acc, 'b', 'LineWidth', 1.5); hold on;
plot(locs/fs, peaks, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
title('Filtered Accelerometer Data with Detected Steps');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
legend('Filtered Signal', 'Detected Steps');
grid on;

% Display step count
num_detected_steps = length(locs);
disp(['Total Steps Counted: ', num2str(num_detected_steps)]);