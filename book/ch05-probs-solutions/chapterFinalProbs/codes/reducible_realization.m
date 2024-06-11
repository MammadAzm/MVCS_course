%%
syms s
%%

% G = [1/s, 1/(s*(s+1)); s/(s^2-1), s/(s-1)];
G = [-s/(s+1)^2, 1/(s+1); (2*s+1)/(s*(s+1)), 1/(s+1)];

[A,B,C,D] = getReducibleRealization(G)

% print_gilbert_realization(G)
