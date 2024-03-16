#!/bin/bash

[[ "$(whoami)" != "root" ]] && {
echo
echo "Instale Com Usuário Root!"
echo
rm i.sh
exit 0
}

ubuntuV=$(lsb_release -r | awk '{print $2}' | cut -d. -f1)

[[ $(($ubuntuV < 20)) = 1 ]] && {
clear
echo "A Versão Do Ubuntu Tem Que Ser No Mínimo 20, A Sua É $ubuntuV"
echo
rm /root/i.sh
exit 0
}
[[ -e /root/painelMod/src/index.ts ]] && {
  clear
  echo "O Painel já está instalado, deseja remover? (s/n)"
  read remo
  [[ $remo = @(s|S) ]] && {
  cd /root/painelMod
  rm -r painelbackup > /dev/null
  mkdir painelbackup > /dev/null
  cp prisma/database.db painelbackup
  cp .env painelbackup
  zip -r painelbackup.zip painelbackup
  mv painelbackup.zip /root
  rm -r /root/painelMod
  rm /root/i.sh
  echo "Removido com sucesso!"
  exit 0
  }
  exit 0
}
clear
echo "Em Qual Porta Você Quer Ativar?"
read porta
echo
echo "Intalando Painel Dtmod..."
echo
sleep 3
#========================
apt update -y
apt-get update -y
apt install wget -y
apt install curl -y
apt install zip -y
apt install cron -y
apt install unzip -y
apt install screen -y
apt install git -y
curl -fsSL https://deb.nodesource.com/setup_20.x | bash
apt-get install -y nodejs -y
#=========================
git clone https://github.com/Rafaeloficiall/painelmod.git
cd /root/painelMod
chmod 777 pon poff menuop backmod
mv pon poff menuop backmod /bin
echo "PORT=$porta" > .env
echo "NODE_ENV=\"production\"" >> .env
echo "DATABASE_URL=\"file:./database.db\"" >> .env
token1=$(node -e "console.log(require('crypto').randomBytes(100).toString('base64'));")
token2=$(node -e "console.log(require('crypto').randomBytes(100).toString('base64'));")
token3=$(node -e "console.log(require('crypto').randomBytes(100).toString('base64'));")
echo "CSRF_SECRET=\"$token1\"" >> .env
echo "JWT_SECRET_KEY=\"$token2\"" >> .env
echo "JWT_SECRET_REFRESH=\"$token3\"" >> .env
echo "ENCRYPT_FILES=\"7223fd56-e21d-4191-8867-f3c67601122a\"" >> .env
npm install
npx prisma generate
npx prisma migrate deploy
#=========================
clear
echo
echo
echo "TUDO INSTALADO!"
echo "Os Arquivos Ficam Na Pasta /root/painelMod"
echo
echo "Comando para ATIVAR: pon"
echo "Comando para DESATIVAR: poff"
echo
echo "Digite menuop Para ver o menu"
echo
rm /root/i.sh
pon
