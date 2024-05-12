clear; clc
% format long g
format short

%% Define Matrices

A = [-1.9,0,-0.68,0,0,0,0,0,0,0.3065;
      0,-8.9,0,0.1812,-3.944,0,0,0,0,0;
     -0.044,0,-2.82,0,0,0,0,0,0,1.223;
      0,-11.48,0,-0.009451,-0.06638,0,0,0,-9.79,0;
      0,2487,0,-0.02051,-1.034,0,0,0,-0.4497,0;
      0,0,0,0.04589,-0.9989,0.0,0,-0.00,2503,0;
      1,0,0.04593,0,0,0,0,0,0,0;
      0,0,1.001,0,0,0,0,0,0,0;
      0,1,0,0,0,0,0,0,0,0;
      11.48,0,-2484,0,0,0,9.79,0,0,-1.054;
    ];

B = [0,100,100;
     1100,0,0;
     0,2.10,100;
     10.0,0,0;
     10.0,0,0;
     0,0,0;
     0,0,0;
     0,0,00;
     0,0,0;
     0,-0.001,-10.2;
    ];

y1 = [0 0 0 0 0 0 1 0 0 0];
C = [y1; circshift(y1,1); circshift(y1,2)];

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

K = ones(numOutputs, numStates);
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
[T,D] = eig(A);

Az = round(inv(T)*A*T, 8);
Bz = round(inv(T)*B,8);
Cz = round(C*T,8);
Dz = D;

%% (Continual) Reduction Method 1

T11 = T([1:6,9,10],[1:6,9,10]);
T12 = T([1:6,9,10],[7,8]);
T21 = T([7,8],[1:6,9,10]);
T22 = T([7,8],[7,8]);

Az1 = Az([1:6,9,10],[1:6,9,10]);
Bz1 = Bz([1:6,9,10],:);
Cz1 = Cz(:, [1:6,9,10]);
Dz1 = Dz([1:6,9,10],[1:6,9,10]);

Az2 = Az([7,8],[7,8]);
Bz2 = Bz([7,8],:);
Cz2 = Cz(:, [7,8]);
Dz2 = Dz([7,8],[7,8]);


%% Reduction Method 2
% T = [];
% for index=1:length(eig_A)
%     eigenvalue = eig_A(index);
%     if index==1
%         if isreal(eigenvalue)
%             T = 1;
%         else
%             T = 0.5*[1 -i;1 i];
%         end
%     else
%         if isreal(eigenvalue)
%             T = [T zeros(size(T,1), 1); zeros(1,size(T,2)) 1];
%         else
%             T = [T zeros(size(T,1), 2); zeros(2,size(T,2)) 0.5*[1 -i;1 i]];
%         end
%     end        
% end
% 
% [P,D] = eig(A);
% Q = inv(P);
% 
% U = P*T;
% V = inv(T)*Q;
















