# 📦 Guia de Empacotamento - System Cleaner

Este documento fornece instruções detalhadas para empacotar o System Cleaner em diferentes formatos de distribuição.

## 🐧 Linux - Pacote .deb (Debian/Ubuntu)

### Pré-requisitos
```bash
sudo apt install dpkg-dev build-essential
```

### Criar Pacote .deb
```bash
# 1. Criar estrutura de diretórios
mkdir -p system-cleaner-deb/DEBIAN
mkdir -p system-cleaner-deb/usr/local/bin
mkdir -p system-cleaner-deb/usr/share/doc/system-cleaner
mkdir -p system-cleaner-deb/etc/system-cleaner

# 2. Copiar arquivos
cp linux-cleaner.sh system-cleaner-deb/usr/local/bin/
cp config/presets.conf system-cleaner-deb/etc/system-cleaner/
cp README.md LICENSE system-cleaner-deb/usr/share/doc/system-cleaner/

# 3. Definir permissões
chmod +x system-cleaner-deb/usr/local/bin/linux-cleaner.sh

# 4. Criar arquivo control
cat > system-cleaner-deb/DEBIAN/control << EOF
Package: system-cleaner
Version: 1.0.0
Section: utils
Priority: optional
Architecture: all
Depends: bash (>= 4.0), coreutils, findutils
Maintainer: Seu Nome <email@exemplo.com>
Description: Sistema de limpeza para Linux
 Scripts robustos e seguros para limpeza e otimização
 de sistemas Linux com suporte a múltiplas distribuições.
EOF

# 5. Criar script pós-instalação (opcional)
cat > system-cleaner-deb/DEBIAN/postinst << EOF
#!/bin/bash
set -e
mkdir -p /var/log/system-cleaner
chmod 755 /usr/local/bin/linux-cleaner.sh
echo "System Cleaner instalado com sucesso!"
EOF
chmod +x system-cleaner-deb/DEBIAN/postinst

# 6. Construir pacote
dpkg-deb --build system-cleaner-deb system-cleaner_1.0.0_all.deb

# 7. Verificar pacote
dpkg-deb --info system-cleaner_1.0.0_all.deb
dpkg-deb --contents system-cleaner_1.0.0_all.deb
```

### Instalar Pacote .deb
```bash
sudo dpkg -i system-cleaner_1.0.0_all.deb
sudo apt-get install -f  # Resolver dependências se necessário
```

## 🎩 Linux - Pacote .rpm (RedHat/Fedora/CentOS)

### Pré-requisitos
```bash
# Fedora/CentOS
sudo dnf install rpm-build rpmdevtools

# Criar estrutura
rpmdev-setuptree
```

### Criar Pacote .rpm
```bash
# 1. Criar spec file
cat > ~/rpmbuild/SPECS/system-cleaner.spec << EOF
Name:           system-cleaner
Version:        1.0.0
Release:        1%{?dist}
Summary:        Sistema de limpeza para Linux
License:        MIT
URL:            https://github.com/seu-usuario/system-cleaner
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch
Requires:       bash >= 4.0

%description
Scripts robustos e seguros para limpeza e otimização
de sistemas Linux com suporte a múltiplas distribuições.

%prep
%setup -q

%install
mkdir -p %{buildroot}/usr/local/bin
mkdir -p %{buildroot}/etc/system-cleaner
mkdir -p %{buildroot}/var/log/system-cleaner
install -m 755 linux-cleaner.sh %{buildroot}/usr/local/bin/
install -m 644 config/presets.conf %{buildroot}/etc/system-cleaner/

%files
/usr/local/bin/linux-cleaner.sh
/etc/system-cleaner/presets.conf
%dir /var/log/system-cleaner

%changelog
* Mon Jan 15 2024 Seu Nome <email@exemplo.com> - 1.0.0-1
- Lançamento inicial
EOF

# 2. Criar tarball
tar -czf ~/rpmbuild/SOURCES/system-cleaner-1.0.0.tar.gz .

# 3. Construir RPM
rpmbuild -ba ~/rpmbuild/SPECS/system-cleaner.spec
```

## 🪟 Windows - Executável .exe

### Método 1: ps2exe
```powershell
# 1. Instalar ps2exe
Install-Module ps2exe -Force

# 2. Converter para executável
Invoke-ps2exe -inputFile "windows-cleaner.ps1" -outputFile "system-cleaner.exe" -iconFile "icon.ico" -title "System Cleaner" -description "Sistema de Limpeza Windows" -company "Seu Nome" -version "1.0.0.0"
```

