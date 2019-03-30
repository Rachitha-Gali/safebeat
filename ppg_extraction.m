function [ppg, stft, x_time_domain_signal, peak2] = ppg_extraction(r, g, b);

%This function implements the CHROM method of PPG extraction and returns
%the first and second peak of the FFT signal and the pulse segment

fs_video = 20;
[b_LPF30, a_LPF30] = butter(6, ([30]/60)/(fs_video/2), 'low');
[b_BPF40220,a_BPF40220] = butter(10,([40 220] /60)/(fs_video/2),  'bandpass');

fftlength = length(r);
y_ACDC_R_lpf = filtfilt(b_LPF30,a_LPF30,r); 
y_ACDC_G_lpf = filtfilt(b_LPF30,a_LPF30,g); 
y_ACDC_B_lpf = filtfilt(b_LPF30,a_LPF30,b); 

x = y_ACDC_R_lpf(:);
noverlap  = fftlength/2;
nwind     = fftlength;
k = fix((length(r)-noverlap)/(nwind-noverlap));
T = (nwind-noverlap) : (nwind-noverlap) : (length(r)-noverlap);
[b_BPF40220,a_BPF40220] = butter(10,([60 100] /60)/(fs_video/2),  'bandpass');
STFT_X   = zeros(fftlength/2 + 1, k);
x_method = zeros(size(x));

for ii=1:k 
        % Select stride ii and apply FFT to it
        r_stride = r((-fix(fftlength/2-1):fix(fftlength/2)) + T(ii));
        g_stride = g((-fix(fftlength/2-1):fix(fftlength/2)) + T(ii));
        b_stride = b((-fix(fftlength/2-1):fix(fftlength/2)) + T(ii));
        
        %simpler
        y_ACDC_R = r_stride/mean(r_stride) - 1;
        y_ACDC_G = g_stride/mean(g_stride) - 1;
        y_ACDC_B = b_stride/mean(b_stride) - 1;
        y_ACDC_R = detrend(y_ACDC_R);
        y_ACDC_G = detrend(y_ACDC_G);
        y_ACDC_B = detrend(y_ACDC_B);

%%%%CHROM Method
Rc=1.00*y_ACDC_R;
Gc=0.66667*y_ACDC_G;
Bc=0.50*y_ACDC_B;
X_CHROM=(Rc-Gc);
Y_CHROM=(Rc+Gc-2*Bc);
Xf = filtfilt(b_BPF40220,a_BPF40220, X_CHROM);
Yf = filtfilt(b_BPF40220,a_BPF40220, Y_CHROM);
Nx=std(Xf);
Ny=std(Yf);
alpha_CHROM = Nx/Ny;
x_stride_method = Xf- alpha_CHROM*Yf;

%%%% To find the first and second peak of the FFT signal

X_stride = fft(x_stride_method, fftlength);                        
[val, peak] = max(abs(X_stride));
heart_rate = (peak*(fs_video/2))/(fftlength/2)*60;
X_stride2 =  X_stride(1:fftlength/2);
[val2,sorted2]=sort(abs(X_stride2),'descend');
peak2 = sorted2(:,2);
heart_rate2 = (peak2*(fs_video/2))/(fftlength/2)*60;

x_method((-fix(fftlength/2-1):fix(fftlength/2)) + T(ii)) = ...
            x_method((-fix(fftlength/2-1):fix(fftlength/2)) + T(ii)) + (x_stride_method'.*hann(nwind));
STFT_X(1:(fftlength/2 + 1),ii)  = X_stride(1:(fftlength/2 + 1));

 end
 
    x_time_domain_signal = x_stride_method';
    stft = STFT_X;
    ppg = heart_rate;
    peak2 = heart_rate2;

   