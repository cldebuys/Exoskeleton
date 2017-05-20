
% I1 = P(1);      I2 = P(2);      I3 = P(3); 
% m1 = m(4);      m2 = P(5);      m3 = P(6);      
% C1 = P(7);      C2 = P(8);      C3 = P(9);      
% l1 = P(10);     l2 = P(11);     l3 = P(12);
% lc1 = P(13);    lc2 = P(14);    lc3 = P(15);

P = [I1 I2 I3 m1 m2 m3 C1 C2 C3 l1 l2 l3 lc1 lc2 lc3];
tspan = [0 5];
x0 = [0 0 0 0 0 0];
[t,x] = ode45(@(t,x) odefcn(t,x,P), tspan, x0);