function print_reducible_realization(G)
    syms s
    fprintf("Reducible Realization for G=\n")
    disp(G)

    fprintf("---------------------------------\n")
    [A,B,C,D] = getReducibleRealization(G)

    fprintf("Verifying the Realization: \n")

    pretty(C*inv(s*eye(size(A,1)) - A)*B + D == G)
end
