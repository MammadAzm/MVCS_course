function [A,B,C,D] = getReducibleRealization(G)
    syms s

    [outNums, inNums] = size(G);
    qp = outNums*inNums;

    A = [];
    B = [];
    C = [];
    D = [];

    for output=1:outNums
        emptyCount = 0;
        bb = [];
        for input=1:inNums
            g = G(output,input);
            if g == 0
                a = zeros(1);
                b = 0;
                c = 0;
                d = 0;
            else
                [num, den] = numden(g);
                num = sym2poly(num);
                den = sym2poly(den);
                [a, b, c, d] = tf2ss(num, den);
                a = flip(a,1);
                b = flip(b,1);
                c = flip(c,1);
                d = flip(d,1);
                a = flip(a,2);
                b = flip(b,2);
                c = flip(c,2);
                d = flip(d,2);
            end
            
            if output==1 && input==1
                A = a;
            else
                A = [A, zeros(size(A,1), size(a,2)); zeros(size(a,1), size(A,2)), a];
            end
            
            if input==1
                bb = b;
            else
                bb = [bb, zeros(size(bb,1), size(b,2)); zeros(size(b,1), size(bb,2)), b];
            end

            D(output,input) = d;
        end
        if ~isempty(b)
            B = [B; bb];
        end
        
    end
    
    for output=1:outNums
        cc = [];
        for input=1:inNums
            g = G(output,input);
            if g == 0
                a = zeros(1);
                b = 0;
                c = 0;
                d = 0;
            else
                [num, den] = numden(g);
                num = sym2poly(num);
                den = sym2poly(den);
                [a, b, c, d] = tf2ss(num, den);
                a = flip(a,1);
                b = flip(b,1);
                c = flip(c,1);
                d = flip(d,1);
                a = flip(a,2);
                b = flip(b,2);
                c = flip(c,2);
                d = flip(d,2);
            end
            if output==1 && input==1
                cc = c;
            else
                cc = [cc, c];
            end
        end
        if output==1
            C = cc;
        else
            C = [C, zeros(size(C,1), size(cc,2)); zeros(size(cc,1), size(C,2)), cc];
        end
    end
    
end