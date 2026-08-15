# The Legend of Zelda (MIPS Assembly)

Este é um jogo inspirado no clássico The Legend of Zelda e desenvolvido em Assembly MIPS, utilizando o simulador MARS. O projeto foi criado como parte da disciplina Arquitetura de Computadores, para praticar programação de baixo nível, e explora habilidades como: uso de manipulação de memória; E/S via Bitmap Display e MMIO (Memory-mapped I/O); além da lógica de programação por trás de um jogo.

O jogo apresenta uma luta entre o protagonista Link e dois NPCs.

# Como executar
Confira as instruções para rodar o jogo:

## Pré-requisitos

- Instale o [Java Runtime Environment (JRE)](https://www.java.com/download/).
- Faça download do [MARS MIPS Simulator](https://computerscience.missouristate.edu/mars-mips-simulator.htm).
- Faça também o download deste repositório.

## Configuração do Ambiente

1. Abra o **MARS**.
2. Vá em **File > Open** e selecione o arquivo `jogo.asm`.
3. Abra as ferramentas necessárias em **Tools**:

- **Bitmap Display**
- **Keyboard and Display MMIO Simulator**

### Configuração do Bitmap Display

Configure o **Bitmap Display** exatamente com os valores abaixo. Assim, os gráficos serão renderizados corretamente:

| Configuração                 | Valor                      |
| ---------------------------- | -------------------------- |
| **Unit Width in Pixels**     | 2                          |
| **Unit Height in Pixels**    | 2                          |
| **Display Width in Pixels**  | 512                        |
| **Display Height in Pixels** | 256                        |
| **Base Address for Display** | `0x10010000` (static data) |

> **Importante:** Clique no botão **"Connect to MIPS"** em ambas as ferramentas (Bitmap Display e Keyboard MMIO), após configurar.

## Executando o Jogo

1. Vá em _Run > Assemble_ 
2. Vá em _Run > Go_

# Controles

Use as teclas abaixo na janela do **MMIO Simulator**:

- Espaço: inicia o jogo. Também reinicia o jogo após o fim da partida;
- D: Direita;
- W: Cima;
- S: Baixo;
- A: Esquerda;
- J: Ataque com a espada.

> Jogo desenvolvido por Louise Chacon e Kátia Virgínia.