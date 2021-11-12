function c = cons(cT,T)
    global beta r
    if T == 1;
       c = cT;
    else
       c = cT/(beta*(1+r));
    end

end