function secante(f, x0, x1, tol, maxiter)
    x_ant = x0
    x_atual = x1
    
    for iter in 1:maxiter
        f_ant = f(x_ant)
        f_atual = f(x_atual)
        
        if f_atual == f_ant
            error("Divisão por zero: f(x_atual) = f(x_ant) em x = $x_atual")
        end
        
        x_novo = x_atual - f_atual * (x_atual - x_ant) / (f_atual - f_ant)
        
        if abs(x_novo - x_atual) < tol
            return x_novo, iter
        end
        
        x_ant = x_atual
        x_atual = x_novo
    end
    
    return x_atual, maxiter
end

# Teste
f(x) = x^3 - x - 2

raiz, iteracoes = secante(f, 1.0, 2.0, 1e-8, 100)
println("Raiz aproximada: ", raiz)
println("Número de iterações: ", iteracoes)
