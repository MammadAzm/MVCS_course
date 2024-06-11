function [A,B,C,D] = getGilbertRealization(G)
    syms s

    Ghat = G - limit(G,s,inf);

    lcd = Gden_LCD(Ghat);

    rts = solve(lcd==0);
    
    A = [];
    B = [];
    C = [];
    D = [];

    n = 0;
    
    for i=1:length(rts)
        rt = rts(i);
    
        Ri = limit((s - rt)*Ghat, s, rt);
    
        [U, S, V] = svd(Ri, 'econ');
    
        r = rank(Ri);
        n = n + r;
        nn = r;
        
        a = rt*eye(r);
        c = U(:, 1:nn) * S(1:nn, 1:nn);
        b = V(:, 1:nn)';
    
        if i == 1
            A = a;
            B = b;
            C = c;
        else
            A = [A , zeros(size(A,1),r) ; zeros(r, size(A,2)), a];
            B = [B; b];
            C = [C, c];
        end
    end

    D = limit(G,s,inf);
end
