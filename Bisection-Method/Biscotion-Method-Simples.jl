function bissecao(f::Function, a, b, max_interation)
  valor_em_a = f(a)
  valor_em_b = f(b)
  tol = 0.01
  if sign(valor_em_a) == sign(valor_em_b)
    error("erro, 'a' e 'b' tem o mesmo sinal")
  end

  historico_ponto_medio = Float64[]
  for iteracao in 1:max_interation
    ponto_medio = (a + b)/2
    valor_no_ponto_medio = f(ponto_medio)
    push!(historico_ponto_medio, ponto_medio)

    intervalo_small_enought = (b - a)/2 < tol
    if abs(valor_no_ponto_medio) < tol || intervalo_small_enought
      return (ponto_medio, iteracao, historico_ponto_medio)
    end
    if sign(valor_no_ponto_medio) == sign(valor_em_a)
      a = ponto_medio
      valor_em_a = valor_no_ponto_medio
    else
      b = ponto_medio
      valor_em_b = valor_no_ponto_medio
    end
  end

  e
end

function main()
  f(x) = x^3
  bissecao(f, -1.0, 2.0, 10)
end


main()
