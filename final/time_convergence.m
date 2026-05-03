cl_coarse = load('cl_coarse.txt');
cl_medium = load('cl_medium.txt');
cl_fine   = load('cl_fine.txt');

cd_coarse = load('cd_coarse.txt');
cd_medium = load('cd_medium.txt');
cd_fine   = load('cd_fine.txt');

dt_coarse = 0.05;
dt_medium = 0.025;
dt_fine   = 0.0125;

t_coarse = (0:length(cl_coarse)-1) * dt_coarse;
t_medium = (0:length(cl_medium)-1) * dt_medium;
t_fine   = (0:length(cl_fine)-1)   * dt_fine;

N = 500; % last 500 points from each

figure;
plot((1:N)*dt_coarse, cl_coarse(end-N+1:end), 'b-'); hold on;
plot((1:N)*dt_medium, cl_medium(end-N+1:end), 'r-');
plot((1:N)*dt_fine,   cl_fine(end-N+1:end),   'g-');
xlabel('Time');
ylabel('C_l');
legend('\Delta t = 0.05', '\Delta t = 0.025', '\Delta t = 0.0125');
title('Lift Coefficient vs Time - Periodic State');
grid on;
ylim([-0.7 0.7]);

% find period using zero crossings for each
% use dt_fine as example
cl = cl_fine(end-2000:end);
dt = dt_fine;
t  = (0:length(cl)-1)*dt;

% find zero crossings going upward
zc = find(diff(sign(cl)) > 0);
periods = diff(t(zc));
T_avg = mean(periods);
St_fine = 1/T_avg;  % St = f*D/U = 1/T since D=1, U=1

% repeat for medium and coarse
cl = cl_medium(end-2000:end); dt = dt_medium;
t  = (0:length(cl)-1)*dt;
zc = find(diff(sign(cl)) > 0);
T_avg = mean(diff(t(zc)));
St_medium = 1/T_avg;

cl = cl_coarse(end-2000:end); dt = dt_coarse;
t  = (0:length(cl)-1)*dt;
zc = find(diff(sign(cl)) > 0);
T_avg = mean(diff(t(zc)));
St_coarse = 1/T_avg;

fprintf('St coarse: %.4f\n', St_coarse);
fprintf('St medium: %.4f\n', St_medium);
fprintf('St fine:   %.4f\n', St_fine);

dts = [0.05, 0.025, 0.0125];
Cd_vals = [3.60, 3.54, 3.43];
St_vals = [0.1618, 0.1669, 0.1690];

figure;
subplot(1,2,1);
plot(dts, Cd_vals, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('\Delta t');
ylabel('C_d');
title('Drag Coefficient vs \Delta t');
grid on;

subplot(1,2,2);
plot(dts, St_vals, 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('\Delta t');
ylabel('Strouhal Number');
title('Strouhal Number vs \Delta t');
grid on;

sgtitle('Time Convergence Study - Re = 100, Vertex-Up Triangle');

