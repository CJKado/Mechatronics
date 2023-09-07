clear, close, clc
%% Variables

 m = .2;
 M = .5;
 b = 0.1;
 g = 9.81;
 l = .3;
 I = .006;

 theta  = [3.2 0];
 x = [0 0];
 F=0;

%% Time 
t=0;
tf=10;
dt=.001;
N=round(tf/dt);

%% Error
r = pi;
u = 1;
kp = 110;
ki = 0;
kd = 0;
err=0;
errv=0;
errdv=0;
erriv=0;

%% Function

for j=1:N
    %Time Interval
    t1=t(end);
    t2=t1+dt;

    %Error Calculation
    err=r-theta(end,1);
    errd=(err-errv(end))/dt;
    erri=erriv(end)+(err+errv(end))/2*dt;
    errv=[errv; err];
    errdv=[errdv;errd];
    erriv=[erriv;erri];
    u=[u;err*kp+erri*ki+errd*kd];

    inputs = [x theta];
    %Ode and Output
    [tout, inputsOut] = ode45(@partaMech, [t1 t2], inputs(end,:).', [], m, M, b, l, g, I, F+u(end));
    t = [t; tout(end)];
    x = [x; inputsOut(end,1:2)];  
    theta = [theta; inputsOut(end,3:4)];
end

%% Plotting
set(0,'DefaultAxesFontSize',16,'DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultTextFontName','Times',...
    'DefaultAxesFontWeight','bold','DefaultTextFontWeight','bold',...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',1,...
    'DefaultFigureColor','w','DefaultFigurePosition',[100 100 0.4*[1200 800]]);
Colm = colormap(parula(7));
Col = {Colm(1,:),Colm(2,:),Colm(3,:),Colm(4,:),Colm(5,:),Colm(6,:)};

figure;
plot(t,theta(:,1),'Color',Col{2});
xlabel('Time(s)');
ylabel('Position(m)');
title('Control Project Part B');
