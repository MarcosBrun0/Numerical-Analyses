"""
    bissecao(funcao, limite_inferior, limite_superior; 
             tolerancia=1e-8, max_iteracoes=100, mostrar_passos=false)

Encontra uma raiz de `funcao` no intervalo [limite_inferior, limite_superior]
usando o método da bisseção.

Retorna (raiz_encontrada, numero_de_iteracoes, historico_de_pontos_medios).
"""
function bissecao(funcao, limite_inferior::Real, limite_superior::Real;
  tolerancia::Real=1e-8, max_iteracoes::Int=100, mostrar_passos::Bool=false)

  valor_no_limite_inferior = funcao(limite_inferior)
  valor_no_limite_superior = funcao(limite_superior)

  # Casos em que a raiz já é um dos extremos
  if valor_no_limite_inferior == 0
    return (limite_inferior, 0, [limite_inferior])
  elseif valor_no_limite_superior == 0
    return (limite_superior, 0, [limite_superior])
  end

  # Condição necessária do método: sinais opostos nos extremos
  if sign(valor_no_limite_inferior) == sign(valor_no_limite_superior)
    error("f(a) e f(b) devem ter sinais opostos. " *
          "f($limite_inferior) = $valor_no_limite_inferior, " *
          "f($limite_superior) = $valor_no_limite_superior")
  end

  historico_pontos_medios = Float64[]
  ponto_medio = limite_inferior
  valor_no_ponto_medio = valor_no_limite_inferior

  for iteracao in 1:max_iteracoes
    ponto_medio = (limite_inferior + limite_superior) / 2
    valor_no_ponto_medio = funcao(ponto_medio)
    push!(historico_pontos_medios, ponto_medio)

    if mostrar_passos
      largura_intervalo = limite_superior - limite_inferior
      println("iteração $iteracao: a=$limite_inferior, b=$limite_superior, " *
              "m=$ponto_medio, f(m)=$valor_no_ponto_medio, largura=$largura_intervalo")
    end

    # Critério de parada: f(m) perto de zero OU intervalo já muito estreito
    intervalo_pequeno = (limite_superior - limite_inferior) / 2 < tolerancia
    if abs(valor_no_ponto_medio) < tolerancia || intervalo_pequeno
      return (ponto_medio, iteracao, historico_pontos_medios)
    end

    # Atualiza o intervalo: mantém o sub-intervalo onde há troca de sinal
    if sign(valor_no_ponto_medio) == sign(valor_no_limite_inferior)
      limite_inferior = ponto_medio
      valor_no_limite_inferior = valor_no_ponto_medio
    else
      limite_superior = ponto_medio
      valor_no_limite_superior = valor_no_ponto_medio
    end
  end

  @warn "Número máximo de iterações atingido sem convergência total (tolerância=$tolerancia)."
  return (ponto_medio, max_iteracoes, historico_pontos_medios)
end

# Exemplo 1: raiz de x^3 - x - 2 = 0 (raiz real ≈ 1.5214)
funcao_cubica(x) = x^3 - x - 2
raiz, numero_iteracoes, _ = bissecao(funcao_cubica, 1.0, 2.0;
  tolerancia=1e-10, mostrar_passos=true)
println("\nRaiz encontrada: $raiz em $numero_iteracoes iterações")
println("f(raiz) = $(funcao_cubica(raiz))\n")

# Exemplo 2: raiz de cos(x) - x = 0 (ponto fixo do cosseno, ≈ 0.7391)
funcao_cosseno(x) = cos(x) - x
raiz2, numero_iteracoes2, _ = bissecao(funcao_cosseno, 0.0, 1.0; tolerancia=1e-12)
println("Raiz encontrada: $raiz2 em $numero_iteracoes2 iterações")
println("f(raiz) = $(funcao_cosseno(raiz2))")
