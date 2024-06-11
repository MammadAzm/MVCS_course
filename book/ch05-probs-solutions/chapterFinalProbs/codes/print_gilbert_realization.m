function print_gilbert_realization(G)
    syms s
    fprintf("Gilbert Realization for G=\n")
    disp(G)

    fprintf("---------------------------------\n")
    [A,B,C,D] = getGilbertRealization(G)

    fprintf("Verifying the Realization: \n")

    pretty(C*inv(s*eye(size(A,1)) - A)*B + D == G)


    fprintf("Based on lemma 5-1, Gilebrt Realization is Irreducible. \n")

end
