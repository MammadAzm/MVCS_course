clc; clear;

syms x t

A = [x, 1, 0, 0; 0, x, 1, 0; 0, 0, x, 1; 0, 0, 0, x];

pretty(expm(A*t))