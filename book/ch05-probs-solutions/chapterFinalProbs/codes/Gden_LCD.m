function lcd = Gden_LCD(G)
    lcd = 1;
    for row=1:size(G,1)
        for col=1:size(G,2)
            g = G(row, col);
            [num, den] = numden(g);
            lcd = lcm(lcd,den);
        end
    end
end