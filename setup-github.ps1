# 🚀 Script de Automação - Setup GitHub para System Cleaner
# Este script automatiza a configuração inicial do repositório GitHub

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$false)]
    [string]$GitHubEmail = "",
    
    [Parameter(Mandatory=$false)]
    [string]$RepositoryName = "system-cleaner"
)

Write-Host "🚀 Configurando System Cleaner para GitHub..." -ForegroundColor Blue
Write-Host "👤 Usuário: $GitHubUsername" -ForegroundColor Cyan
Write-Host "📦 Repositório: $RepositoryName" -ForegroundColor Cyan
Write-Host ""

# Verificar se Git está instalado
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git não encontrado! Instale o Git primeiro:" -ForegroundColor Red
    Write-Host "   winget install Git.Git" -ForegroundColor Yellow
    exit 1
}

# Configurar Git se email foi fornecido
if ($GitHubEmail) {
    Write-Host "⚙️ Configurando Git..." -ForegroundColor Yellow
    git config --global user.name $GitHubUsername
    git config --global user.email $GitHubEmail
    Write-Host "✅ Git configurado!" -ForegroundColor Green
}

# Inicializar repositório
Write-Host "📁 Inicializando repositório Git..." -ForegroundColor Yellow
git init

# Criar .gitignore
Write-Host "📝 Criando .gitignore..." -ForegroundColor Yellow
@"
# Logs
logs/*.txt
logs/*.log
!logs/.gitkeep

# Arquivos temporários
*.tmp
*.temp
.DS_Store
Thumbs.db

# Arquivos de sistema
*.swp
*.swo
*~

# Diretórios de build
build/
dist/
*.exe
*.msi

# Configurações locais
config/local.conf
.env

# Node modules (se usar)
node_modules/

# Python
__pycache__/
*.pyc
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8

# Criar estrutura de templates do GitHub
Write-Host "🏗️ Criando templates do GitHub..." -ForegroundColor Yellow
New-Item -Path ".github\ISSUE_TEMPLATE" -ItemType Directory -Force | Out-Null
New-Item -Path ".github\workflows" -ItemType Directory -Force | Out-Null

# Template de Bug Report
@"
---
name: 🐛 Bug Report
about: Reportar um problema ou erro
title: '[BUG] '
labels: bug
assignees: ''
---

## 🐛 Descrição do Bug
Uma descrição clara e concisa do problema.

## 🔄 Passos para Reproduzir
1. Vá para '...'
2. Execute '...'
3. Veja o erro

## ✅ Comportamento Esperado
O que deveria acontecer.

## 📱 Ambiente
- **OS**: [ex: Windows 11, Ubuntu 22.04]
- **Versão do Script**: [ex: v1.0.0]
- **Shell**: [ex: PowerShell 7.2, Bash 5.1]

## 📝 Informações Adicionais
Qualquer outra informação relevante.
"@ | Out-File -FilePath ".github\ISSUE_TEMPLATE\bug_report.md" -Encoding UTF8

# Template de Feature Request
@"
---
name: 💡 Feature Request
about: Sugerir uma nova funcionalidade
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

## 💡 Descrição da Feature
Uma descrição clara da funcionalidade desejada.

## 🎯 Problema que Resolve
Qual problema esta feature resolveria?

## 💭 Solução Proposta
Como você imagina que esta feature funcionaria?

## 🔄 Alternativas Consideradas
Outras soluções que você considerou.

## 📝 Informações Adicionais
Qualquer outra informação relevante.
"@ | Out-File -FilePath ".github\ISSUE_TEMPLATE\feature_request.md" -Encoding UTF8

# Template de Pull Request
@"
## 📋 Descrição
Descreva as mudanças realizadas neste PR.

## 🔄 Tipo de Mudança
- [ ] 🐛 Bug fix
- [ ] ✨ Nova feature
- [ ] 💥 Breaking change
- [ ] 📝 Documentação
- [ ] 🎨 Melhoria de código
- [ ] ⚡ Performance
- [ ] 🔧 Configuração

## ✅ Checklist
- [ ] Código testado
- [ ] Documentação atualizada
- [ ] Changelog atualizado
- [ ] Testes passando

## 📝 Notas Adicionais
Qualquer informação adicional relevante.
"@ | Out-File -FilePath ".github\pull_request_template.md" -Encoding UTF8

# Workflow de Testes
@"
name: 🧪 Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test-linux:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: 🐧 Test Linux Script
      run: |
        chmod +x linux-cleaner.sh
        ./linux-cleaner.sh --help
        
    - name: 🔍 Shellcheck
      run: |
        sudo apt-get install shellcheck
        shellcheck linux-cleaner.sh

  test-windows:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: 🪟 Test Windows Script
      run: |
        powershell -File windows-cleaner.ps1 -Help
        
    - name: 🔍 PSScriptAnalyzer
      run: |
        Install-Module -Name PSScriptAnalyzer -Force
        Invoke-ScriptAnalyzer -Path windows-cleaner.ps1
"@ | Out-File -FilePath ".github\workflows\test.yml" -Encoding UTF8

# Workflow de Deploy
@"
name: 🚀 Deploy Site

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: 🌐 Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: `${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./site
"@ | Out-File -FilePath ".github\workflows\deploy.yml" -Encoding UTF8

# Security Policy
@"
# 🔒 Política de Segurança

## 🛡️ Versões Suportadas

| Versão | Suportada |
| ------ | --------- |
| 1.0.x  | ✅        |

## 🚨 Reportando Vulnerabilidades

Se você descobrir uma vulnerabilidade de segurança, por favor:

1. **NÃO** abra uma issue pública
2. Envie um email para: security@exemplo.com
3. Inclua detalhes da vulnerabilidade
4. Aguarde nossa resposta em até 48h

## 🔐 Práticas de Segurança

- Scripts validam entrada do usuário
- Verificação de privilégios obrigatória
- Logs não contêm informações sensíveis
- Código auditado regularmente
"@ | Out-File -FilePath ".github\SECURITY.md" -Encoding UTF8

# Contributing Guidelines
@"
# 🤝 Contribuindo para o System Cleaner

Obrigado por considerar contribuir! 

## 🚀 Como Contribuir

### 1. Fork o Projeto
``````bash
git clone https://github.com/$GitHubUsername/$RepositoryName.git
cd $RepositoryName
``````

### 2. Criar Branch
``````bash
git checkout -b feature/nova-funcionalidade
``````

### 3. Fazer Mudanças
- Mantenha o código limpo e comentado
- Siga as convenções existentes
- Teste suas mudanças

### 4. Commit
``````bash
git commit -m "✨ Add nova funcionalidade"
``````

### 5. Push e Pull Request
``````bash
git push origin feature/nova-funcionalidade
``````

## 📋 Diretrizes

### Commits
Use emojis e seja descritivo:
- ✨ ``:sparkles:`` Nova feature
- 🐛 ``:bug:`` Bug fix
- 📝 ``:memo:`` Documentação
- 🎨 ``:art:`` Melhoria de código
- ⚡ ``:zap:`` Performance
- 🔧 ``:wrench:`` Configuração

### Código
- Comente código complexo
- Use nomes descritivos
- Mantenha funções pequenas
- Teste antes de enviar

## 🐛 Reportando Bugs
Use os templates de issue para reportar problemas.

## 💡 Sugerindo Features
Use os templates de issue para sugerir melhorias.
"@ | Out-File -FilePath "CONTRIBUTING.md" -Encoding UTF8

# Atualizar README com o nome de usuário correto
Write-Host "📝 Atualizando README..." -ForegroundColor Yellow
$readmeContent = Get-Content "README.md" -Raw
$readmeContent = $readmeContent -replace "seu-usuario", $GitHubUsername
$readmeContent | Out-File -FilePath "README.md" -Encoding UTF8

# Adicionar arquivos ao Git
Write-Host "📦 Adicionando arquivos ao Git..." -ForegroundColor Yellow
git add .

# Commit inicial
Write-Host "💾 Fazendo commit inicial..." -ForegroundColor Yellow
git commit -m "🎉 Initial commit: System Cleaner v1.0.0

- ✅ Linux cleaner script with 3 cleanup levels
- ✅ Windows PowerShell script with admin verification
- ✅ Modern static website with dark theme
- ✅ Complete documentation and packaging guide
- ✅ GitHub templates and workflows
- ✅ MIT License for open source distribution"

# Configurar branch main
git branch -M main

Write-Host ""
Write-Host "✅ Configuração local concluída!" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Crie o repositório no GitHub:" -ForegroundColor White
Write-Host "   https://github.com/new" -ForegroundColor Cyan
Write-Host "   Nome: $RepositoryName" -ForegroundColor Cyan
Write-Host "   Descrição: 🧹 Scripts robustos para limpeza de sistemas Linux e Windows" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Conecte o repositório local:" -ForegroundColor White
Write-Host "   git remote add origin https://github.com/$GitHubUsername/$RepositoryName.git" -ForegroundColor Cyan
Write-Host "   git push -u origin main" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Configure GitHub Pages:" -ForegroundColor White
Write-Host "   Settings > Pages > Source: Deploy from branch > main > /site" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Crie a primeira release:" -ForegroundColor White
Write-Host "   Releases > Create a new release > Tag: v1.0.0" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎉 Seu projeto estará pronto para o mundo!" -ForegroundColor Green
