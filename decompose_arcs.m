% This function decomposes a signature curve into bivertex arcs.

function bivertex_curve = decompose_arcs(curve)
    
    % store all bivertex arcs and put them in the cell array
    bivertex_curve = {};
        
    [kappa, kappa_s, tau, tau_s] = compsig(curve);
         
    d1 = size(kappa, 2);
    
    j = 1;
    k = 1;
    for i=1:(d1 - 1)
        bivertex_curve{j, 1}(:, k) = curve(:, i);
        if (kappa_s(i)*kappa_s(i + 1) < 0)
            j = j + 1;
            k = 1;
        else
            k = k + 1;
        end
    end
end