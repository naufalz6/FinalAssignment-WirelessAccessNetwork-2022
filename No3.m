close all;clear all;clc;

numberbits = 10^5;
SNRdB=0:5:25
SNR=10.^(SNRdB/10);
numbersimulation = 5;
sr=128000.0; % Symbol rate
fd = [15 30 180]
datatx = randi([0,1],1,numberbits);
bpsk = 2*datatx-1;
error = zeros(1,numberbits);
BERsim=zeros(length(fd),length(SNR));
for i=1:length(SNRdB)
    for l=1:length(fd)
        BER = 0;
        for k=1:numbersimulation
            h1 = fading2(numberbits, fd(l), 1/128000);
            h2 = fading2(numberbits, fd(l), 1/128000);
            n1 = 1/sqrt(2)*[randn(1,numberbits) + 1i*randn(1,numberbits)];
            n2 = 1/sqrt(2)*[randn(1,numberbits) + 1i*randn(1,numberbits)];
            fadingchannel1 = bpsk.*h1+10^(-SNRdB(i)/20)*n1;
            fadingchannel2 = bpsk.*h2+10^(-SNRdB(i)/20)*n2;
            for r=1:numberbits
                if (abs(fadingchannel1(r))>=abs(fadingchannel2(r)))
                    y1(r) = fadingchannel1(r);
                    y2(r)= fadingchannel1(r)/h1(r);
                else 
                    y1(r) = fadingchannel2(r);
                    y2(r) = fadingchannel2(r)/h2(r);
                end
            end
            datarx = real(y2)>0;
            error= biterr(datatx,datarx);
            BER=BER+error/numberbits;
        end
        BERsim(l,i)=BER/numbersimulation;
    end

end
ber_fad_theory = (1/2)*(1-sqrt(SNR./(1+SNR)));
hold on;grid on;
semilogy (SNRdB, ber_fad_theory,'m-<', 'linewidth' ,2.0);
semilogy (SNRdB, BERsim(1,:),'b-','linewidth',2.0);
semilogy (SNRdB, BERsim(2,:),'r-','linewidth',2.0);
semilogy (SNRdB, BERsim(3,:),'-','linewidth',2.0);
legend("BER Theoretical","BER Simulated Fd 15","BER Simulated Fd 30","BER Simulated Fd 180");
xlabel('Eb/Io (dB)') 
ylabel('Bit Error Rate')
title('BER Performance in Rayleigh Channel');

