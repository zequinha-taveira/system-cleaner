# ⚡ Setup Rápido - System Cleaner no GitHub

## 🚀 Método 1: Automático (Recomendado)

### 1. Execute o script de setup
```powershell
# No diretório do projeto
.\setup-github.ps1 -GitHubUsername "SEU_USUARIO" -GitHubEmail "seu-email@exemplo.com"
```

### 2. Crie o repositório no GitHub
1. Acesse: https://github.com/new
2. Nome: `system-cleaner`
3. Descrição: `🧹 Scripts robustos para limpeza de sistemas Linux e Windows`
4. Público ✅
5. **NÃO** adicione README, .gitignore ou LICENSE
6. Clique em "Create repository"

### 3. Conecte e envie o código
```bash
git remote add origin https://github.com/SEU_USUARIO/system-cleaner.git
git push -u origin main
```

### 4. Configure GitHub Pages
1. Settings > Pages
2. Source: "Deploy from a branch"
3. Branch: "main"
4. Folder: "/site"
5. Save

### 5. Crie a primeira release
1. Releases > "Create a new release"
2. Tag: `v1.0.0`
3. Title: `🧹 System Cleaner v1.0.0 - Lançamento Inicial`
4. Publish release

## 🛠️ Método 2: Manual

### 1. Configurar Git
```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu-email@exemplo.com"
```

### 2. Inicializar repositório
```bash
cd "G:\Zequinha Taveira\Desktop\Nova pasta\system-cleaner"
git init
git add .
git commit -m "🎉 Initial commit: System Cleaner v1.0.0"
git branch -M main
```

### 3. Criar repositório no GitHub
- Acesse: https://github.com/new
- Configure conforme método 1

### 4. Conectar e enviar
```bash
git remote add origin https://github.com/SEU_USUARIO/system-cleaner.git
git push -u origin main
```

## 📋 Checklist Final

Após a configuração, verifique:

- [ ] ✅ Repositório criado e público
- [ ] ✅ Código enviado para GitHub
- [ ] ✅ README com badges funcionando
- [ ] ✅ GitHub Pages ativo (site funcionando)
- [ ] ✅ Issues templates configurados
- [ ] ✅ GitHub Actions executando
- [ ] ✅ Release v1.0.0 publicada
- [ ] ✅ Topics adicionados ao repositório
- [ ] ✅ Descrição e website configurados

## 🌐 URLs Importantes

Após a configuração, você terá:

- **Repositório**: `https://github.com/SEU_USUARIO/system-cleaner`
- **Site**: `https://SEU_USUARIO.github.io/system-cleaner`
- **Releases**: `https://github.com/SEU_USUARIO/system-cleaner/releases`
- **Issues**: `https://github.com/SEU_USUARIO/system-cleaner/issues`

## 🎯 Próximos Passos

1. **Compartilhe o projeto**:
   - Redes sociais
   - Comunidades de desenvolvedores
   - LinkedIn, Twitter, Reddit

2. **Monitore e mantenha**:
   - Responda issues rapidamente
   - Aceite contribuições
   - Atualize regularmente

3. **Melhore continuamente**:
   - Colete feedback dos usuários
   - Adicione novas funcionalidades
   - Mantenha documentação atualizada

## 🆘 Problemas Comuns

### Git não encontrado
```bash
# Windows
winget install Git.Git
# ou
choco install git
```

### Erro de autenticação
```bash
# Configure token de acesso pessoal
# GitHub > Settings > Developer settings > Personal access tokens
```

### GitHub Pages não funciona
- Verifique se o branch está correto (main)
- Aguarde alguns minutos para propagação
- Verifique se há erros no Actions

### Actions falhando
- Verifique sintaxe dos arquivos YAML
- Confirme se os scripts têm permissão de execução
- Veja logs detalhados na aba Actions

---

**🚀 Seu System Cleaner está pronto para conquistar o mundo!**

Lembre-se de substituir `SEU_USUARIO` pelo seu nome de usuário real do GitHub em todos os comandos e URLs.
