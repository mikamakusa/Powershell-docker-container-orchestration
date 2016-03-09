###### Import functions ######
iex (New-Object Net.WebClient).DownloadString("https://gist.github.com/darkoperator/6152630/raw/c67de4f7cd780ba367cccbc2593f38d18ce6df89/instposhsshdev")
Import-Module Posh-SSH
###### Custom Functions ######
function Containers {
    param(
        [Parameter(Mandatory=$true, position = 0)][string]$Uri,
        [Parameter(Mandatory=$true, position = 1)][ValidateSet("List","Inspect","Proc","Logs","Start","Stop","Restart","Kill","Rename","Pause","UnPause","Attach","Remove")][string]$action,
        [Parameter(Mandatory=$false)][string]$id,
        [Parameter(Mandatory=$false)][string]$name,
        [Parameter(Mandatory=$false)][string]$image,
        )
    if (-not($Uri) -and (-not($action))) {
        Throw "Paramètres URL et Action manquants"
    }
    if ($action -match "List") {
        Invoke-WebRequest -Uri $apicall/containers/json?all=1 -ContentType "application/json" -Method GET | ConvertFrom-Json | ft -Property Id,Names,Images,Command
    }
    Elseif ($action -match "Inspect"){
        if (-not($id)) {
            Throw "Merci de préciser l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/json -ContentType "application/json" -Method GET | ConvertFrom-Json
    }
    Elseif ($action -match "Proc") {
        if (-not($id)) {
            Throw "Merci de préciser l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/top -ContentType "application/json" -Method GET | ConvertFrom-Json
    }
    Elseif ($action -match "Logs") {
        if (-not($id)) {
            Throw "Merci de préciser l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/logs -ContentType "application/json" -Method GET | ConvertFrom-Json
    }
    Elseif ($action -match "Start") {
        if (-not($id)) {
            Throw "Merci de préciser l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/start -ContentType "application/json" -Method POST
        if (((Invoke-WebRequest -Uri $apicall/containers/$id/start -ContentType "application/json" -Method POST).StatusCode).Equals(200)) {
            Write-Host "Conteneur $id démarré"
        }
        elseif (((Invoke-WebRequest -Uri $apicall/containers/$id/start -ContentType "application/json" -Method POST).StatusCode).Equals(304)) {
            Write-Host "Conteneur $id déjà démarré"
        }
        elseif (((Invoke-WebRequest -Uri $apicall/containers/$id/start -ContentType "application/json" -Method POST).StatusCode).Equals(404)) {
            Write-Host "Conteneur $id introuvable"
        }
        else {
            Write-Host "Erreur Serveur"
        }
    }    
    Elseif ($action -match "Stop") {
        if (-not($id)) {
            Throw "Merci de préciser l'URL et l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/stop -ContentType "application/json" -Method POST
        if (((Invoke-WebRequest -Uri $apicall/containers/$id/stop -ContentType "application/json" -Method POST).StatusCode).Equals(200)) {
            Write-Host "Conteneur $id stoppé !"
        }
        elseif (((Invoke-WebRequest -Uri $apicall/containers/$id/stop -ContentType "application/json" -Method POST).StatusCode).Equals(304)) {
            Write-Host "Conteneur $id déjà stoppé"
        }
        elseif (((Invoke-WebRequest -Uri $apicall/containers/$id/stop -ContentType "application/json" -Method POST).StatusCode).Equals(404)) {
            Write-Host "Conteneur $id introuvable"
        }
        else {
            Write-Host"Erreur serveur"
        }
    }
    Elseif ($action -match "Restart") {
        if (-not($id)) {
            Throw "Merci de préciser l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/restart -ContentType "application/json" -Method POST
        if (((Invoke-WebRequest -Uri $apicall/containers/$id/restart -ContentType "application/json" -Method POST).StatusCode).Equals(200)) {
            Write-Host "Conteneur $id redémarré avec succès !"
        }
        elseif (((Invoke-WebRequest -Uri $apicall/containers/$id/restart -ContentType "application/json" -Method POST).StatusCode).Equals(404)) {
            Write-Host "Conteneur $id introuvable"
        }
        else {
            Write-Host "Erreur Serveur"
        }
    }
    Elseif ($action -match "Kill") {
        if (-not($id)) {
            Throw "Merci de préciser l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/kill -ContentType "application/json" -Method POST
        if (((Invoke-WebRequest -Uri $apicall/containers/$id/kill -ContentType "application/json" -Method POST).StatusCode).Equals(204)) {
            Write-Host "Conteneur $id supprimé avec succès !"
        }
        elseif (((Invoke-WebRequest -Uri $apicall/containers/$id/kill -ContentType "application/json" -Method POST).StatusCode).Equals(404)) {
            Write-Host "Conteneur $id introuvable"
        }
        else {
            Write-Host "Erreur Serveur"
        }
    }
    Elseif ($action -match "Rename") {
        if (-not($id) -and (-not($name))) {
            Throw "Merci de préciser l'id et le nouveau nom"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/rename?name=$name -ContentType "application/json" -Method POST
        if (((Invoke-WebRequest -Uri $apicall/containers/$id/rename?name=$name -ContentType "application/json" -Method POST).StatusCode).Equals(200)) {
            Write-Host "Conteneur $id renommé avec succès !"
        }
        elseif (((Invoke-WebRequest -Uri $apicall/containers/$id/rename?name=$name -ContentType "application/json" -Method POST).StatusCode).Equals(404)){
            Write-Host "Conteneur $id introuvable"
        }
        elseif (((Invoke-WebRequest -Uri $apicall/containers/$id/rename?name=$name -ContentType "application/json" -Method POST).StatusCode).Equals(409)){
            Write-Host "Nom déjà assigné"
        }
        else {
            Write-Host "Erreur Serveur"
        } 
    }
    Elseif ($action -match "Pause") {
        if (-not($id)) {
            Throw "Merci de préciser l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/pause -ContentType "application/json" -Method POST
        if (((Invoke-WebRequest -Uri $apicall/containers/$id/pause -ContentType "application/json" -Method POST).StatusCode).Equals(200)) {
            Write-Host "Conteneur $id en état : pause"
        }
        elseif (((Invoke-WebRequest -Uri $apicall/containers/$id/pause -ContentType "application/json" -Method POST).StatusCode).Equals(404)) {
            Write-Host "Conteneur $id introuvable"
        }
        else {
            Write-Host "Erreur Serveur"
        }
    }
    Elseif ($action -match "UnPause") {
        if (-not($id)) {
            Throw "Merci de préciser l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/unpause -ContentType "application/json" -Method POST
        if (((Invoke-WebRequest -Uri $apicall/containers/$id/unpause -ContentType "application/json" -Method POST).StatusCode).Equals(200)) {
            Write-Host "Conteneur $id en état : unpause"
        }
        elseif (((Invoke-WebRequest -Uri $apicall/containers/$id/unpause -ContentType "application/json" -Method POST).StatusCode).Equals(404)) {
            Write-Host "Conteneur $id introuvable"
        }
        else {
            Write-Host "Erreur Serveur"
        }
    }
    Elseif ($action -match "Attach") {
        if (-not($id)) {
            Throw "Merci de préciser l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/attach -ContentType "application/json" -Method POST
        if (((Invoke-WebRequest -Uri $apicall/containers/$id/attach -ContentType "application/json" -Method POST).StatusCode).Equals(101)) {
            Write-Host "No error, hints proxy about hijacking"
        }
        elseif (((Invoke-WebRequest -Uri $apicall"/containers/$id/attach" -ContentType "application/json" -Method POST).StatusCode).Equals(200)) {
            Write-Host "No error, no upgrade header found"
        }
        elseif (((Invoke-WebRequest -Uri $apicall"/containers/$id/attach" -ContentType "application/json" -Method POST).StatusCode).Equals(400)) {
            Write-Host "Bad parameter"
        }
        elseif (((Invoke-WebRequest -Uri $apicall"/containers/$id/attach" -ContentType "application/json" -Method POST).StatusCode).Equals(404)) {
            Write-Host "Conteneur $id introuvable"
        }
        else {
            Write-Host "Erreur Serveur"
        }
    }
    Else {
        if (-not($id)) {
            Throw "Merci de préciser l'id"
        }
        Invoke-WebRequest -Uri $apicall/containers/$id/json -ContentType "application/json" -Method GET
        if (((Invoke-WebRequest -Uri $apicall/containers/$id/json -ContentType "application/json" -Method GET | ConvertFrom-Json).State).Running -match "False") {
            Invoke-WebRequest -Uri $apicall/containers/$id -ContentType "application/json" -Method Delete
        }
        else {
            container -Uri $apicall -action "Stop" -id $id | Invoke-WebRequest -Uri $apicall/containers/$id -ContentType "application/json" -Method Delete
        }
    }
}
function Images {
    param (
        [Parameter(Mandatory=$true, postion = 0)][string]$Uri,
        [Parameter(Mandatory=$true, position = 1)][ValidateSet("List","Search","Inspect")]$Action,
        [Parameter(Mandatory=$false)][string]$term
        )
    if (-not($Uri) -and (-not($action))) {
        Throw "Paramètres URL et Action manquants"
    }
    if ($Action -match "List") {
        Invoke-WebRequest -Uri $apicall/images/json?all=0 -ContentType "application/json" -Method Get | ConvertFrom-Json | ft -Property Id,RepoTags,VirtualSize,Labels -AutoSize
    }
    Elseif ($Action -match "Search") {
        if (-not($term)) {
            Throw "Merci d'entrer un mot clé"
        }
        Invoke-WebRequest -Uri $apicall/images/search?term=$term -ContentType "application/json" -Method Get | ConvertFrom-Json | ft -Property name,desciption -AutoSize
    }
    Else {
        if (-not($name)) {
            Throw "Merci d'entrer le nom de l'image"
        }
        Invoke-WebRequest -Uri $apicall/images/$name/json -ContentType "application/json" -Method POST | ConvertFrom-Json
    }
    Else {}
}
function NetDriver {
    param (
        [Parameter(Mandatory=$true, Position = 0)][string]$Uri,
        [Parameter(Mandatory=$true, position = 1)][ValidateSet("List","Inspect","Create")][string]$Action,
        [Parameter(Mandatory=$false)][string]$id,
        [Parameter(Mandatory=$false)][string]$name,
        [Parameter(Mandatory=$false)][string]$driver,
        [Parameter(Mandatory=$false)][ValidateSet("subnet","iprange","gateway")][string]$ipam1,
        [Parameter(Mandatory=$false)][ValidateSet("subnet","iprange","gateway")][string]$ipam2,
        [Parameter(Mandatory=$false)][ValidateSet("subnet","iprange","gateway")][string]$ipam3
        )
    if (-not($Uri) -and (-not($Action))) {
        Throw "Merci d'entrer l'URL et l'action"
    }
    If ($Action -match "List") {
        Invoke-WebRequest -Uri $apicall/networks -ContentType "application/json" -Method Get | ConvertFrom-Json | ft -Property Id,Name,Driver -AutoSize
    }
    if ($Action -match "Create"){
        if ([string]::IsNullOrWhitespace($name)){'"Name"'+':'}else{'"Name"'+':'+'"'+$name+'"'+','}
        if ([string]::IsNullOrWhitespace($driver)){'"Driver"'+':'}else{'"Driver"'+':'+'"'+$driver+'"'+','}
        if ([string]::IsNullOrWhitespace($ipam1,$ipam2,$ipam3)){'"IPAM"'+':'+'{'+'"Config"'+':'+'['+'{'+'"Subnet"'+':'+'"'+'"'+','+'"IPRange"'+':'+'"'+'"'+','+'"Gateway"'+':'+'"'+'"'+','+'}'+']'+','}else {'"IPAM"'+':'+'{'+'"Config"'+':'+'['+'{'+'"Subnet"'+':'+'"'+$ipam1+'"'+','+'"IPRange"'+':'+'"'+$ipam2+'"'+','+'"Gateway"'+':'+'"'+$ipam3+'"'+','+'}'+']'+','}
        Invoke-WebRequest -Uri $apicall/networks/create -ContentType "application/json" -Method Post
    }
    Else {
        Invoke-WebRequest -Uri $apicall/networks/$netid -ContentType "application/json" -Method Get | ConvertFrom-Json | ft -Property Id,Name,Scope,Driver -AutoSize
    }
}
function Create {
    Param(
        [Parameter(Mandatory=$true, Position=1)][string]$name,
        [Parameter(Mandatory=$true, Position=2)][string]$image,
        [Parameter(Mandatory=$false)][ValidateSet("yes","no")][string]$daemon,
        [Parameter(Mandatory=$false)][string]$net,
        [Parameter(Mandatory=$false)][string]$addhost,
        [Parameter(Mandatory=$false)][ValidateSet("no","on-failure","always","unless-stopped")][string]$restart
    )
    $nameset = if ([string]::IsNullOrWhiteSpace($name)){}else{"--name "+$name}
    $imageset = if ([string]::IsNullOrWhiteSpace($image)){}else{$image}
    $daemonset = if ([string]$daemon -match "yes"){"-dit"}else{"-a=['STDIN'] -a=['STDOUT'] -a=['STDERR']"}
    $netset = if ([string]::IsNullOrWhiteSpace($net)){}else{"--net="+'"'+$net+'"'}
    $addhostset = if ([string]::IsNullOrWhiteSpace($addhost)){}else{"--add-hosts "+$addhost}
    $restartset = if ([string]::IsNullOrWhiteSpace($restart)){}else{"--restart="+$restart}
    Invoke-SSHCommand -SessionId 0 -Command "docker run"$restartset $daemonset $addhostset $netset $nameset $imageset
}
function Compose {
    param(
        [Parameter(Mandatory=$true, position = 1)][ValidateSet("Create","Deploy","Delete")]$Action,
        [Parameter(Mandatory=$true)][string]$composefile,
        [Parameter(Mandatory=$false)][string]$name,
        [Parameter(Mandatory=$false)][string]$image,
        [Parameter(Mandatory=$false)][string]$link,
        [Parameter(Mandatory=$false)][string]$ports,
        [Parameter(Mandatory=$false)][string]$expose,
        [Parameter(Mandatory=$false)][string]$volumes,
        [Parameter(Mandatory=$false)][string]$volumesfrom,
        [parameter(Mandatory=$false)][string]$workingdir,
        [Parameter(Mandatory=$false)][string]$network,
        [Parameter(Mandatory=$false)][string]$run
    )
    if ($Action -match "Create") {
        if ([string]::IsNullOrWhitespace($name)){}else{$composefile+':'} 
        if ([string]::IsNullOrWhitespace($image)){}else{"image:"+$image} 
        if ([string]::IsNullOrWhitespace($link)){}else{"link:"+$link} 
        if ([string]::IsNullOrWhitespace($ports)){}else{"ports:"+$ports} 
        if ([string]::IsNullOrWhitespace($expose)){}else{"expose:"+$expose} 
        if ([string]::IsNullOrWhitespace($volumes)){}else{"volumes:"+$volumes} 
        if ([string]::IsNullOrWhitespace($volumesfrom)){}else{"volumesfrom:"+$volumesfrom} 
        if ([string]::IsNullOrWhitespace($workingdir)){}else{"workingdir:"+$workingdir} 
        if ([string]::IsNullOrWhitespace($network)){}else{"network:"+$network}
        if ([string]::IsNullOrWhitespace($run)){}else{"run:"+$run}
    }
    if ($Action -match "Deploy") {

    }
    Else {
        Get-ChildItem *.dkr
        Remove-Item $name.dkr
    }
}
###### Code ######
$Uri = Read-Host "Entrez l'adresse IP du serveur Docker distant"
$username = Read-Host "Entrez le Username root du serveur Docker distant"
$Password = Read-Host "Entrez le mot de passe root du serveur"
$apiport =  Read-Host "Entrez le port API docker"
$apicall = $Uri+':'+$apiport
New-SshSession -ComputerName $Uri -Username $username -Password $Password
do {
    [int]$menu0 = 0
    while ($menu0 -lt 1 -or $menu0 -gt 4){
        Write-Host "Powershell Docker's Container Orchestration"
        Write-Host "1. Gestion des conteneurs"
        Write-Host "2. Gestion des drivers Réseau"
        Write-Host "3. Gestion des images"
        Write-Host "4. Quitter"
        [int]$menu0 = Read-Host "Votre choix ?"
    }
    switch($menu0){
        1{
            do {
                [int]$menu1 = 0
                while ($menu1 -lt 1 -or $menu1 -gt 4){
                    Write-Host "Gestion des conteneurs"
                    Write-Host "1. Lister les conteneurs actifs"
                    Write-Host "2. Surveiller un conteneur"
                    Write-Host "3. Déployer des conteneurs"
                    Write-Host "4. Quitter"
                    [int]$menu1 = Read-Host "Votre choix ?"
                }
            switch($menu1){
                1{
                    Write-Host "Liste des conteneurs : "
                    Containers -Action List -Uri $apicall
                    [string]$id = Read-Host "Entrez l'id d'un conteneur"
                    if (((Containers -Uri $Uri":"$apiport -Action Inspect -id).Status) -match "running") {
                        do {
                            [int]$menu4 = 0
                            while ($menu4 -lt 1 -or $menu4 -gt 4){
                                Write-Host "Etat du conteneur ((Container-Inspect -Uri $Uri -id $id).Name -replace "/","") : Running"
                                Write-Host "1. Eteindre le conteneur"
                                Write-Host "2. Redémarrer le conteneur"
                                Write-Host "3. Mettre en pause le conteneur"
                                Write-Host "4. Quitter"
                                [int]$menu4 = Read-Host "Votre choix ?"
                            }
                        switch($menu4){
                            1{Containers-Uri $apicall -Action Stop -id $id}
                            2{Containers -Uri $apicall -Action Restart -id $id}
                            3{Containers -Uri $apicall -Action Pause -id $id}
                            4{exit}
                        }
                        }
                        while ($menu4 -notmatch "4")
                    }
                    elseif (((Containers -Uri $apicall -Action Inspect -id $id).Status) -match "paused") {
                        do {
                            [int]$menu5 = 0
                            while ($menu -lt 1 -or $menu5 -gt 4){
                                Write-Host "Etat du conteneur ((Container-Inspect -Uri $Uri -id $id).Name -replace "/","") : En pause"
                                Write-Host "1. Relancer le conteneur"
                                Write-Host "2. Eteindre le conteneur"
                                Write-Host "3. Supprimer le conteneur"
                                Write-Host "4. Quitter"
                                [int]$menu5 = Read-Host "Votre choix ?"
                            }
                        switch ($menu5){
                            1{Containers -Uri $apicall -Action UnPause-id $id}
                            2{Containers -Uri $apicall -Action Stop -id $id}
                            3{Containers -Uri $apicall -Action Kill -id $id}
                            4{exit}
                        }
                        }
                        while ($menu5 -notmatch "4")
                    }
                    elseif (((Containers -Uri $apicall -Action Inspect -id $id).Status) -match "exited") {
                        do {
                            [int]$menu6 = 0
                            while ($menu6 -lt 1 -or $menu6 -gt 3){
                                Write-Host "Etat du conteneur ((Container-Inspect -Uri $Uri -id $id).Name -replace "/","") : Eteint"
                                Write-Host "1. Allumer le conteneur"
                                Write-Host "2. Supprimer le conteneur"
                                Write-Host "3. Quitter"
                                [int]$menu6 = Read-Host "Votre choix ?"
                            }
                        switch ($menu6){
                            1{Containers -Uri $apicall -Action Restart -id $id}
                            2{Containers -Uri $apicall -Action Kill -id $id}
                            3{exit}
                            }
                        }
                        while ($menu6 -notmatch "3")
                    }
                    else {
                        Remove-SSHSession -SessionId 0
                        exit
                    }
                }
                2{
                    Write-Host "Liste des conteneurs : "
                    Containers -Uri $apicall -Action List
                    [string]$id = Read-Host "Entrez l'id d'un conteneur à surveiller"
                    Write-Host "Processus en cours sur le conteneur (Container-Inspect -Uri $Uri -id $id).Name -replace "/","")"
                    Containers -Uri $apicall -Action Proc -id $id
                    Pause
                    Write-Host "Logs du conteneur (Container-Inspect -Uri $Uri -id $id).Name -replace "/","")"
                    Containers -Uri $apicall -Action Logs -id $id
                }
                3{
                    Write-Host "Paramètres obligatoires"
                    [string]$term = Read-Host "Merci de préciser un mot clé concernant l'image que vous cherchez"
                    Images -Uri $apicall -Action Search -term $term
                    [string]$name = Read-Host "Merci d'entrer le nom du nouveau conteneur"
                    [string]$image = Read-Host "Merci d'entrer le nom de l'image à déployer sur le conteneur"
                    Write-Host "Paramètres optionnels"
                    $daemon = Read-Host "Mode Daemon ? (Yes/No)"
                    NetDriver-List -Uri $apicall
                    $net = Read-Host "Entrez le nom du driver réseau à utiliser"
                    $addhost = Read-Host "Entrez les informations relatives aux autres hôtes avec lesquels le conteneur pourra communiquer"
                    #$restart = Read-Host "Définissez la politique de redémarrage du conteneur (no,on-failure,always,unless-stopped) "
                    [int]$nbcont = Read-Host "Combien de conteneurs à déployer ?"
                    do {
                        $i = 0
                        $a = $i+1
                        Create -name $name+"_"+$a -image $image -daemon $daemon -net $net -addhost $addhost -restart no
                    }
                    while ($a -notmatch $nbcont)
                }
                4{
                    Remove-SSHSession -SessionId 0
                    exit}
            }
            }
            while ($menu1 -notmatch "4")
        }
        2{
            do {
                [int]$menu2 = 0
                while ($menu2 -lt 1 -or $menu2 -gt 3){
                    Write-Host "Gestion des drivers réseau"
                    Write-Host "1. Lister les drivers réseau"
                    Write-Host "2. Créer un driver réseau"
                    Write-Host "3. Quitter"
                    [int]$menu2 = Read-Host "Votre choix ?"
                }
            switch($menu2){
                1{
                    NetDriver-List -Uri $apicall
                    [string]$netid = Read-Host "Entrez l'id du réseau à inspecter"
                    NetDriver-Inspect -Uri $apicall -netid $netid
                }
                2{
                    $name = Read-Host "Entrez le nom du nouveau driver"
                    NetDriver-List -Uri $apicall
                    $driver = Read-Host "Indiquez le driver à utiliser (en fonction de la liste ci-dessus)"
                    $ipam1 = Read-Host "Entrez le masque de sous-réseau"
                    $ipam2 = Read-Host "Entrez le range d'adresses IP"
                    $ipam3 = Read-Host "Entrez la Gateway"
                    NetDriver -Uri $apicall -Action Create -name $name -driver $driver -ipam1 $ipam1 -ipam2 $ipam2 -ipam3 $ipam3
                }
                3{
                    Remove-SSHSession -SessionId 0
                    exit}
            }
            }
            while ($menu2 -notmatch "3")
        }
        3{
            do {
                [int]$menu3 = 0
                while ($menu3 -lt 1 -or $menu3 -gt 6){
                    Write-Host "Gestion des images"
                    Write-Host "1. Lister les images"
                    Write-Host "2. Chercher une image"
                    Write-Host "3. Créer une image"
                    Write-Host "4. Déployer une image personnalisée"
                    Write-Host "5. Supprimer une image"
                    Write-Host "6. Quitter"
                    [int]$menu3 = Read-Host "Votre choix ?"
                }
            switch($menu3){
                1{
                    Images -Uri $apicall -Action List
                    [string]$name = Read-Host "Entrez le nom de l'image à inspecter"
                    Images -Uri $apicall -Action Inspect -name $name
                }
                2{
                    [string]$term = Read-Host "Merci de préciser un mot clé concernant l'image que vous cherchez"
                    Images -Uri $apicall -Action Search -term $term
                }
                3{
                    $composefile = Read-Host "Nom du fichier Compose"
                    $name = Read-Host "Nom du conteneur "  
                    $image = Read-Host "Image à déployer "
                    $link = Read-Host "Liens vers d'autres conteneurs "
                    $ports = Read-Host "Translation de ports à effectuer "
                    $expose = Read-Host "Ports à exposer "
                    $volumes = Read-Host "Mapper un dossier du conteneur vers l'hôte "
                    $volumesfrom = Read-Host "Mapper un dossier d'un autre conteneur "
                    $workingdir = Read-Host "Définir un dossier de base "
                    $network = Read-Host "Préciser un driver réseau"
                    #$run = Read-Host "Indiquez les paquets à installer"
                    Compose -Action Create -composefile $composefile -name $name -image $image -link $link -ports $ports -expose $expose -volumes $volumes -volumesfrom $volumesfrom -workingdir $workingdir -network $network | Out-File $composefile"_build.dkr"
                }
                4{
                    Write-Host "liste des images personnalisées : "
                    Get-ChildItem *.dkr
                    $file = Read-Host "Indiquez l'image personnalisée à utiliser"
                    $name = Get-Content $file | select -First 1
                    $image = (Get-Content $file | select -Skip 1 -First 1 | Select-String -Pattern "image:") -replace ".....:",""
                    $link = (Get-Content $file | select -Skip 2 -First 2 | select-string -Pattern "link:") -replace "....:",""
                    $ports = (Get-Content $file | select -Skip 3 -First 3 | select-string -Pattern "ports:") -replace ".....:",""
                    $expose = (Get-Content $file | select -Skip 4 -First 4 | select-string -Pattern "ports:") -replace "......:",""
                    $volumes = (Get-Content $file | select -Skip 5 -First 5 | select-string -Pattern "volumes:") -replace ".......:",""
                    $volumesfrom = (Get-Content $file | select -Skip 4 -First 4 | select-string -Pattern "volumesfrom:") -replace "...........:",""
                    $workingdir = (Get-Content $file | select -Skip 4 -First 4 | select-string -Pattern "workingdir:") -replace "..........:",""
                    $network = (Get-Content $file | select -Skip 4 -First 4 | select-string -Pattern "network:") -replace ".......:",""
                    #$run = (Get-Content $file | select -Skip 4 -First 4 | select-string -Pattern "volumesfrom:") -replace "...:",""
                    Containers -Uri $apicall -Action Create -name $name -image $image -link $link -ports $ports -expose $expose -volumes $volumes -volumesfrom $volumesfrom -workingdir $workingdir -network $network
                }
                5{
                    Get-ChildItem *.dkr
                    $name = Read-Host "Indiquez le nom de l'image à supprimer"
                    Compose -Action Delete -name $name
                }
                6{
                    Remove-SSHSession -SessionId 0
                    exit}
            }
        }
        while ($menu3 -notmatch "5")
        }
        4{
            Remove-SSHSession -SessionId 0
            exit
        }
    }
}
while ($menu0 -notmatch "4")
