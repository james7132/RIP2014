l = [2 2 1];
q = sym('q', [1 3]);
x = sym('x', [1 3]);
c = cos(q);
s = sin(q);

C = [1, 1]
R = 1

fx1(q) = l(1)*cos(q(1)); 
fy1(q) = l(1)*sin(q(1));
fx2(q) = fx1 + l(2) * cos(q(1) + q(2));
fy2(q) = fy1 + l(2) * sin(q(1) + q(2));
fx3(q) = fx2+ l(3) * cos(q(1) + q(2) + q(3));
fy3(q) = fy2 + l(3) * sin(q(1) + q(2) + q(3));
ft(q) = q(1) + q(2) +  q(3);
f(q) = [fx3; fy3; ft]
    
J = jacobian(f, q)


x_i = [ 2.6, 1.3,  1.0];
x_f = [-1.4, 1.6, -2.0];

U(q) = sqrt((x_i(1) - fx3)^2 + (x_i(2) - fy3)^2 + (x_i(3) - ft)^2) + ...
        1 / (R - sqrt((C(1) - fx1)^ 2 + (C(2) - fy1)^2)) + ...
        1 / (R - sqrt((C(1) - fx2)^ 2 + (C(2) - fy2)^2)) + ...
        1 / (R - sqrt((C(1) - fx3)^ 2 + (C(2) - fy3)^2))

gradU = gradient(U, q)

qVi = InverseKinematics(x_i, l);

delta_x = x_f - x_i;
timeSteps = 1000;
qV = qVi;
dX = delta_x / timeSteps;
dq = zeros(timeSteps, 3);
X1 = zeros(timeSteps, 2);
X2 = zeros(timeSteps, 2);
X3 = zeros(timeSteps, 2);
for i = 1 : timeSteps
    jV = J(qV(1), qV(2), qV(3));
    invJ = inv(jV);
    i
    dq(i,:) = -gradU(qV(1), qV(2), qV(3));
    qV = qV + dq(i,:);
    X1(i,:) = [l(1) * cos(qV(1)), l(1) * sin(qV(1))];
    X2(i,:) = X1(i,:) + [l(2) * cos(qV(1) + qV(2)), l(2) * sin(qV(1) + qV(2))];
    X3(i,:) = X2(i,:) + [l(3) * cos(qV(1) + qV(2) + qV(3)), l(3) * sin(qV(1) + qV(2) + qV(3))];
end
X = [zeros(timeSteps, 1), X1(:,1), X2(:,1), X3(:,1)];
Y = [zeros(timeSteps, 1), X1(:,2), X2(:,2), X3(:,2)];
double(subs(f, q, qV))

figure
while 1
    for i = 1 : timeSteps
        clf
        plot(X3(:,1), X3(:,2), 'Color', 'green')
        line(X(i,:), Y(i,:));
        axis manual
        axis([-2, 3, 0, 3])
        pause(1/600);
    end
end