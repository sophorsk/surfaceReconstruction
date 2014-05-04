% Input is a discrete curve.  Uses approximations to curvature, torsion and
% arclength derivatives from Boutin and returns these values.

function [ kappa, kappa_s, tauVal, tau_sVal ] = compsig( pointVec )
% This function returns kappa, kappas, tau, and taus
%   Detailed explanation goes here

    function d=dist(point1, point2)
        % point1 and point2 are two 3-by-1 colum vectors
        d=sqrt((point1(1)-point2(1))^2+(point1(2)-point2(2))^2+(point1(3)-point2(3))^2);
    end

    function area = heron(a, b, c)
        s=(a+b+c)/2;
        area=sqrt(s*(s-a)*(s-b)*(s-c));
    end

    function k = kap(point1, point2, point3)
        a=dist(point1, point2);
        b=dist(point2, point3);
        c=dist(point1, point3);
        area = heron(a, b, c);
        k=4*area/(a*b*c);
    end
   
    function ks = kaps(point1, point2, point3, point4)
        a=dist(point1, point2);
        b=dist(point2, point3);
        d=dist(point3, point4);
        
        ks = 3*(kap(point2, point3, point4) - kap(point1, point2, point3))/(a+b+d);
    end

    function tau = tauF(point1, point2, point3, point4)
       a = dist(point1, point2);
       b = dist(point2, point3);
       c = dist(point1, point3);
       d = dist(point3, point4);
       e = dist(point2, point4);
       f = dist(point1, point4);
       
       % heron formula
       area_base = heron(a, b, c);
       
       % calculate H
       V = 1/6 * det([point1 - point4, point2 - point4, point3 - point4]);
       H = 3*V/area_base;
       
       tau = 6*H/(d*e*f*kap(point1, point2, point3));
       
    end

    function tau_s = tau_sF(point1, point2, point3, point4, point5, point6)
       
        a = dist(point2, point3);
        b = dist(point3, point4);
        d = dist(point4, point5);
        g = dist(point1, point2);
        
        h = kap(point2, point3, point4)*a*b/2;
        
        tauDiff = tauF(point3, point4, point5, point6) - tauF(point1, point2, point3, point4);
        tauKappa = tauF(point2, point3, point4, point5) * kaps(point2, point3, point4, point5)/(6*kap(point2, point3, point4));
        tau_s = 4*(tauDiff + (2*a + 2*b - 2*d - 3*h + g)*tauKappa)/(2*a + 2*b + 2*d + h + g);
    end

    n=size(pointVec,2);

    kappa=zeros(1,n);
    for t=2:(n-1)
        kappa(t)=kap(pointVec(:,t-1), pointVec(:,t), pointVec(:,t+1));
    end

    kappa_s = zeros(1,n);
    for t = 3:(n-2)
        kappa_s(t) = kaps(pointVec(:, t-1), pointVec(:,t), pointVec(:, t+1), pointVec(:, t+2));
    end

    tauVal = zeros(1, n);
    for t = 3:(n-2)
        tauVal(t) = tauF(pointVec(:, t-1), pointVec(:, t), pointVec(:, t+1), pointVec(:, t+2));
    end

    tau_sVal = zeros(1,n);
    for t = 4:(n-3)
        tau_sVal(t) = tau_sF(pointVec(:, t-2),pointVec(:, t-1), pointVec(:, t), pointVec(:, t+1), pointVec(:, t+2), pointVec(:, t+3));
    end

end

