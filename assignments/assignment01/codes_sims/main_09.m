clc; clear; close all

%%

u1 = 60.9532;
u2 = 25.0223;
u3 = 39.2577;
u4 = 44.1767;

open('main_09_simulink.slx')
out = sim('main_09_simulink.slx')

%%

figure

subplot(241)
plot(out.F4, linewidth=2)
hold on
plot(out.F4.Time, 100*ones(1,length(out.F4.Time)), linewidth=2)
plot(out.F4.Time, -out.F4.Data + 100*ones(1,length(out.F4.Time)), linewidth=1.5)
hold off
title("Output F4")
legend("F4", "Nominal", "Error")
grid on

%%

subplot(242)
plot(out.P, linewidth=2)
hold on
plot(out.P.Time, 2700*ones(1,length(out.P.Time)), linewidth=2)
plot(out.P.Time, -out.P.Data + 2700*ones(1,length(out.P.Time)), linewidth=1.5)
hold off
title("Output P")
legend("P", "Nominal", "Error")
grid on

%%

% figure('Name',"Output_YA3 with and without delay")
subplot(2,4,[3 4])
plot(out.YA3, linewidth=1.5)
title("Output Y_A_3 without delay")
legend('Y_A_3 without delay')
grid on
hold on 
plot(out.YA3_delay, linewidth=1.5)
title("Output Y_A_3 with and without delay")
grid on
hold off

hold on
plot(out.YA3.Time, 47*ones(1,length(out.YA3.Time)), linewidth=2)
plot(out.YA3.Time, -out.YA3.Data + 47*ones(1,length(out.YA3.Time)), linewidth=1.5)
hold off

legend('Y_A_3 without delay', 'Y_A_3 with delay', "Nominal", "Error")

%%

subplot(245)
plot(out.VL, linewidth=2)
hold on
plot(out.VL.Time, 44.18*ones(1,length(out.VL.Time)), linewidth=2)
plot(out.VL.Time, -out.VL.Data + 44.18*ones(1,length(out.VL.Time)), linewidth=1.5)
hold off
title("Output VL")
legend("VL", "Nominal", "Error")
grid on

%%

% figure('Name',"Output_YA3 with and without delay")
subplot(2,4,[6 7])
plot(out.YA3, linewidth=1.5)
grid on
hold on
plot(out.YA3_delay, linewidth=1.5)
title("Output Y_A_3 with and without delay | zoomed")
legend('Y_A_3 without delay', 'Y_A_3 with delay')
xlim([0,1])
hold off
%%

u1 = 0;
out =sim('main_09_simulink.slx');

figure

plot(out.F4, linewidth=2)
grid on
hold on
plot(out.P, linewidth=2)
plot(out.YA3, linewidth=2)
plot(out.VL, linewidth=2)
title("outputs while u1=0")
legend('F4','P','Y_A_3','VL','location','best')
hold off

%%

u1 = 60.9532;
u2 = 0;
out =sim('main_09_simulink.slx');

figure

plot(out.F4, linewidth=1.5)
grid on
hold on
plot(out.P, linewidth=1.5)
plot(out.YA3, linewidth=1.5)
plot(out.VL, linewidth=1.5)
title("outputs while u2=0")
legend('F4','P','Y_A_3','VL','location','best')
hold off

%%

u2 = 25.0223;
u3 = 0;
out =sim('main_09_simulink.slx');

figure

plot(out.F4.Data, linewidth=1.5)
grid on
hold on
plot(out.P.Data, linewidth=1.5)
plot(out.YA3.Data, linewidth=1.5)
plot(out.VL.Data, linewidth=1.5)
title("outputs while u3=0")
legend('F4','P','Y_A_3','VL','location','best')
hold off

%%

u3 = 39.2577;
u4 = 0;
out =sim('main_09_simulink.slx');

figure

plot(out.F4.Data, linewidth=1.5)
grid on
hold on
plot(out.P.Data, linewidth=1.5)
plot(out.YA3.Data, linewidth=1.5)
plot(out.VL.Data, linewidth=1.5)
title("outputs while u4=0")
legend('F4','P','Y_A_3','VL','location','best')
hold off

%%

u4 = 44.1767;

g11 = tf([1.7],[0.75 1]);
g14 = tf([-3.4 0],[0.1 1.1 1]);
g21 = tf([45*5.677 45],[2.5 10.25 1]);
g23 = tf([-15 -11.25],[2.5 10.25 1]);
g32 = tf([1.5],[10 1]);
g44 = tf([1],[1 1]);

G = [g11, 0, 0, g14; g21, 0, g23, 0; 0, g32, 0, 0; 0, 0, 0, g44];
U = [u1; u2; u3; u4];
Y = G*U;

%%

G_d = c2d(G, 1, 'zoh');
Y_d = G_d * U;

figure()
step(Y)
hold on
grid on
title("Continuous vs. Discrete Systems")
step(Y_d)

%%

