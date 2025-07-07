## 🎉 Lançamento Inicial do System Cleaner

### ✨ Funcionalidades Principais
- 🐧 **Script Linux**: Compatível com Debian, Ubuntu, Fedora, CentOS, Arch
- 🪟 **Script Windows**: PowerShell com verificação automática de administrador
- 🌐 **Site Moderno**: Interface web responsiva com modo escuro
- 📊 **3 Níveis de Limpeza**: Leve, Média, Profunda
- 📝 **Sistema de Logs**: Logging detalhado com timestamps
- ⏰ **Automação**: Compatível com cron (Linux) e Task Scheduler (Windows)

### 🛠️ O que cada script faz:

#### 🐧 Linux (`linux-cleaner.sh`)
- Limpa arquivos temporários (`/tmp`, `~/.cache`)
- Remove logs antigos (mantém últimos 7 dias)
- Limpa cache de pacotes (apt, dnf, yum, pacman)
- Detecta automaticamente a distribuição
- Medição precisa de espaço liberado

#### 🪟 Windows (`windows-cleaner.ps1`)
- Limpa `%TEMP%`, `C:\Windows\Temp`
- Esvazia a Lixeira automaticamente
- Remove arquivos do Windows Update
- Limpa logs antigos do sistema
- Verificação de privilégios de administrador

### 🚀 Instalação Rápida

#### Linux
```bash
wget https://github.com/SEU_USUARIO/system-cleaner/raw/v1.0.0/linux-cleaner.sh
chmod +x linux-cleaner.sh
./linux-cleaner.sh --media
```

#### Windows (PowerShell como Administrador)
```powershell
Invoke-WebRequest -Uri "https://github.com/SEU_USUARIO/system-cleaner/raw/v1.0.0/windows-cleaner.ps1" -OutFile "windows-cleaner.ps1"
.\windows-cleaner.ps1 -Mode media
```

### 📋 Changelog Completo
- ✅ Implementação inicial dos scripts de limpeza
- ✅ Interface web moderna com Tailwind CSS
- ✅ Documentação completa
- ✅ Sistema de logging detalhado
- ✅ Compatibilidade ampla com múltiplas distribuições
- ✅ Verificações de segurança
- ✅ Guia de empacotamento
- ✅ Licença MIT
- ✅ Templates GitHub
- ✅ CI/CD configurado

### 🔒 Segurança
- Scripts validam entrada do usuário
- Verificação obrigatória de privilégios
- Logs não contêm informações sensíveis
- Código auditado e testado

**⚡ Mantenha seu sistema sempre otimizado com o System Cleaner!**
