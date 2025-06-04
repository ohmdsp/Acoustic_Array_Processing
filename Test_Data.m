%% Simple Acoustical Array Test Data %%
%
N = 8;
LL = 30000 %length of data
t = 1:Ts:LL/Fs+1-Ts;
wn = sqrt(.5)/sqrt(2)*(randn(1,LL)+i*randn(1,LL));
ww = var(wn);
w_ave = sum(abs(wn(:)).^2)/LL;

%theta1 = 245;
%theta2 = 100;
%theta1 = -sin( (1:1:LL)*pi/LL )*180/pi + 100;
theta1 = 100 + 180/pi*cos( (1:1:LL)*pi/LL );        % left curve
theta2 = 250 + 180/pi*cos ( (1:1:LL)*pi/LL );       % right curve
%theta2 = (1:1:LL)*360/LL;
for jj = 1:N
    t_delay1(:,jj) = r/c*cos(pi/180*theta1 - (jj-2)*phi);
    t_delay1(:,1) = 0;
    t_delay2(:,jj) = r/c*cos(pi/180*theta2 - (jj-2)*phi);
    t_delay2(:,1) = 0;
    chs(:,jj) = sqrt(.2)*exp(j*2*pi*250*(t + t_delay1(:,jj)')) + sqrt(.2)*exp(j*2*pi*260*(t + t_delay2(:,jj)'))+ wn; 
end