close all;clear all;clc;

SNRdB = 0:1:10 ;
SNR=10.^(SNRdB/10);

BER = 0.5 * erfc(sqrt(SNR));

semilogy (SNRdB, BER,'m-<', 'linewidth' ,2.0);

