% Econometrics PS3 c and d

rng("default")

n = 300;
risk_simulation = zeros(21, 1); % our simulation risk
risk_limit = zeros(21, 1); % risk measure given by the formula in c)

for j = 0:20
    j
    p = 100 + 30 * j;
    gamma = p / n;
    
    % create simulation samples
    beta = ones(p, 1); % True model
    X = randn(n, p); 
    e = randn(n, 1);
    Y = X * beta + e;
    
    if n >= p % OLS
        risk_limit(j+1, 1) = gamma / (1 - gamma); % limit risk given by the formula
        
        % Bias and Variance
        bias = 0;
        variance = inv(X' * X);

        % Risk
        risk = bias + trace(variance);
        risk_simulation(j+1, 1) = risk;
    
    else % p > n
        risk_limit(j+1, 1) = beta' * beta * (gamma - 1) / gamma + 1 / (gamma - 1); % limit risk given by the formula

        [V, D] = eig(X' * X); % eigen values and eigen vectors, V is p*p orthonorm, D is p*p diagonal in ascending order
        D = diag(D);
    
        % Variance
        XtXp = zeros(p, p);
        for i = 1:n
            XtXp = XtXp + (1 / D(p+1-i)) * V(:, (p+1-i)) * V(:, (p+1-i))';
        end
        
        % Bias
        PI = zeros(p, p);
        for i = (n+1):p
            PI = PI + V(:, (p+1-i)) * V(:, (p+1-i))';
        end
        bias = beta' * PI * beta;

        % Risk
        risk = bias + trace(XtXp);
        risk_simulation(j+1, 1) = risk;
    end
end
    
plot(risk_simulation)
hold
plot(risk_limit)



