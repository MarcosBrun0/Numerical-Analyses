function seidel(A, b, x0, tol, maxiter)
    n = length(b)
    A = float.(copy(A))
    b = float.(copy(b))
    x = float.(copy(x0))
    
    for iter in 1:maxiter
        x_anterior = copy(x)
        
        for i in 1:n
            soma = 0.0
            for j in 1:n
                if j != i
                    soma += A[i, j] * x[j]  # usa valores já atualizados quando disponíveis
                end
            end
            
            if A[i, i] == 0
                error("Elemento nulo na diagonal A[$i,$i]: método de Gauss-Seidel falhou.")
            end
            
            x[i] = (b[i] - soma) / A[i, i]
        end
        
        # Critério de parada: maior diferença absoluta entre componentes
        diff = maximum(abs.(x - x_anterior))
        
        if diff < tol
            return x, iter
        end
    end
    
    return x, maxiter
end

# Teste
A = [10 -1 2; -1 11 -1; 2 -1 10]
b = [11, 9, 11]
x0 = [0, 0, 0]

x, iteracoes = seidel(A, b, x0, 1e-8, 100)
println("Solução aproximada: ", x)
println("Número de iterações: ", iteracoes)
