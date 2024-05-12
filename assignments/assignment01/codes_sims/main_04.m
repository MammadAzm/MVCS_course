clc; clear;

syms t

A = [0, 2, -2; 0, 1, 0; 1, -1, 3]; 

[V_a, D_a] = jordan(A)

expm(A*t)