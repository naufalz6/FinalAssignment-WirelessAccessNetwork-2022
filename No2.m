close all;clear all;clc;

numberbits = 10^5;
SNRdB=0:5:25
SNR=10.^(SNRdB/10);
numbersimulation = 5;

datatx = randi([0,1],1,numberbits);
bpsk = 2*datatx-1;

for i=1:length(SNRdB)
    BERsim = 0;
    count = 0;
    for k=1:numbersimulation
         h = fading2(numberbits, 30, 1/128000);
         n = 1/sqrt(2)*[randn(1,numberbits) + 1i*randn(1,numberbits)];
         fadingchannel = bpsk.*h+10^(-SNRdB(i)/20)*n;
         %receiver
         y=fadingchannel./h;
         %demodulasi
         datarx = real(y)>0;
         %menghitung error
         error= biterr(datatx,datarx);
         BERsim=BERsim+error/numberbits;
         count = count+1;
    end
    BERsimavg(i)=BERsim/count;
end
    


ber_fad_theory = (1/2)*(1-sqrt(SNR./(1+SNR)));


semilogy (SNRdB, ber_fad_theory,'m-<', 'linewidth' ,2.0);
hold on;grid on;
semilogy (SNRdB, BERsimavg,'b-','linewidth',2.0);
legend("BER Theoretical","BER Simulated");
xlabel('Eb/Io (dB)') 
ylabel('Bit Error Rate')
title('BER Performance in Rayleigh Channel');
%}