clear all;
close all;
clc;

%read the audio files
[x1,Fs1] = audioread('audio1.wav');
[x2,Fs2] = audioread('audio2.wav');

%fs : the new sample rate for both signals
fs=4*Fs2;

%sampling the signals into fs
[P,Q] = rat(fs/Fs1);
x1_sampled = resample(x1,P,Q);

[P2,Q2] = rat(fs/Fs2);
x2_sampled = resample(x2,P2,Q2);

%amplitude with value 0.1 to make signal one silent.
%fc : the frequency to shift with, equals the max frequency to satisfy the sampling theorem
amp = 0.1;
fc = (fs/2)+1;

%x : sum of the two signals after multipling signal one with A cos[fc.n]
x = x2_sampled;
for i= 1:size(x1_sampled)
          x(i)= x(i)+x1_sampled(i)*cos(fc*i)*amp;
end

y=x;

%the sound after summing the two signals
sound(x,fs)

plot(abs(fft(x)))
%y : multipling the sum of the two signals with cos(fc.n) then multipling it with by the
%inverse of the amplitude to reverse the silence of the signal
for i= 1:size(y)
     y(i) = y(i)*cos(fc*i)*(1/amp);
end


%filtering the signal in the frequency domain 
fft_y=fft(y);

for i= fc:size(y)
fft_y(i) =0;
end

%getting the signal back to the time domain
y=real(ifft(fft_y));

pause(7)

%the sound of the signal after filtering
sound(y, fs)
