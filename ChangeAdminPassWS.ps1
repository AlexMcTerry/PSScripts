# скрипт меняет пароль локального администратора (учетки "админ" и "admin") на BlaBlaBla[имя_компьютера]
# помещается в сетевую шару, доступ ограничивается только компьютерами домена (пользователи убираются)
# добавляется в GPO уровня компьютера, StartUp скрипт


$PASS_START = 'BlaBlaBla'
$PASS_END = $Env:COMPUTERNAME.ToLower()
$pass_phrase = $PASS_START+$PASS_END

$pass = ConvertTo-SecureString $pass_phrase -AsPlainText -Force

Set-LocalUser -Name admin -Password $pass -ErrorAction SilentlyContinue
Set-LocalUser -Name админ -Password $pass -ErrorAction SilentlyContinue
New-Item -ItemType File -Path \\admints\ChangedAdminPass$\ -Name $PASS_END -ErrorAction SilentlyContinue # запись информации о компьютере, сменившем пароль