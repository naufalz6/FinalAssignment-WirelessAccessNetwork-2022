close all;clear all;clc;

numberbits = 10^5
number_simulation = 5;
SNRdB=0:2:8
SNR=10.^(SNRdB/10);

for i=1:length(SNR)
    BERsim = 0;
    count = 0;
    for j=1:number_simulation
        datatx = randi([0,1],1,numberbits);
        bpsk = 2*datatx-1;
        N = sqrt(0.5*1/SNR(i))*randn(1,numberbits);
        y = bpsk+N;
        datarx=real(y)>0;
        t= biterr (datatx,datarx);
        BERsim= BERsim+  t/numberbits;
        count=count+1;
    end
    BERsimavg (i)= BERsim/count;
    
end

BERth = 0.5 * erfc(sqrt(SNR));

semilogy (SNRdB, BERth,'m-<', 'linewidth' ,2.0);
hold on;grid on;
semilogy (SNRdB, BERsimavg,'b-','linewidth',2.0);
legend("BER Theoretical","BER Simulated");
xlabel('Eb/Io (dB)') 
ylabel('Bit Error Rate')
title('BER Performance in AWGN Channel');
