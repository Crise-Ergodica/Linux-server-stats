# 📊 Linux Server Statistics Analyzer

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-orange.svg)](https://www.kernel.org/)

Um script Bash completo e profissional para análise de estatísticas de desempenho de servidores Linux. Fornece informações detalhadas sobre CPU, memória, disco, processos e muito mais, tudo com uma interface colorida e fácil de ler.

## 🎯 Características

### 📋 Estatísticas Principais

- **Uso Total da CPU**: Análise em tempo real do uso de CPU com breakdown por núcleo
- **Uso de Memória**: Estatísticas detalhadas de RAM incluindo buffers, cache e swap
- **Utilização de Disco**: Informações completas de todos os filesystems montados
- **Top 5 Processos por CPU**: Ranking dos processos mais intensivos em processamento
- **Top 5 Processos por Memória**: Ranking dos processos com maior consumo de RAM

### ⭐ Estatísticas Adicionais

- **Informações do Sistema Operacional**: Versão, distribuição, kernel e arquitetura
- **Tempo de Atividade (Uptime)**: Quanto tempo o servidor está rodando
- **Carga Média (Load Average)**: Carga do sistema em 1, 5 e 15 minutos
- **Usuários Conectados**: Lista de sessões ativas de usuários
- **Tentativas de Login Falhas**: Monitoramento de segurança (requer privilégios root)
- **Estatísticas de Rede**: Interfaces ativas e conexões estabelecidas
- **Status de Serviços**: Verificação do estado de serviços críticos

### 🎨 Interface Visual

- Output colorido e formatado para fácil leitura
- Barras de progresso visuais para CPU e memória
- Indicadores de status com cores (verde/amarelo/vermelho)
- Layout organizado em seções bem definidas
- Símbolos Unicode para melhor apresentação visual

## 🚀 Instalação

### Método 1: Clone do Repositório

```bash
# Clone o repositório
git clone https://github.com/Crise-Ergodica/Linux-server-stats.git

# Entre no diretório
cd Linux-server-stats

# Torne o script executável
chmod +x server-stats.sh
```

### Método 2: Download Direto

```bash
# Download do script
wget https://raw.githubusercontent.com/Crise-Ergodica/Linux-server-stats/main/server-stats.sh

# Torne executável
chmod +x server-stats.sh
```

## 💻 Uso

### Execução Básica

```bash
./server-stats.sh
```

### Redirecionando para Arquivo

Para salvar o relatório em um arquivo:

```bash
./server-stats.sh > server-report-$(date +%Y%m%d-%H%M%S).txt
```

### Execução com Privilégios Root

Para acessar todas as estatísticas de segurança:

```bash
sudo ./server-stats.sh
```

### Agendamento com Cron

Para executar automaticamente a cada hora:

```bash
# Abra o crontab
crontab -e

# Adicione a linha:
0 * * * * /caminho/para/server-stats.sh >> /var/log/server-stats.log 2>&1
```

## 📊 Exemplo de Output

```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║          Linux Server Statistics Analyzer                 ║
║              Performance Monitoring Tool                  ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

ℹ Report Generated: 2025-12-02 09:13:45 -03

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 System Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

OS Name:         Ubuntu
OS Version:      22.04.3 LTS (Jammy Jellyfish)
OS ID:           ubuntu
Kernel Version:  6.2.0-39-generic
Architecture:    x86_64
Hostname:        production-server-01

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⏱️  Uptime & Load Average
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

System Uptime:   15 days, 7 hours, 23 minutes
Load Average:    0.52 0.48 0.45 (1min, 5min, 15min)
CPU Cores:       8
Load Status:     Normal (6.50% of capacity)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🖥️  CPU Usage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total CPU Usage: 23.45%
Progress:        [███████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]

...
```

## 🔧 Requisitos

### Requisitos Mínimos

- **Sistema Operacional**: Linux (qualquer distribuição)
- **Shell**: Bash 4.0 ou superior
- **Permissões**: Usuário normal (algumas features requerem root)

### Ferramentas Necessárias

A maioria das ferramentas já vem instalada por padrão. Opcionalmente:

```bash
# Ubuntu/Debian
sudo apt-get install sysstat bc

# CentOS/RHEL
sudo yum install sysstat bc

# Arch Linux
sudo pacman -S sysstat bc
```

- **sysstat**: Para estatísticas detalhadas por núcleo de CPU (comando `mpstat`)
- **bc**: Para cálculos de ponto flutuante (geralmente já instalado)

## 📁 Estrutura do Script

```
server-stats.sh
├── Banner e Cabeçalho
├── Funções de Utilidades
│   ├── print_header()       # Cabeçalhos de seção
│   └── print_banner()       # Banner inicial
├── Funções de Análise
│   ├── get_os_info()        # Informações do SO
│   ├── get_uptime_info()    # Uptime e carga
│   ├── get_cpu_usage()      # Uso de CPU
│   ├── get_memory_usage()   # Uso de memória
│   ├── get_disk_usage()     # Uso de disco
│   ├── get_top_cpu_processes()    # Top processos CPU
│   ├── get_top_memory_processes() # Top processos memória
│   ├── get_network_info()   # Estatísticas de rede
│   ├── get_user_info()      # Usuários conectados
│   ├── get_failed_logins()  # Tentativas falhas
│   └── get_service_status() # Status de serviços
└── main()                    # Função principal
```

## 🎓 Casos de Uso

### 1. Monitoramento de Servidor

Verifique rapidamente a saúde do servidor antes de fazer deploy:

```bash
./server-stats.sh
```

### 2. Debugging de Performance

Identifique processos problemáticos consumindo recursos:

```bash
./server-stats.sh | grep -A 10 "Top 5 Processes"
```

### 3. Auditoria de Segurança

Verifique tentativas de login falhas:

```bash
sudo ./server-stats.sh | grep -A 10 "Failed Login"
```

### 4. Relatórios Periódicos

Gere relatórios automaticamente com logs rotativos:

```bash
# Script de exemplo para relatório diário
#!/bin/bash
DATE=$(date +%Y-%m-%d)
REPORT_DIR="/var/log/server-reports"
mkdir -p $REPORT_DIR
./server-stats.sh > "$REPORT_DIR/report-$DATE.txt"
```

## 🛡️ Segurança

### Permissões Necessárias

- **Usuário Normal**: A maioria das estatísticas funciona sem privilégios especiais
- **Root**: Necessário para:
  - Leitura de logs de autenticação (`/var/log/auth.log` ou `/var/log/secure`)
  - Algumas estatísticas detalhadas de processos
  - Verificação de status de certos serviços

### Logs Sensíveis

O script **NÃO** expõe:
- Senhas ou credenciais
- Chaves privadas
- Conteúdo de arquivos do sistema
- Informações de usuários além de sessões ativas

## 🐛 Troubleshooting

### Problema: "Permission denied" ao executar

**Solução**:
```bash
chmod +x server-stats.sh
```

### Problema: Cores não aparecem corretamente

**Solução**: Verifique se seu terminal suporta cores ANSI. Teste com:
```bash
echo -e "\033[0;32mGreen\033[0m"
```

### Problema: "mpstat: command not found"

**Solução**: Instale o pacote sysstat:
```bash
sudo apt-get install sysstat  # Ubuntu/Debian
sudo yum install sysstat      # CentOS/RHEL
```

### Problema: "bc: command not found"

**Solução**: Instale bc:
```bash
sudo apt-get install bc  # Ubuntu/Debian
sudo yum install bc      # CentOS/RHEL
```

## 📚 Aprendizado

Ao usar e estudar este script, você aprenderá sobre:

- **Monitoramento de Sistemas Linux**: Como ler e interpretar métricas de sistema
- **Bash Scripting Avançado**: Funções, formatação, manipulação de strings
- **Sistema de Arquivos /proc**: Como o kernel expõe informações do sistema
- **Performance Tuning**: Identificação de gargalos de performance
- **Debugging de Servidores**: Técnicas para diagnóstico de problemas

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fazer fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Add: Nova funcionalidade'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abrir um Pull Request

### Ideias para Contribuição

- [ ] Adicionar suporte para containers Docker
- [ ] Criar modo de output JSON para integração com ferramentas
- [ ] Adicionar alertas baseados em thresholds configuráveis
- [ ] Implementar histórico de métricas
- [ ] Criar dashboard web para visualização

## 📝 Changelog

### [1.0.0] - 2025-12-02

#### Adicionado
- Script completo `server-stats.sh` com todas as funcionalidades principais
- Análise de CPU com breakdown por núcleo
- Estatísticas detalhadas de memória (RAM + Swap)
- Monitoramento de uso de disco por filesystem
- Top 5 processos por CPU e memória
- Informações de sistema operacional e uptime
- Carga média do sistema
- Estatísticas de rede
- Lista de usuários conectados
- Monitoramento de tentativas de login falhas
- Verificação de status de serviços críticos
- Interface colorida e barras de progresso visuais
- README completo com documentação detalhada

## 📄 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👤 Autor

**Aurora Ergodica**

- GitHub: [@Crise-Ergodica](https://github.com/Crise-Ergodica)
- Email: gdcm10@gmail.com

## 🙏 Agradecimentos

- Comunidade Linux pela documentação excelente
- Todos os contribuidores de ferramentas open-source utilizadas
- Roadmap.sh pelo projeto inspirador

## 🔗 Links Úteis

- [Documentação do /proc filesystem](https://www.kernel.org/doc/html/latest/filesystems/proc.html)
- [Bash Scripting Guide](https://www.gnu.org/software/bash/manual/)
- [Linux Performance Monitoring](https://www.brendangregg.com/linuxperf.html)
- [Sysstat Documentation](http://sebastien.godard.pagesperso-orange.fr/)

---

<div align="center">

**[⬆ Voltar ao Topo](#-linux-server-statistics-analyzer)**

*"God's in His heaven, all's right with the world!"*

Feito com ❤️ por [Aurora Ergodica](https://github.com/Crise-Ergodica)

</div>
