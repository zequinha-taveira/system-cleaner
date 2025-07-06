# 🧹 System Cleaner

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue.svg)]()
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20PowerShell-green.svg)]()

Um conjunto de scripts robustos e seguros para limpeza e otimização de sistemas Linux e Windows, com interface web moderna para apresentação e download.

## 🚀 Características

- **🐧 Linux**: Compatível com Debian, Ubuntu, Fedora, CentOS, Arch
- **🪟 Windows**: Compatível com Windows 10/11 e PowerShell 5.1+
- **📊 Monitoramento**: Exibe espaço em disco antes/depois
- **🎨 Interface**: Mensagens coloridas e amigáveis
- **📝 Logs**: Sistema completo de logging
- **⏰ Automação**: Compatível com cron e Task Scheduler
- **🌐 Site**: Interface web moderna para download

## 📁 Estrutura do Projeto

```
system-cleaner/
├── linux-cleaner.sh          # Script principal Linux
├── windows-cleaner.ps1       # Script principal Windows
├── logs/                     # Diretório de logs
├── site/                     # Site estático
│   ├── index.html
│   └── assets/
├── config/
│   └── presets.conf
├── README.md
└── LICENSE
```

## 🛠️ Instalação

### Linux
```bash
# Clonar o repositório
git clone https://github.com/seu-usuario/system-cleaner.git
cd system-cleaner

# Dar permissão de execução
chmod +x linux-cleaner.sh

# Executar
./linux-cleaner.sh --help
```

### Windows
```powershell
# Clonar o repositório
git clone https://github.com/seu-usuario/system-cleaner.git
cd system-cleaner

# Permitir execução de scripts (se necessário)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Executar como Administrador
.\windows-cleaner.ps1 -Help
```

## 📖 Uso

### Linux
```bash
# Limpeza leve (arquivos temporários)
./linux-cleaner.sh --leve

# Limpeza média (+ cache de pacotes)
./linux-cleaner.sh --media

# Limpeza profunda (+ logs antigos)
./linux-cleaner.sh --profunda

# Modo silencioso para automação
./linux-cleaner.sh --media --silent
```

### Windows
```powershell
# Limpeza leve
.\windows-cleaner.ps1 -Mode "leve"

# Limpeza média
.\windows-cleaner.ps1 -Mode "media"

# Limpeza profunda
.\windows-cleaner.ps1 -Mode "profunda"

# Modo silencioso
.\windows-cleaner.ps1 -Mode "media" -Silent
```

## ⏰ Automação

### Linux (cron)
```bash
# Editar crontab
crontab -e

# Executar diariamente às 3h da manhã
0 3 * * * /caminho/para/linux-cleaner.sh --media --silent
```

### Windows (Task Scheduler)
```powershell
# Criar tarefa agendada
schtasks /create /tn "System Cleaner" /tr "powershell.exe -File C:\caminho\windows-cleaner.ps1 -Mode media -Silent" /sc daily /st 03:00
```

## 📦 Empacotamento

### Debian Package (.deb)
```bash
# Instalar ferramentas
sudo apt install dpkg-dev

# Criar estrutura
mkdir -p system-cleaner-deb/DEBIAN
mkdir -p system-cleaner-deb/usr/local/bin

# Copiar arquivos
cp linux-cleaner.sh system-cleaner-deb/usr/local/bin/
chmod +x system-cleaner-deb/usr/local/bin/linux-cleaner.sh

# Criar control file
cat > system-cleaner-deb/DEBIAN/control << EOF
Package: system-cleaner
Version: 1.0.0
Section: utils
Priority: optional
Architecture: all
Maintainer: Seu Nome <email@exemplo.com>
Description: Sistema de limpeza para Linux
EOF

# Construir pacote
dpkg-deb --build system-cleaner-deb system-cleaner_1.0.0_all.deb
```

### Windows Executable (.exe)
```powershell
# Usar ps2exe para converter PowerShell em executável
Install-Module ps2exe
Invoke-ps2exe -inputFile windows-cleaner.ps1 -outputFile system-cleaner.exe
```

### Arquivo ZIP
```bash
# Criar arquivo compactado
zip -r system-cleaner-v1.0.0.zip system-cleaner/ -x "*.git*" "logs/*"
```

## 🌐 Site Web

O projeto inclui um site estático moderno em `site/index.html` com:
- Apresentação do projeto
- Download direto dos scripts
- Instruções de uso
- Changelog
- Design responsivo com modo escuro

Para hospedar:
```bash
# GitHub Pages, Netlify, Vercel, etc.
cd site/
# Upload dos arquivos para seu provedor de hospedagem
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- Comunidade open source
- Contribuidores do projeto
- Usuários que reportam bugs e sugestões

## 📞 Suporte

- 🐛 **Issues**: [GitHub Issues](https://github.com/seu-usuario/system-cleaner/issues)
- 💬 **Discussões**: [GitHub Discussions](https://github.com/seu-usuario/system-cleaner/discussions)
- 📧 **Email**: seu-email@exemplo.com

---

**⚡ Mantenha seu sistema sempre otimizado!** 🚀
