clear; clc
% format long g
format short

%% Define Matrices


A_long =[[-0.5944,0.8008,-9.791,-0.8747,5.077*10^(-5)];
         [-0.744,-7.56,-0.5294,15.72,-0.000939];
         [0,0,0,1,0];
         [1.041,-7.406,0,-15.81,-7.284*10^(-18)];
         [-0.05399,0.9985,-17,0,0]];

B_long = [[0.4669,0];
          [-2.703,0];
          [0,0];
          [-133.7,0];
          [0,0]];

C_long = [[0.9985,0.05399,0,0,0];
          [-003176,0.05874,0,0,0];
          [0,0,0,1,0];
          [0,0,1,0,0];
          [0,0,0,0,-1]];



A_lat = [[-0.8726,0.8789,-16.82,9.791,0];
         [-2.823,-16.09,3.367,0,0];
         [0.702,0.514,-2.775,0,0];
         [0,1,0.05406,-4.088*10^(-24),0];
         [0,0,1.001,-7.573*10^(-23),0]];

B_lat = [[0,5.302];
         [-156.5,-5.008];
         [11.5,-82.04];
         [0,0];
         [0,0]];

C_lat = [[0.05882,0,0,0,0];
         [0,1,0,0,0];
         [0,0,1,0,0];
         [0,0,0,1,0];
         [0,0,0,0,1]];


A = [A_long , zeros(size(A_long,1), size(A_lat,2)); zeros(size(A_lat,1), size(A_long,2)), A_lat];
B = [B_long , zeros(size(B_long,1), size(B_lat,2)); zeros(size(B_lat,1), size(B_long,2)), B_lat];
C = [C_long , zeros(size(C_long,1), size(C_lat,2)); zeros(size(C_lat,1), size(C_long,2)), C_lat];
D = zeros(size(C,1),size(B,2));


%% Some Values

numStates = size(A,1);
numOutputs = size(C,1);
numInputs = size(B,2);

%% Extract Transfer Functions

syms s

G = C*inv(s*eye(numStates) - A)*B;

nums = cell(numOutputs, numInputs);
denoms = cell(numOutputs, numInputs);

for o=1:numOutputs  
    for i=1:numInputs
        [num, denom] = numden(G(o,i));
        nums{o,i} = num;
        denoms{o,i} = denom;
    end
end

%% Form the Open-Loop System

sys_ss = ss(A,B,C,D);

%% Form the closed-loop and Obtain the eigenvalues of both OL and CL

syms s

eig_A = eig(A);

K = ones(numInputs, numStates);
A_prime = A - B*K;

eig_A_prime = eig(A_prime);


%% Controllability Check

U = ctrb(A,B);
rankU = rank(U);

%% Controller Desing
Q = eye(numStates);
R = eye(numInputs);

K_lqr = lqr(A, B, Q, R);

A_lqr = A-B*K_lqr;

sys_lqr = ss(A_lqr, B, C, D);

%% Singular Values

[UU,SS,VV] = svd(A);

%% Reduction Method 1
[T,~] = eig(A);

Az = round(inv(T)*A*T, 8);
Bz = round(inv(T)*B,8);
Cz = round(C*T,8);
Dz = D;

%% (Continual) Reduction Method 1

T11 = T([1,4,5,6,8,9,10],[1,4,5,6,8,9,10]);
T12 = T([1,4,5,6,8,9,10],[2,3,7]);
T21 = T([2,3,7],[1,4,5,6,8,9,10]);
T22 = T([2,3,7],[2,3,7]);

Az1 = Az([1,4,5,6,8,9,10],[1,4,5,6,8,9,10]);
Bz1 = Bz([1,4,5,6,8,9,10],:);
Cz1 = Cz(:, [1,4,5,6,8,9,10]);
Dz1 = Dz([1,4,5,6,8,9,10],:);

Az2 = Az([2,3,7],[2,3,7]);
Bz2 = Bz([2,3,7],:);
Cz2 = Cz(:, [2,3,7]);
Dz2 = Dz([2,3,7],:);

Ar = T11*Az1*inv(T11);
Br = T11*(Az1*inv(11)*T12*inv(Az2)*Bz2+Bz1);
F = T21*inv(T11);
E = (F*T12-T22)*inv(Az2)*Bz2;
Cr = Cz1 + Cz2*F;
Dr = Cz2*E;

%% Reduction Method 2
T = [];
flag = false;
for index=1:length(eig_A)
    if index == 2
        continue
    elseif index == 3
        continue
    elseif index == 7
        continue
    end
    if flag == true
        flag = false;
        continue
    end
    eigenvalue = eig_A(index);
    if index==1
        if isreal(eigenvalue)
            T = 1;
        else
            T = 0.5*[1 -i;1 i];
            flag = true;
        end
    else
        if isreal(eigenvalue)
            T = [T zeros(size(T,1), 1); zeros(1,size(T,2)) 1];
        else
            T = [T zeros(size(T,1), 2); zeros(2,size(T,2)) 0.5*[1 -i;1 i]];
            flag = true;
        end
    end        
end

[P,~] = eig(A);
Q = inv(P);

% P = P([1,4,5,6,8,9,10],[1,4,5,6,8,9,10]);
% Q = Q([1,4,5,6,8,9,10],[1,4,5,6,8,9,10]);

P = P([1,4,5,6,8,9,10],[1,4,5,6,8,9,10]);
Q = Q([1,4,5,6,8,9,10],[1,4,5,6,8,9,10]);

U = P*T;
V = inv(T)*Q;

gamma = diag(eig_A([1,4,5,6,8,9,10]));

Azz = V*gamma*U;
Bzz = V*B([1,4,5,6,8,9,10],:);
Czz = C(:, [1,4,5,6,8,9,10])*U;
Dzz = zeros(size(Czz,1),size(Bzz,2));;


eig_Azz = eig(Azz);










