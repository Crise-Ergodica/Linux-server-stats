# 📊 Linux Server Statistics Analyzer

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-orange.svg)](https://www.kernel.org/)

Script Bash para análise de estatísticas de desempenho de servidores Linux, fornecendo informações detalhadas sobre CPU, memória, disco, processos e mais.

> 🗺️ **Projeto baseado em**: [roadmap.sh - Server Performance Stats](https://roadmap.sh/projects/server-stats)

## 🎯 Características

### Estatísticas Principais
- **Uso Total da CPU**: Análise em tempo real do uso de CPU
- **Uso de Memória**: Estatísticas de RAM incluindo buffers, cache e swap
- **Utilização de Disco**: Informações de todos os filesystems montados
- **Top 5 Processos por CPU**: Ranking dos processos mais intensivos
- **Top 5 Processos por Memória**: Ranking dos processos com maior consumo de RAM

### Estatísticas Adicionais (Stretch Goals)
- Informações do Sistema Operacional (versão, distribuição, kernel)
- Tempo de Atividade (Uptime)
- Carga Média (Load Average)
- Usuários Conectados
- Tentativas de Login Falhas (requer root)
- Estatísticas de Rede
- Status de Serviços

### Interface Visual
- Output colorido com barras de progresso
- Indicadores de status (verde/amarelo/vermelho)
- Layout organizado por seções

## 🚀 Instalação

```bash
# Clone o repositório
git clone https://github.com/Crise-Ergodica/Linux-server-stats.git
cd Linux-server-stats

# Torne o script executável
chmod +x server-stats.sh
```

## 💻 Uso

### Execução Básica
```bash
./server-stats.sh
```

### Com Privilégios Root
Para acessar todas as estatísticas:
```bash
sudo ./server-stats.sh
```

### Salvar Relatório em Arquivo
```bash
./server-stats.sh > report-$(date +%Y%m%d).txt
```

## 🔧 Requisitos

- **Sistema Operacional**: Linux (qualquer distribuição)
- **Shell**: Bash 4.0+
- **Ferramentas opcionais**: `sysstat` (para mpstat), `bc` (para cálculos)

Instalação de dependências opcionais:
```bash
# Ubuntu/Debian
sudo apt-get install sysstat bc

# CentOS/RHEL
sudo yum install sysstat bc
```

## 📊 Exemplo de Output

```
╔═══════════════════════════════════════════════════════════╗
║          Linux Server Statistics Analyzer                 ║
╚═══════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🖥️  CPU Usage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total CPU Usage: 23.45%
Progress:        [███████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]
...
```

## 🎓 Aprendizado

Este projeto ajuda a entender:
- Monitoramento de sistemas Linux e interpretação de métricas
- Bash scripting avançado com funções e formatação
- Sistema de arquivos `/proc` e informações do kernel
- Performance tuning e identificação de gargalos

## 📝 Licença

MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👤 Autor

**Aurora Ergodica**
- GitHub: [@Crise-Ergodica](https://github.com/Crise-Ergodica)
- Email: gdcm10@gmail.com

---

<div align="center">

*"God's in His heaven, all's right with the world!"*

Feito com ❤️ por [Aurora Ergodica](https://github.com/Crise-Ergodica)

</div>
