# отключение неактивных более 60 дней УЗ в ActiveDirectory

$SearchBases = #пути поиска учеток
               "OU=Users,OU=Krasnodar,DC=contoso,DC=com", 
               "OU=Users,OU=Novosibirsk,DC=contoso,DC=com"

$Today = Get-Date #Получить текущую дату
$BlockedUsers="Login `t`t`t`t LastLogonTimestamp`n" #переменная для письма
foreach($searchBase in $SearchBases){ #Побежали по путям поиска 
    $users = Get-ADUser -Filter * -SearchBase $searchBase -Properties * #и собираем список учеток в этих OUшках
    foreach ($user in $users){# перебираем учетки
        if ( (($Today - $user.WhenCreated).Days -gt 60)-and # если не новая учетка и
             ($user.description -notlike '*Неактивно>60Дней*') -and# если учетка уже не была ранее заблокирована
             ($Today -[datetime]::FromFileTime($user.lastlogonTimestamp)).Days -gt 60 # если lastlogonTimestamp был больше, чем 60 дней назад
           ){
            $Description = '(Неактивно>60Дней) '+$user.description# изменить описание и 
            Set-ADUser $user.samaccountname -Description $Description -Enabled $false #заблокировать учетку
            $BlockedUsers = $BlockedUsers + "`n" + $user.samaccountname + " `t`t`t`t " + [datetime]::FromFileTime($user.lastlogonTimestamp)
        }
    }

}
if($BlockedUsers){ #если набрались неактивные учетки, то
$encoding = [System.Text.Encoding]::UTF8 # поменять кодировку и
#отправить письмо
Send-MailMessage -From "Admin@contoso.com" -to "tp@contoso.com" -Subject "Неактивные более 60ти дней УЗ" -Body "Были отключены из-за неактивности более 60ти дней учетные записи: `n $BlockedUsers `n
При необходимости включить повторно вручную, удалив из описания '(Неактивно>60Дней)'" -SmtpServer mail.contoso.com -Encoding $encoding
$BlockedUsers
}