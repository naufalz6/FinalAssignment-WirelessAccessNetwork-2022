close all;clear all;clc;

numberbits = 10^5
number_simulation = 5;
SNRdB=0:2:8
SNR=10.^(SNRdB/10);

for i=1:length(SNR)
    for j=1:number_simulation
        datatx = randi([0,1],1,numberbits);
        bpsk = 2*datatx-1;
        N = sqrt(0.5*1/SNR(i))*randn(1,numberbits);
        y = bpsk+N;
        datarx=heaviside(sign(y));
        t= biterr (datatx,datarx);
    end
    BERsim(i)= t/numberbits;
    
end

BERth = 0.5 * erfc(sqrt(SNR));

semilogy (SNRdB, BERth,'m-<', 'linewidth' ,2.0);
hold on
semilogy (SNRdB, BERsim,'b-','linewidth',2.0);
legend("BER Theoretical","BER Simulated");
