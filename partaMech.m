function dataout = partaMech(t,inputs,m, M, b, l, g, I, u)

    %% incoming data
    x=inputs(1:2,1);
    theta=inputs(3:4,1);

    %% Calculating Change in X
    x1 = x(2,1);
    x2 = (u*(I+m*l^2)+m*l*theta(2,1)^2*(I+m*l^2)*sin(theta(1,1))-b*x1*(I+m*l^2)+m^2*g*l^2*sin(theta(1,1))*cos(theta(1,1)))/((M+m)*(I+m*l^2)-m^2*l^2*cos(theta(1,1)).^2);
    xdot = [x1 x2];

    %% Calculating Change in Theta
    theta1 = theta(2,1);
    theta2 = ((u-b*x1+m*l*theta1^2*sin(theta(1,1))+g*tan(theta(1,1))*(M+m))/((M+m)*(I+m*l^2)-m^2*l^2*cos(theta(1,1)).^2))*(-m*l*cos(theta(1,1)));
    thetadot = [theta1 theta2];


    dataout  = [xdot thetadot]';
end