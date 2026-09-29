function lu_resolve(A, b)
    n = length(b)
    A = float.(copy(A))
    b = float.(copy(b))
    
    L = zeros(n, n)
    U = zeros(n, n)
    
    # Decomposição LU (Doolittle, sem pivoteamento)
    for i in 1:n
        L[i, i] = 1.0  # diagonal de L é 1
        
        # Calcular linha i de U
        for j in i:n
            soma = 0.0
            for k in 1:i-1
                soma += L[i, k] * U[k, j]
            end
            U[i, j] = A[i, j] - soma
        end
        
        # Calcular coluna i de L (abaixo da diagonal)
        for j in i+1:n
            if U[i, i] == 0
                error("Pivô nulo em U[$i,$i]: decomposição LU sem pivoteamento falhou.")
            end
            soma = 0.0
            for k in 1:i-1
                soma += L[j, k] * U[k, i]
            end
            L[j, i] = (A[j, i] - soma) / U[i, i]
        end
    end
    
    # Substituição direta: Ly = b
    y = zeros(n)
    for i in 1:n
        soma = L[i, 1:i-1]' * y[1:i-1]
        y[i] = b[i] - soma
    end
    
    # Substituição regressiva: Ux = y
    x = zeros(n)
    for i in n:-1:1
        soma = U[i, i+1:n]' * x[i+1:n]
        x[i] = (y[i] - soma) / U[i, i]
    end
    
    return x, L, U
end

# Teste
A = [2 1 1; 4 3 3; 8 7 9]
b = [4, 10, 24]

x, L, U = lu_resolve(A, b)
println("Solução x: ", x)
println("L = ")
display(L)
println("\nU = ")
display(U)
