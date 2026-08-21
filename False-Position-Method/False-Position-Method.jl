"""
    falsa_posicao(funcao, limite_inferior, limite_superior;
                  tolerancia=1e-8, max_iteracoes=100, mostrar_passos=false)

Encontra uma raiz de `funcao` no intervalo [limite_inferior, limite_superior]
usando o método da falsa posição (regula falsi).

Ao contrário da bisseção, que usa o ponto médio geométrico, este método
usa a interseção da reta secante entre os extremos com o eixo x como
estimativa da raiz — geralmente converge mais rápido quando a função
não é muito "assimétrica" perto da raiz.

Retorna (raiz_encontrada, numero_de_iteracoes, historico_de_estimativas).
"""
function falsa_posicao(funcao, limite_inferior::Real, limite_superior::Real;
                        tolerancia::Real=1e-8, max_iteracoes::Int=100, mostrar_passos::Bool=false)

    valor_no_limite_inferior = funcao(limite_inferior)
    valor_no_limite_superior = funcao(limite_superior)

    if valor_no_limite_inferior == 0
        return (limite_inferior, 0, [limite_inferior])
    elseif valor_no_limite_superior == 0
        return (limite_superior, 0, [limite_superior])
    end

    if sign(valor_no_limite_inferior) == sign(valor_no_limite_superior)
        error("f(a) e f(b) devem ter sinais opostos. " *
              "f($limite_inferior) = $valor_no_limite_inferior, " *
              "f($limite_superior) = $valor_no_limite_superior")
    end

    historico_estimativas = Float64[]
    estimativa_raiz = limite_inferior
    valor_na_estimativa = valor_no_limite_inferior

    # Contadores para detectar estagnação de um dos extremos (ver nota abaixo)
    extremo_inferior_repetido = 0
    extremo_superior_repetido = 0

    for iteracao in 1:max_iteracoes
        # Fórmula da interpolação linear (reta secante cruzando o eixo x)
        estimativa_raiz = (limite_inferior * valor_no_limite_superior -
                            limite_superior * valor_no_limite_inferior) /
                           (valor_no_limite_superior - valor_no_limite_inferior)

        valor_na_estimativa = funcao(estimativa_raiz)
        push!(historico_estimativas, estimativa_raiz)

        if mostrar_passos
            println("iteração $iteracao: a=$limite_inferior, b=$limite_superior, " *
                    "x=$estimativa_raiz, f(x)=$valor_na_estimativa")
        end

        if abs(valor_na_estimativa) < tolerancia
            return (estimativa_raiz, iteracao, historico_estimativas)
        end

        if sign(valor_na_estimativa) == sign(valor_no_limite_inferior)
            limite_inferior = estimativa_raiz
            valor_no_limite_inferior = valor_na_estimativa
            extremo_inferior_repetido += 1
            extremo_superior_repetido = 0

            # Método de Illinois: se o mesmo extremo fica "preso" duas vezes
            # seguidas, seu valor de f é reduzido pela metade para forçar
            # o outro lado a se mover também (evita convergência lenta)
            if extremo_inferior_repetido >= 2
                valor_no_limite_superior /= 2
            end
        else
            limite_superior = estimativa_raiz
            valor_no_limite_superior = valor_na_estimativa
            extremo_superior_repetido += 1
            extremo_inferior_repetido = 0

            if extremo_superior_repetido >= 2
                valor_no_limite_inferior /= 2
            end
        end
    end

    @warn "Número máximo de iterações atingido sem convergência total (tolerância=$tolerancia)."
    return (estimativa_raiz, max_iteracoes, historico_estimativas)
end


# ---------------------------------------------------------------------
# Exemplo de uso
# ---------------------------------------------------------------------

# Exemplo 1: raiz de x^3 - x - 2 = 0 (raiz real ≈ 1.5214)
funcao_cubica(x) = x^3 - x - 2
raiz, numero_iteracoes, _ = falsa_posicao(funcao_cubica, 1.0, 2.0;
                                           tolerancia=1e-10, mostrar_passos=true)
println("\nRaiz encontrada: $raiz em $numero_iteracoes iterações")
println("f(raiz) = $(funcao_cubica(raiz))\n")

# Exemplo 2: raiz de cos(x) - x = 0 (ponto fixo do cosseno, ≈ 0.7391)
funcao_cosseno(x) = cos(x) - x
raiz2, numero_iteracoes2, _ = falsa_posicao(funcao_cosseno, 0.0, 1.0; tolerancia=1e-12)
println("Raiz encontrada: $raiz2 em $numero_iteracoes2 iterações")
println("f(raiz) = $(funcao_cosseno(raiz2))")
