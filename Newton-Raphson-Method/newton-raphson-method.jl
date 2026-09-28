function newton(f, df, x0, tol, maxiter)
    x_anterior = x0
    for iter in 1:maxiter
        fx = f(x_anterior)
        dfx = df(x_anterior)
        
        if dfx == 0
            error("Derivada nula em x = $x_anterior. Método falhou.")
        end
        
        x_novo = x_anterior - fx / dfx
        
        if abs(x_novo - x_anterior) < tol
            return x_novo, iter
        end
        
        x_anterior = x_novo
    end
    
    return x_anterior, maxiter
end

# Teste
f(x) = x^3 - x - 2
df(x) = 3x^2 - 1

raiz, iteracoes = newton(f, df, 1.5, 1e-8, 100)
println("Raiz aproximada: ", raiz)
println("Número de iterações: ", iteracoes)
