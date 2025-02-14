# конвертирование выводного файла утилиты niping в csv файла
# который в дальнейшем обрабатывается Grafana'ой

$BasePath = 'e:\niping'
foreach($file in Get-childItem -path (join-path $BasePath '\*') -Include *.log,*.csv){
    if($file.LastWriteTime -lt (Get-date).AddHours(-3)){
        if (-not (Test-Path $BasePath'\Archive')){New-Item -Path $BasePath'\Archive' -ItemType Directory}
        Move-Item -Path $file.FullName -Destination $BasePath'\Archive\'
    }
    else{            
            $content = Get-Content $file.FullName
            $regex = "(?<day>\w{3} +\d+) (?<time>\d\d:\d\d:\d\d) (?<year>\d{4})\W\s*\d+:\s*(?<val>\d+\.\d+)"
            $data = [RegEx]::Matches($content,$regex)
      
            $fileoutname = $file.DirectoryName+'\'+$file.BaseName+'.csv'
            for ($i=0;$i -lt $data.count;$i++){
                $day = $data[$i].Groups['day'].Value
                if ($day.Substring(4,2) -lt 10){
                $day = $day.Replace('  ',' 0')
                }
                $result = $day+' '+$data[$i].Groups['year'].Value+' '+$data[$i].Groups['time'].Value+' '+$data[$i].Groups['val'].Value
                $result|Out-File -FilePath $fileoutname -Encoding utf8 -Append
           }
    } 
}