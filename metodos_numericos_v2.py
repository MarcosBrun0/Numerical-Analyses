"""
metodos_numericos_v2.py

Implementação didática de cinco métodos numéricos para encontrar raízes
(zeros) de funções reais de uma variável:

    1. Método da Bisseção
    2. Método da Falsa Posição (Regula Falsi)
    3. Método do Ponto Fixo (Iteração de Ponto Fixo)
    4. Método de Newton-Raphson
    5. Método da Secante

Diferença em relação à primeira versão:
    Aqui NADA fica fixo em variáveis globais no topo do arquivo. Cada
    método recebe a função f (e, quando necessário, f' ou g) como
    PARÂMETRO. Isso torna as funções reutilizáveis para qualquer
    problema, sem precisar editar o código-fonte. Todos os dados do
    exemplo (a função, a tolerância, os chutes iniciais, etc.) são
    definidos dentro da main().

Convenção usada em todo o arquivo:
    f      -> função cuja raiz queremos encontrar (f(x) = 0), passada como argumento
    tol    -> tolerância (critério de parada baseado no erro)
    max_it -> número máximo de iterações (evita loop infinito)
"""


# ---------------------------------------------------------------------------
# 1. MÉTODO DA BISSEÇÃO
# ---------------------------------------------------------------------------
def bissecao(f, a, b, tol, max_it):
    """
    Encontra uma raiz de f(x) no intervalo [a, b] usando o Método da Bisseção.

    Ideia central:
        Se f(a) e f(b) têm sinais opostos, pelo Teorema do Valor
        Intermediário existe pelo menos uma raiz entre a e b.
        A cada iteração, dividimos o intervalo ao meio e escolhemos a
        metade onde a troca de sinal continua ocorrendo.

    Parâmetros:
        f       -> função cuja raiz buscamos, f(x) = 0
        a, b    -> extremos do intervalo inicial (f(a) e f(b) com sinais opostos)
        tol     -> tolerância desejada para o erro
        max_it  -> número máximo de iterações

    Retorna:
        Aproximação da raiz (float)
    """
    print("\n===== MÉTODO DA BISSEÇÃO =====")

    if f(a) * f(b) >= 0:
        print("Erro: f(a) e f(b) devem ter sinais opostos.")
        return None

    print(f"{'it':>3} | {'a':>10} | {'b':>10} | {'m (meio)':>10} | {'f(m)':>12} | {'erro':>10}")

    m_anterior = a  # usado apenas para calcular o erro na 1ª iteração
    for it in range(1, max_it + 1):
        m = (a + b) / 2
        erro = abs(m - m_anterior)

        print(f"{it:>3} | {a:>10.6f} | {b:>10.6f} | {m:>10.6f} | {f(m):>12.6f} | {erro:>10.6f}")

        if erro < tol or abs(f(m)) < tol:
            print(f"Raiz aproximada: {m:.8f} (após {it} iterações)")
            return m

        # Decide em qual metade do intervalo a raiz continua
        if f(a) * f(m) < 0:
            b = m
        else:
            a = m

        m_anterior = m

    print("Número máximo de iterações atingido.")
    return m


# ---------------------------------------------------------------------------
# 2. MÉTODO DA FALSA POSIÇÃO (REGULA FALSI)
# ---------------------------------------------------------------------------
def falsa_posicao(f, a, b, tol, max_it):
    """
    Encontra uma raiz de f(x) no intervalo [a, b] usando o Método da
    Falsa Posição.

    Ideia central:
        Parecido com a bisseção (também exige troca de sinal em [a, b]),
        mas em vez do ponto médio, traçamos a reta secante ligando
        (a, f(a)) a (b, f(b)) e usamos o ponto onde ela cruza o eixo x
        como nova aproximação.

    Parâmetros:
        f       -> função cuja raiz buscamos, f(x) = 0
        a, b    -> extremos do intervalo inicial (f(a) e f(b) com sinais opostos)
        tol     -> tolerância desejada para o erro
        max_it  -> número máximo de iterações

    Retorna:
        Aproximação da raiz (float)
    """
    print("\n===== MÉTODO DA FALSA POSIÇÃO =====")

    if f(a) * f(b) >= 0:
        print("Erro: f(a) e f(b) devem ter sinais opostos.")
        return None

    print(f"{'it':>3} | {'a':>10} | {'b':>10} | {'x (raiz)':>10} | {'f(x)':>12} | {'erro':>10}")

    x_anterior = a
    for it in range(1, max_it + 1):
        # Interseção da reta secante com o eixo x
        x = a - f(a) * (b - a) / (f(b) - f(a))
        erro = abs(x - x_anterior)

        print(f"{it:>3} | {a:>10.6f} | {b:>10.6f} | {x:>10.6f} | {f(x):>12.6f} | {erro:>10.6f}")

        if erro < tol or abs(f(x)) < tol:
            print(f"Raiz aproximada: {x:.8f} (após {it} iterações)")
            return x

        if f(a) * f(x) < 0:
            b = x
        else:
            a = x

        x_anterior = x

    print("Número máximo de iterações atingido.")
    return x


