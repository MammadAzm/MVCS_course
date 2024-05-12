clc; clear;

A = [0, 0, 0; 1, 0, 2; 0, 1, 1];
[V_a, D_a] = jordan(A)

B = [-1, 1, 1; 0, 4, -13; 0, 1, 0];
[V_b, D_b] = jordan(B)