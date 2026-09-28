function gauss_pivot(A, b)
    n = length(b)
    # Trabalhar com cópias para não alterar os argumentos originais
    A = float.(copy(A))
    b = float.(copy(b))
    
    # Eliminação gaussiana com pivoteamento parcial
    for k in 1:n-1
        # Encontrar o pivô (maior valor absoluto na coluna k, a partir da linha k)
        pivo_linha = k
        maior_val = abs(A[k, k])
        for i in k+1:n
            if abs(A[i, k]) > maior_val
                maior_val = abs(A[i, k])
                pivo_linha = i
            end
        end
        
        # Trocar linhas se necessário
        if pivo_linha != k
            A[[k, pivo_linha], :] = A[[pivo_linha, k], :]
            b[[k, pivo_linha]] = b[[pivo_linha, k]]
        end
        
        if A[k, k] == 0
            error("Matriz singular: não é possível resolver o sistema.")
        end
        
        # Eliminação
        for i in k+1:n
            m = A[i, k] / A[k, k]
            A[i, k:n] .-= m .* A[k, k:n]
            b[i] -= m * b[k]
        end
    end
    
    if A[n, n] == 0
        error("Matriz singular: não é possível resolver o sistema.")
    end
    
    # Substituição regressiva
    x = zeros(n)
    x[n] = b[n] / A[n, n]
    for i in n-1:-1:1
        soma = A[i, i+1:n]' * x[i+1:n]
        x[i] = (b[i] - soma) / A[i, i]
    end
    
    return x
end

# Teste
A = [2 1 -1; -3 -1 2; -2 1 2]
b = [8, -11, -3]

x = gauss_pivot(A, b)
println("Solução: ", x)