# ---------------------------------------------------------------------------
# 3. MÉTODO DO PONTO FIXO
# ---------------------------------------------------------------------------
def ponto_fixo(f, g, x0, tol, max_it):
    """
    Encontra uma raiz de f(x) = 0 reescrevendo o problema como x = g(x)
    e iterando x_{n+1} = g(x_n) até convergir.

    Ideia central:
        Se g for uma "contração" perto da raiz (|g'(x)| < 1 nessa
        região), a sequência x0, g(x0), g(g(x0)), ... converge para o
        ponto fixo de g, que é exatamente a raiz de f.

    Parâmetros:
        f       -> função original, usada só para acompanhar f(x_n) na tabela
        g       -> função de iteração x = g(x), construída a partir de f
        x0      -> chute inicial
        tol     -> tolerância desejada para o erro
        max_it  -> número máximo de iterações

    Retorna:
        Aproximação da raiz (float)
    """
    print("\n===== MÉTODO DO PONTO FIXO =====")
    print(f"{'it':>3} | {'x_n':>10} | {'g(x_n)':>10} | {'f(x_n)':>12} | {'erro':>10}")

    x_atual = x0
    for it in range(1, max_it + 1):
        x_prox = g(x_atual)
        erro = abs(x_prox - x_atual)

        print(f"{it:>3} | {x_atual:>10.6f} | {x_prox:>10.6f} | {f(x_atual):>12.6f} | {erro:>10.6f}")

        if erro < tol:
            print(f"Raiz aproximada: {x_prox:.8f} (após {it} iterações)")
            return x_prox

        x_atual = x_prox

    print("Número máximo de iterações atingido (ou o método pode ter divergido).")
    return x_atual


# ---------------------------------------------------------------------------
# 4. MÉTODO DE NEWTON-RAPHSON
# ---------------------------------------------------------------------------
def newton(f, df, x0, tol, max_it):
    """
    Encontra uma raiz de f(x) = 0 usando o Método de Newton-Raphson.

    Ideia central:
        A cada passo, aproximamos f(x) pela reta tangente em x_n e
        usamos a raiz dessa reta como próxima estimativa:
            x_{n+1} = x_n - f(x_n) / f'(x_n)
        Converge rapidamente perto da raiz, mas exige a derivada e
        pode falhar se f'(x_n) for próximo de zero.

    Parâmetros:
        f       -> função cuja raiz buscamos, f(x) = 0
        df      -> derivada de f, f'(x)
        x0      -> chute inicial
        tol     -> tolerância desejada para o erro
        max_it  -> número máximo de iterações

    Retorna:
        Aproximação da raiz (float)
    """
    print("\n===== MÉTODO DE NEWTON-RAPHSON =====")
    print(f"{'it':>3} | {'x_n':>10} | {'f(x_n)':>12} | {'f_prime(x_n)':>14} | {'erro':>10}")

    x_atual = x0
    for it in range(1, max_it + 1):
        fx = f(x_atual)
        dfx = df(x_atual)

        if dfx == 0:
            print("Erro: derivada nula, o método de Newton não pode continuar.")
            return None

        x_prox = x_atual - fx / dfx
        erro = abs(x_prox - x_atual)

        print(f"{it:>3} | {x_atual:>10.6f} | {fx:>12.6f} | {dfx:>14.6f} | {erro:>10.6f}")

        if erro < tol:
            print(f"Raiz aproximada: {x_prox:.8f} (após {it} iterações)")
            return x_prox

        x_atual = x_prox

    print("Número máximo de iterações atingido.")
    return x_atual


