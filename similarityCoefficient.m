% This method calculates the signature similarity coefficient
% The coefficient is between [0, 1]

function score = similarityCoefficient(pointVec1, pointVec2)
    
    function generatePoint = generator(pointVec1, pointVec2)
        [kappa1, kappa_s1, tau1, tau_s1] = compsig(pointVec1);
        [kappa2, kappa_s2, tau2, tau_s2] = compsig(pointVec2);
        
        generatePoint = {[kappa1; kappa_s1; tau1; tau_s1]; [kappa2; kappa_s2; tau2; tau_s2]};
    end    

    % Calculating the scale of comparison D
    % using the method mentioned in Extensions for Invariant Signature
    % for Object recognition
    function [D, kappa1, tau1, kappa2, tau2] = scaleComparison(pointVec1, pointVec2)
        [kappa1, kappa_s1, tau1, tau_s1] = compsig(pointVec1);
        [kappa2, kappa_s2, tau2, tau_s2] = compsig(pointVec2);
        
        max_kappa1 = max(kappa1);
        max_kappa2 = max(kappa2);
        min_kappa1 = min(kappa1);
        min_kappa2 = min(kappa2);
        
        max_tau1 = max(tau1);
        max_tau2 = max(tau2);
        min_tau1 = min(tau1);
        min_tau2 = min(tau2);
        
        d_kappa = max(max_kappa1 - min_kappa1, max_kappa2 - min_kappa2);
        d_tau = max(max_tau1 - min_tau1, max_tau2 - min_tau2);
        
        % right now we just take max of d_kappa and d_tau
        D = max(d_kappa, d_tau);
    end

    % This function measures the separation score between two points
    % D(scale of comparison) is set to 1 for now, need to be changed later
    function d = separation(point1, point2, D)
              
       pointDiff = norm(point1 - point2);
       
       if pointDiff < D
           d = pointDiff/(D - pointDiff);
       else
           d = Inf;
       end
    end

    % This function measures the strength of correspondance
    % gamma is set to 1, and epsilon is set to 0.00001 for now, change later
    function h = strength(point1, point2, D)
        gamma = 0.5;
        epsilon = power(10, -5);
        separation = separation(point1, point2, D);
        if separation < Inf
            h = 1/(separation^gamma + epsilon);
        else
            h = 0;
        end
    end

    % C1 is set to 1 for now, change later
    function r = rescaling(t)
        C1 = 5;
        r = t./(t + C1);
    end
    
    % The similarity score of the two signatures
    function score = computation(pointVec1, pointVec2)
        
        allPoints = generator(pointVec1, pointVec2);
        signature1 = allPoints{1};
        signature2 = allPoints{2};

        [D, kappa1, tau1, kappa2, tau2] = scaleComparison(pointVec1, pointVec2);
        
        dimension1 = size(signature1, 2);
        dimension2 = size(signature2, 2);
        
        % Approach 3 in Extensions for Invariant Signatures for Object
        % Recognization
        total = 0.0;
        first_score = 0.0;
        for i = 1:dimension1
            for j = 1:dimension2
                total = total + strength(signature1(:, i), signature2(:, j), D);
            end
            first_score = first_score + rescaling(total);
            total = 0.0;
        end
        first_score = first_score/dimension1;
        
        total = 0.0;
        second_score = 0.0;
        for i = 1:dimension2
            for j = 1:dimension1
                total = total + strength(signature1(:, j), signature2(:, i), D);
            end
            second_score = second_score + rescaling(total);
            total = 0.0;
        end
        second_score = second_score/dimension2;

        score = min(first_score, second_score);

    end

    score = computation(pointVec1, pointVec2);

end