### Método 2: Instalador NSIS
```nsis
# system-cleaner-installer.nsi
!define APPNAME "System Cleaner"
!define COMPANYNAME "Seu Nome"
!define DESCRIPTION "Sistema de Limpeza Windows"
!define VERSIONMAJOR 1
!define VERSIONMINOR 0
!define VERSIONBUILD 0

Name "${APPNAME}"
OutFile "system-cleaner-installer.exe"
InstallDir "$PROGRAMFILES\${APPNAME}"

Page directory
Page instfiles

Section "install"
    SetOutPath $INSTDIR
    File "windows-cleaner.ps1"
    File "config\presets.conf"
    File "README.md"
    File "LICENSE"
    
    CreateDirectory "$INSTDIR\logs"
    
    # Criar atalho no menu iniciar
    CreateDirectory "$SMPROGRAMS\${APPNAME}"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "powershell.exe" "-File `"$INSTDIR\windows-cleaner.ps1`""
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
    
    # Registrar no sistema
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$INSTDIR"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "${COMPANYNAME}"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
    
    WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "uninstall"
    Delete "$INSTDIR\*.*"
    RMDir /r "$INSTDIR"
    Delete "$SMPROGRAMS\${APPNAME}\*.*"
    RMDir "$SMPROGRAMS\${APPNAME}"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
SectionEnd
```

## 📦 Arquivo ZIP Universal

### Criar Pacote ZIP
```bash
# Linux/macOS
zip -r system-cleaner-v1.0.0.zip system-cleaner/ -x "*.git*" "logs/*" "*.DS_Store"

# Windows (PowerShell)
Compress-Archive -Path "system-cleaner" -DestinationPath "system-cleaner-v1.0.0.zip" -CompressionLevel Optimal
```

### Estrutura do ZIP
```
system-cleaner-v1.0.0.zip
├── linux-cleaner.sh
├── windows-cleaner.ps1
├── config/
│   └── presets.conf
├── site/
│   └── index.html
├── README.md
├── LICENSE
├── PACKAGING.md
└── INSTALL.txt
```

## 🐳 Container Docker

### Dockerfile para Linux
```dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    bash \
    coreutils \
    findutils \
    bc \
    && rm -rf /var/lib/apt/lists/*

COPY linux-cleaner.sh /usr/local/bin/
COPY config/presets.conf /etc/system-cleaner/
RUN chmod +x /usr/local/bin/linux-cleaner.sh

VOLUME ["/var/log/system-cleaner"]

ENTRYPOINT ["/usr/local/bin/linux-cleaner.sh"]
CMD ["--media", "--silent"]
```

### Construir Imagem Docker
```bash
docker build -t system-cleaner:1.0.0 .
docker run -v /tmp:/tmp -v /var/log/system-cleaner:/var/log/system-cleaner system-cleaner:1.0.0
```

## 📱 Snap Package (Linux Universal)

### snapcraft.yaml
```yaml
name: system-cleaner
version: '1.0.0'
summary: Sistema de limpeza para Linux
description: |
  Scripts robustos e seguros para limpeza e otimização
  de sistemas Linux com suporte a múltiplas distribuições.

grade: stable
confinement: classic

parts:
  system-cleaner:
    plugin: dump
    source: .
    organize:
      linux-cleaner.sh: bin/linux-cleaner.sh
      config/presets.conf: etc/system-cleaner/presets.conf

apps:
  system-cleaner:
    command: bin/linux-cleaner.sh
    plugs: [home, removable-media, system-files]
```

### Construir Snap
```bash
snapcraft
sudo snap install system-cleaner_1.0.0_amd64.snap --dangerous
```

## 🍺 Homebrew Formula (macOS)

### system-cleaner.rb
```ruby
class SystemCleaner < Formula
  desc "Sistema de limpeza para Linux e macOS"
  homepage "https://github.com/seu-usuario/system-cleaner"
  url "https://github.com/seu-usuario/system-cleaner/archive/v1.0.0.tar.gz"
  sha256 "sha256_do_arquivo"
  license "MIT"

  depends_on "bash"

  def install
    bin.install "linux-cleaner.sh" => "system-cleaner"
    etc.install "config/presets.conf" => "system-cleaner/presets.conf"
  end

  test do
    system "#{bin}/system-cleaner", "--help"
  end
end
```

## 📋 Checklist de Distribuição

### Antes de Empacotar
- [ ] Testar scripts em diferentes sistemas
- [ ] Verificar dependências
- [ ] Atualizar versões em todos os arquivos
- [ ] Gerar checksums dos arquivos
- [ ] Criar release notes
- [ ] Testar instalação/desinstalação

### Após Empacotamento
- [ ] Testar pacotes em sistemas limpos
- [ ] Verificar assinaturas digitais
- [ ] Publicar em repositórios oficiais
- [ ] Atualizar documentação
- [ ] Notificar usuários sobre nova versão

## 🔐 Assinatura Digital

### GPG (Linux)
```bash
# Assinar pacote
gpg --armor --detach-sign system-cleaner_1.0.0_all.deb

# Verificar assinatura
gpg --verify system-cleaner_1.0.0_all.deb.asc system-cleaner_1.0.0_all.deb
```

### Code Signing (Windows)
```powershell
# Assinar executável (requer certificado)
signtool sign /f "certificado.pfx" /p "senha" /t "http://timestamp.digicert.com" system-cleaner.exe
```

---

**📝 Nota**: Adapte os caminhos, nomes e informações de contato conforme necessário para seu projeto específico.
