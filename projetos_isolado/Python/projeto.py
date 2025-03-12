import random
import string
import json
import math
import cv2
import numpy as np
import pytesseract
import imutils
import shutil
import sys

# Detecta automaticamente o caminho do Tesseract OCR
tesseract_path = shutil.which("tesseract")
if tesseract_path:
    pytesseract.pytesseract.tesseract_cmd = tesseract_path
else:
    print("❌ Erro: Tesseract OCR não encontrado!")
    print("Baixe e instale em: https://github.com/UB-Mannheim/tesseract/wiki")
    sys.exit(1)

def reconhecer_placa(imagem_path):
    # Carrega a imagem
    imagem = cv2.imread(imagem_path)
    if imagem is None:
        print("❌ Erro: Imagem não encontrada!")
        return

    imagem = imutils.resize(imagem, width=600)

    # Converte para escala de cinza
    img_cinza = cv2.cvtColor(imagem, cv2.COLOR_BGR2GRAY)

    # Aplica filtro para reduzir ruído e manter bordas
    img_filtrada = cv2.bilateralFilter(img_cinza, 11, 17, 17)

    # Detecta bordas
    img_bordas = cv2.Canny(img_filtrada, 30, 200)

    # Encontra contornos
    contornos, _ = cv2.findContours(img_bordas.copy(), cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    contornos = sorted(contornos, key=cv2.contourArea, reverse=True)[:10]  # Pega os 10 maiores contornos

    placa_contorno = None
    for c in contornos:
        perimetro = cv2.arcLength(c, True)
        aprox = cv2.approxPolyDP(c, 0.02 * perimetro, True)
        if len(aprox) == 4:  # Se tiver 4 pontos, pode ser uma placa
            placa_contorno = aprox
            break

    if placa_contorno is None:
        print("❌ Placa não encontrada!")
        return None

    # Cria máscara para isolar a placa
    mascara = np.zeros(img_cinza.shape, np.uint8)
    cv2.drawContours(mascara, [placa_contorno], 0, 255, -1)

    # Recorta a área da placa
    x, y, w, h = cv2.boundingRect(placa_contorno)
    placa_recortada = img_cinza[y:y + h, x:x + w]

    # Aplica limiarização para melhorar a leitura
    placa_final = cv2.adaptiveThreshold(placa_recortada, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)

    # OCR para reconhecer os caracteres
    texto_placa = pytesseract.image_to_string(placa_final, config='--psm 8')

    print(f"📸 Placa reconhecida: {texto_placa.strip()}")

    # Exibe as imagens
    cv2.imshow("Imagem Original", imagem)
    cv2.imshow("Placa Detectada", placa_final)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    return texto_placa.strip()

    # Teste com uma imagem na pasta "imagens"
    # reconhecer_placa("imagens/placa_carro.jpg")


def calculadora_cientifica():
    while True:
        print("\n🧮 Calculadora Científica")
        print("1. Soma")
        print("2. Subtração")
        print("3. Multiplicação")
        print("4. Divisão")
        print("5. Potência")
        print("6. Raiz Quadrada")
        print("7. Logaritmo Natural (base e)")
        print("8. Logaritmo em qualquer base")
        print("9. Seno")
        print("10. Cosseno")
        print("11. Tangente")
        print("12. Arco Seno")
        print("13. Arco Cosseno")
        print("14. Arco Tangente")
        print("15. Fatorial")
        print("16. Exponencial (e^x)")
        print("17. Conversão de Graus para Radianos")
        print("18. Conversão de Radianos para Graus")
        print("19. Sair")

        opcao = input("Escolha uma opção: ")

        if opcao == '19':
            print("🚪 Saindo da Calculadora Científica...")
            break

        try:
            if opcao in ['1', '2', '3', '4', '5']:
                num1 = float(input("Digite o primeiro número: "))
                num2 = float(input("Digite o segundo número: "))
                
                if opcao == '1':
                    print(f"Resultado: {num1 + num2}")
                elif opcao == '2':
                    print(f"Resultado: {num1 - num2}")
                elif opcao == '3':
                    print(f"Resultado: {num1 * num2}")
                elif opcao == '4':
                    if num2 != 0:
                        print(f"Resultado: {num1 / num2}")
                    else:
                        print("❌ Erro: Divisão por zero.")
                elif opcao == '5':
                    print(f"Resultado: {math.pow(num1, num2)}")

            elif opcao == '6':
                num = float(input("Digite o número: "))
                if num >= 0:
                    print(f"Resultado: {math.sqrt(num)}")
                else:
                    print("❌ Erro: Raiz quadrada de número negativo.")

            elif opcao == '7':
                num = float(input("Digite o número: "))
                if num > 0:
                    print(f"Resultado: {math.log(num)}")
                else:
                    print("❌ Erro: Logaritmo de número não positivo.")

            elif opcao == '8':
                num = float(input("Digite o número: "))
                base = float(input("Digite a base do logaritmo: "))
                if num > 0 and base > 0 and base != 1:
                    print(f"Resultado: {math.log(num, base)}")
                else:
                    print("❌ Erro: Entrada inválida para logaritmo.")

            elif opcao == '9':
                angulo = float(input("Digite o ângulo em graus: "))
                print(f"Resultado: {math.sin(math.radians(angulo))}")

            elif opcao == '10':
                angulo = float(input("Digite o ângulo em graus: "))
                print(f"Resultado: {math.cos(math.radians(angulo))}")

            elif opcao == '11':
                angulo = float(input("Digite o ângulo em graus: "))
                print(f"Resultado: {math.tan(math.radians(angulo))}")

            elif opcao == '12':
                valor = float(input("Digite um valor entre -1 e 1: "))
                if -1 <= valor <= 1:
                    print(f"Resultado: {math.degrees(math.asin(valor))} graus")
                else:
                    print("❌ Erro: Valor fora do intervalo permitido.")

            elif opcao == '13':
                valor = float(input("Digite um valor entre -1 e 1: "))
                if -1 <= valor <= 1:
                    print(f"Resultado: {math.degrees(math.acos(valor))} graus")
                else:
                    print("❌ Erro: Valor fora do intervalo permitido.")

            elif opcao == '14':
                valor = float(input("Digite um valor: "))
                print(f"Resultado: {math.degrees(math.atan(valor))} graus")

            elif opcao == '15':
                num = int(input("Digite um número inteiro: "))
                if num >= 0:
                    print(f"Resultado: {math.factorial(num)}")
                else:
                    print("❌ Erro: Fatorial de número negativo não é permitido.")

            elif opcao == '16':
                num = float(input("Digite o número: "))
                print(f"Resultado: {math.exp(num)}")

            elif opcao == '17':
                graus = float(input("Digite o valor em graus: "))
                print(f"Resultado: {math.radians(graus)} radianos")

            elif opcao == '18':
                radianos = float(input("Digite o valor em radianos: "))
                print(f"Resultado: {math.degrees(radianos)} graus")

            else:
                print("⚠️ Opção inválida. Tente novamente.")
        
        except ValueError:
            print("❌ Entrada inválida! Digite apenas números.")

# Para testar a função, basta chamar: calculadora_cientifica()

def agenda_contatos():
    arquivo = "contatos.json"

    # Carregar contatos do arquivo
    try:
        with open(arquivo, "r") as f:
            contatos = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        contatos = []

    while True:
        print("\n📒 Agenda de Contatos")
        print("1. Adicionar Contato")
        print("2. Remover Contato")
        print("3. Listar Contatos")
        print("4. Voltar ao Menu Principal")

        opcao = input("Escolha uma opção: ")

        if opcao == '1':  # Adicionar contato
            nome = input("Nome: ")
            telefone = input("Telefone: ")
            email = input("E-mail: ")

            contatos.append({"nome": nome, "telefone": telefone, "email": email})

            with open(arquivo, "w") as f:
                json.dump(contatos, f, indent=4)

            print("✅ Contato salvo com sucesso!")

        elif opcao == '2':  # Remover contato
            nome = input("Digite o nome do contato a ser removido: ")
            contatos_filtrados = [c for c in contatos if c['nome'] != nome]

            if len(contatos) == len(contatos_filtrados):
                print("❌ Contato não encontrado!")
            else:
                contatos = contatos_filtrados
                with open(arquivo, "w") as f:
                    json.dump(contatos, f, indent=4)
                print("✅ Contato removido!")

        elif opcao == '3':  # Listar contatos
            if not contatos:
                print("📭 Nenhum contato salvo.")
            else:
                print("\n📋 Lista de Contatos:")
                for c in contatos:
                    print(f"🔹 {c['nome']} - 📞 {c['telefone']} - ✉ {c['email']}")

        elif opcao == '4':  # Voltar ao menu principal
            print("🔙 Retornando ao menu principal...")
            break

        else:
            print("⚠️ Opção inválida. Tente novamente.")

# Função Jogo da Velha 
def jogo_velha():
    print("🎮 Jogo da Velha ainda não implementado.")

# Função Conversor de Bases Numéricas
def conversor_bases():
    while True:
        print("\n🔢 Conversor de Bases Numéricas")
        print("1. Converter Decimal para outras bases")
        print("2. Converter Binário para outras bases")
        print("3. Converter Octal para outras bases")
        print("4. Converter Hexadecimal para outras bases")
        print("5. Voltar ao Menu Principal")

        opcao = input("Escolha uma opção: ")

        if opcao == '1':  # Decimal para outras bases
            num = int(input("Digite um número decimal: "))
            print(f"🔹 Binário: {bin(num)[2:]}")
            print(f"🔹 Octal: {oct(num)[2:]}")
            print(f"🔹 Hexadecimal: {hex(num)[2:].upper()}")

        elif opcao == '2':  # Binário para outras bases
            num = input("Digite um número binário: ")
            try:
                dec = int(num, 2)
                print(f"🔹 Decimal: {dec}")
                print(f"🔹 Octal: {oct(dec)[2:]}")
                print(f"🔹 Hexadecimal: {hex(dec)[2:].upper()}")
            except ValueError:
                print("❌ Entrada inválida! Digite apenas 0 e 1.")

        elif opcao == '3':  # Octal para outras bases
            num = input("Digite um número octal: ")
            try:
                dec = int(num, 8)
                print(f"🔹 Decimal: {dec}")
                print(f"🔹 Binário: {bin(dec)[2:]}")
                print(f"🔹 Hexadecimal: {hex(dec)[2:].upper()}")
            except ValueError:
                print("❌ Entrada inválida! Digite apenas números de 0 a 7.")

        elif opcao == '4':  # Hexadecimal para outras bases
            num = input("Digite um número hexadecimal: ")
            try:
                dec = int(num, 16)
                print(f"🔹 Decimal: {dec}")
                print(f"🔹 Binário: {bin(dec)[2:]}")
                print(f"🔹 Octal: {oct(dec)[2:]}")
            except ValueError:
                print("❌ Entrada inválida! Digite apenas números de 0-9 e letras A-F.")

        elif opcao == '5':  # Voltar ao menu principal
            print("🔙 Retornando ao menu principal...")
            break

        else:
            print("⚠️ Opção inválida. Tente novamente.")

# Função Gerenciador de Senhas
def gerenciador_senhas():
    senhas = []  
    
    while True:
        print("\n1. Gerar Senha Manual")
        print("2. Gerar Senha Automática")
        print("3. Login como Admin")
        print("4. Voltar ao Menu Principal")
        
        opcao = input("Escolha uma opção: ")

        if opcao == '1' or opcao == '2':  
            while True:
                nome = input("Digite seu nome: ")
                if any(usuario['nome'] == nome for usuario in senhas):
                    print("❌ Nome já cadastrado! Escolha outro nome.")
                else:
                    break
            
            if opcao == '1':  
                senha = input("Digite sua senha manualmente: ")
            else:  
                tamanho = int(input("Digite o tamanho da senha (padrão 8): ") or 8)
                senha = ''.join(random.choice(string.ascii_letters + string.digits + string.punctuation) for _ in range(tamanho))
                print(f"A senha gerada para {nome} é: {senha}")

            senhas.append({'nome': nome, 'senha': senha})
            print("✅ Senha salva com sucesso!")

        elif opcao == '3':  
            usuario = input("Digite o nome de usuário: ")
            senha = input("Digite a senha: ")

            if usuario == 'admin' and senha == 'admin123':
                print("\n🔐 Acesso de Admin autorizado. Lista de senhas:")
                for usuario in senhas:
                    print(f"Nome: {usuario['nome']}, Senha: {usuario['senha']}")
            else:
                print("❌ Credenciais inválidas!")

        elif opcao == '4':  
            print("🔙 Retornando ao menu principal...")
            break

        else:
            print("⚠️ Opção inválida. Tente novamente.")

def simulador_caixa():
    class CaixaEletronico:
        def __init__(self, saldo_inicial=0):
            self.saldo = saldo_inicial

        def exibir_saldo(self):
            print(f"\n💵 Saldo atual: R$ {self.saldo:.2f}")

        def depositar(self, valor):
            if valor > 0:
                self.saldo += valor
                print(f"✅ Depósito de R$ {valor:.2f} realizado com sucesso!")
            else:
                print("❌ Valor inválido para depósito.")
            self.exibir_saldo()

        def sacar(self, valor):
            if valor > 0 and valor <= self.saldo:
                self.saldo -= valor
                print(f"✅ Saque de R$ {valor:.2f} realizado com sucesso!")
            else:
                print("❌ Saldo insuficiente ou valor inválido.")
            self.exibir_saldo()

        def transferir(self, valor, conta_destino):
            if valor > 0 and valor <= self.saldo:
                self.saldo -= valor
                conta_destino.depositar(valor)
                print(f"✅ Transferência de R$ {valor:.2f} realizada com sucesso!")
            else:
                print("❌ Saldo insuficiente ou valor inválido.")
            self.exibir_saldo()

    conta1 = CaixaEletronico(1000)
    conta2 = CaixaEletronico(500)

    while True:
        print("\n" + "="*30)
        print("🏧 SIMULADOR DE CAIXA ELETRÔNICO")
        print("="*30)
        print("1️⃣  Ver Saldo")
        print("2️⃣  Depositar")
        print("3️⃣  Sacar")
        print("4️⃣  Transferir")
        print("5️⃣  Sair")

        opcao = input("Escolha uma opção: ")

        if opcao == '1':
            conta1.exibir_saldo()
        elif opcao == '2':
            try:
                valor = float(input("Digite o valor para depósito: R$ "))
                conta1.depositar(valor)
            except ValueError:
                print("⚠️ Entrada inválida. Digite um número válido.")
        elif opcao == '3':
            try:
                valor = float(input("Digite o valor para saque: R$ "))
                conta1.sacar(valor)
            except ValueError:
                print("⚠️ Entrada inválida. Digite um número válido.")
        elif opcao == '4':
            try:
                valor = float(input("Digite o valor para transferir: R$ "))
                conta1.transferir(valor, conta2)
            except ValueError:
                print("⚠️ Entrada inválida. Digite um número válido.")
        elif opcao == '5':
            print("🚪 Saindo do simulador... Obrigado por usar nosso sistema!")
            break
        else:
            print("⚠️ Opção inválida. Tente novamente.")



# Função principal para escolher a funcionalidade
def menu_principal():
    while True:
        print("\n📌 Escolha uma opção:")
        print("1. Calculadora")
        print("2. Jogo da Velha")
        print("3. Gerenciador de Senhas")
        print("4. Conversor de Bases Numéricas")
        print("5. Sair")

        escolha = input("Digite o número da opção desejada: ")

        if escolha == '1':
            calculadora_cientifica()
        elif escolha == '2':
            jogo_velha()
        elif escolha == '3':
            gerenciador_senhas()
        elif escolha == '4':
            conversor_bases()
        elif escolha == '5':
            agenda_contatos()
        elif escolha == '6':
            simulador_caixa()         
        elif escolha == '7':
            reconhecer_placa()
        elif escolha == '8':
            print("🚪 Saindo do programa...")
            break
        else:
            print("⚠️ Opção inválida. Tente novamente.")

# Executa o menu inicial
menu_principal()