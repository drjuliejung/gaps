% tests playback
%
% jgm

clear all
close all

shaker = 1;

% shaker data pasted from excel spreadsheet in nPa Canary units from Endevco DW16

f_hz = [10	20	30	40	50	60	70	80	90	100	110	120	130	140	150	160	180	200	220	240	260	280	300	320	340	360	380	400	420	440	460	480	500	520	540	560	580	600	620	640	660	680	700	720	740	760	780	800	820	840	860	880	900	920	940	960	980	1000];

if(shaker == 1)
    R = [43.56435644	163.1305988	384.252711	706.5063649	929.7501179	886.6100896	820.6034889	801.5087223	745.4031117	693.7765205	649.6935408	618.8118812	592.6449788	564.5921735	551.6265912	532.7675625	490.8062235	458.7458746	438.2366808	416.5487977	399.8114097	336.1621876	327.6756247	316.5959453	304.1018388	316.5959453	282.4139557	273.455917	266.1480434	268.9768977	237.1522867	244.2244224	235.5021216	235.0306459	196.369637	199.4342291	199.9057049	198.2555398	206.2706271	190.9948138	185.6199906	198.1848185	194.7194719	193.0693069	188.5902876	180.1272984	169.9434229	177.7699198	188.330976	192.6921264	182.2253654	196.0631777	188.8967468	199.9457803	185.6435644	131.94248	104.0311174	133.9462518];
elseif(shaker == 2)
    R = [36.82225365	135.9264498	314.0028289	568.5997171	788.0716643	817.067421	753.1824611	788.3074022	771.0985384	706.9778406	667.845356	632.484677	605.1390853	578.7364451	556.8128241	542.4328147	504.2432815	467.4681754	450.4950495	428.0999529	413.0127298	363.2720415	323.1966054	308.8165959	296.5582273	283.8283828	270.8628006	257.1900047	248.4677039	251.5322961	254.8326261	244.4601603	230.0801509	231.0231023	211.45686	189.5096653	190.0047148	176.096181	180.0330033	177.5106082	190.9476662	205.0919378	211.45686	209.0994814	199.669967	195.1909477	189.533239	186.9636964	196.1338991	200.1414427	205.5634135	215.9358793	223.4794908	233.6162188	177.9349364	120.3677511	118.5997171	116.3366337];
else
    error('shaker must be 1 or 2')
end

% convert to g based on the following data:
% 1 = 1E-9 Pa/nPa
% 1 = 1.5 mv/Pa from calibration data emailed 5/17/05 by Greg
% 1 = 1g/3.981 mv from DW 16 cal curve.jpg transferred from Michael 

A_CAL = R*(1E-9)*1.5E7/3.981;

% generate time series for one frequency

f_hz_des = input('enter frequency in Hz : ');
[temp, n] = min(abs(f_hz - f_hz_des));

N = 1000;
T = 1/f_hz(n);
t = linspace(0, 10*T, N);
omega = 2*pi*f_hz(n);
a = A_CAL(n)*sin(omega*t);

% compute signal

[signal] = playback(t, a, shaker);

figure
plot(t, signal)
xlabel('time (sec)')
ylabel('signal for shaker (canary Pa)')
title(['frequency = ' num2str(f_hz(n)) ' Hz'])

figure
plot(t, a)
xlabel('time (sec)')
ylabel('desired acceleration (g)')
title(['frequency = ' num2str(f_hz(n)) ' Hz'])