# ---------------------------------------------------------------------------
# 5. MÉTODO DA SECANTE
# ---------------------------------------------------------------------------
def secante(f, x0, x1, tol, max_it):
    """
    Encontra uma raiz de f(x) = 0 usando o Método da Secante.

    Ideia central:
        Variação do Método de Newton que evita calcular a derivada
        analiticamente. Usamos a reta secante que passa pelos dois
        últimos pontos (x_{n-1}, x_n):
            x_{n+1} = x_n - f(x_n) * (x_n - x_{n-1}) / (f(x_n) - f(x_{n-1}))
        Precisa de dois chutes iniciais (não exige troca de sinal).

    Parâmetros:
        f       -> função cuja raiz buscamos, f(x) = 0
        x0, x1  -> dois chutes iniciais distintos
        tol     -> tolerância desejada para o erro
        max_it  -> número máximo de iterações

    Retorna:
        Aproximação da raiz (float)
    """
    print("\n===== MÉTODO DA SECANTE =====")
    print(f"{'it':>3} | {'x_(n-1)':>10} | {'x_n':>10} | {'x_(n+1)':>10} | {'f(x_n)':>12} | {'erro':>10}")

    x_ant, x_atual = x0, x1
    for it in range(1, max_it + 1):
        f_ant, f_atual = f(x_ant), f(x_atual)

        if f_atual - f_ant == 0:
            print("Erro: divisão por zero (f(x_n) == f(x_n-1)).")
            return None

        x_prox = x_atual - f_atual * (x_atual - x_ant) / (f_atual - f_ant)
        erro = abs(x_prox - x_atual)

        print(f"{it:>3} | {x_ant:>10.6f} | {x_atual:>10.6f} | {x_prox:>10.6f} | {f_atual:>12.6f} | {erro:>10.6f}")

        if erro < tol:
            print(f"Raiz aproximada: {x_prox:.8f} (após {it} iterações)")
            return x_prox

        # "Desliza" a janela: o par de pontos usado avança
        x_ant, x_atual = x_atual, x_prox

    print("Número máximo de iterações atingido.")
    return x_atual


# ---------------------------------------------------------------------------
# PROGRAMA PRINCIPAL (MAIN)
# ---------------------------------------------------------------------------
# Aqui, tudo o que era "global" no topo do arquivo passa a ser definido
# localmente dentro da main: a função, sua derivada, a função de
# iteração do ponto fixo, a tolerância, o número máximo de iterações e
# os chutes/intervalos iniciais de cada método.
def main():
    # -----------------------------------------------------------------
    # Função de exemplo: f(x) = x^3 - 9x + 3
    # Ela possui três raízes reais; vamos buscar a raiz próxima de
    # x ≈ 0.33, que fica no intervalo [0, 1].
    # -----------------------------------------------------------------
    def f(x):
        """Função original: f(x) = x^3 - 9x + 3"""
        return x**3 - 9 * x + 3

    def df(x):
        """Derivada de f(x): f'(x) = 3x^2 - 9 (usada só pelo Newton)"""
        return 3 * x**2 - 9

    def g(x):
        """
        Função de iteração para o Ponto Fixo, obtida isolando x em
        x^3 - 9x + 3 = 0  =>  x = (x^3 + 3) / 9
        """
        return (x**3 + 3) / 9

    # Critério de parada, definido aqui na main
    tol = 1e-6
    max_it = 100

    print("Buscando raiz de f(x) = x^3 - 9x + 3 no intervalo [0, 1]")
    print(f"Tolerância: {tol} | Máximo de iterações: {max_it}")

    # Cada método recebe a função (e o que mais precisar) como argumento
    raiz_bissecao = bissecao(f, a=0, b=1, tol=tol, max_it=max_it)
    raiz_falsa_posicao = falsa_posicao(f, a=0, b=1, tol=tol, max_it=max_it)
    raiz_ponto_fixo = ponto_fixo(f, g, x0=0.5, tol=tol, max_it=max_it)
    raiz_newton = newton(f, df, x0=0.5, tol=tol, max_it=max_it)
    raiz_secante = secante(f, x0=0, x1=1, tol=tol, max_it=max_it)

    # -----------------------------------------------------------------
    # RESUMO FINAL: comparação das raízes encontradas por cada método
    # -----------------------------------------------------------------
    print("\n===== RESUMO DOS RESULTADOS =====")
    print(f"Bisseção       -> {raiz_bissecao}")
    print(f"Falsa Posição  -> {raiz_falsa_posicao}")
    print(f"Ponto Fixo     -> {raiz_ponto_fixo}")
    print(f"Newton         -> {raiz_newton}")
    print(f"Secante        -> {raiz_secante}")


if __name__ == "__main__":
    main()
