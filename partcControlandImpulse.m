clear, close, clc
%% Variables

 m = .2; %Mass of Pendulum
 M = .5; %Mass of Cart
 b = 0.1; %Dampening
 g = 9.81; %Gravity
 l = .3; %Length of pivot Arm
 I = .006; %Moment of Inertia

 theta  = [3.2 0]; %Initial theta
 x = [0 0]; %Initial x position
 F=0; %initial Force

%% Time 
t=0; %Start Time
tf=10; %End Time
dt=.001; %Change in Time
N=round(tf/dt); %Number of iterations

%% Error
r = pi;
u = 1;
ku = 85; %Ultimate Gain
Pu = .285714; %Ultimate Period 
kp = 1.6*ku; %Proportional Gain
ki = 3.2*ku/Pu; %Integration Gain
kd = 0.2*ku*Pu; %Derivative Gaine
err=0; %Error
errv=0; %Error Vector
errdv=0; %Error Derivative Vector
erriv=0; %Error Integral Vector

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

    %Determine when Impulse happens and for how long
    if (t1>=1)&&(t1<=1.1)
        F=10;
    end

    inputs = [x theta];
    %Ode and Output
    [tout, inputsOut] = ode45(@partaMech, [t1 t2], inputs(end,:).', [], m, M, b, l, g, I, F+u(end));
    t = [t; tout(end)];
    x = [x; inputsOut(end,1:2)];  
    theta = [theta; inputsOut(end,3:4)];
end

%% Plotting
set(0,'DefaultAxesFontSize',14,'DefaultTextFontSize',14,...
    'DefaultAxesFontName','Times','DefaultTextFontName','Times',...
    'DefaultAxesFontWeight','bold','DefaultTextFontWeight','bold',...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',1,...
    'DefaultFigureColor','w','DefaultFigurePosition',[100 100 0.4*[1200 800]]);
Colm = colormap(parula(7));
Col = {Colm(1,:),Colm(2,:),Colm(3,:),Colm(4,:),Colm(5,:),Colm(6,:)};

figure;
plot(t,theta(:,1),'Color',Col{4});
xlabel('Time(s)');
ylabel('Angle');
title('Control Project Part C: Control with Impulse');
