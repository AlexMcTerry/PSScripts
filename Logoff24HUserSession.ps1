# отключить "забытые" сессии с сервера без настроенного терминального доступа

$servers = 'sapewm', 'sapewm2','sapewm3','sapewm4','sapewm5','sapewm6',
           'sapewm7','sapewm8','sapewm9','sapewm10','print2','prodappservicehost',
           'el1cc','by-ts','el1cb-1'


foreach ($server in $servers){
    $sess = $null
    $sess = quser /server:$server

    foreach ($user in $sess){
      $matches=$null

      $user -match '(?<user>[a-z]+_[a-z]+_?[a-z]*).*  (?<ID>\d+) .* (?<LogonTime>\d+\.\d+\.\d+ \d+:\d+)'
      if ($matches -ne $null){       
          $matches.LogonTime = $matches.LogonTime.replace('.01.','-jan-')
          $matches.LogonTime = $matches.LogonTime.replace('.02.','-feb-')
          $matches.LogonTime = $matches.LogonTime.replace('.03.','-mar-')
          $matches.LogonTime = $matches.LogonTime.replace('.04.','-apr-')
          $matches.LogonTime = $matches.LogonTime.replace('.05.','-may-')
          $matches.LogonTime = $matches.LogonTime.replace('.06.','-jun-')
          $matches.LogonTime = $matches.LogonTime.replace('.07.','-jul-')
          $matches.LogonTime = $matches.LogonTime.replace('.08.','-aug-')
          $matches.LogonTime = $matches.LogonTime.replace('.09.','-sep-')
          $matches.LogonTime = $matches.LogonTime.replace('.10.','-oct-')
          $matches.LogonTime = $matches.LogonTime.replace('.11.','-nov-')
          $matches.LogonTime = $matches.LogonTime.replace('.12.','-dec-')                                                                         
          $matches.LogonTime = [datetime]$matches.LogonTime

          if ($matches.LogonTime -lt (get-date).AddHours(-24)){
            logoff /server $server $matches.ID
            }
        }
    }
}