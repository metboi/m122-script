# m122-script
M122 - Abläufe mit einer Scriptsprache automatisieren

## Projektbeschrieb

Dieses Script wird ein Backup in regelmässigen Abständen von einer Webseite erstellen. Dadruch soll verhindert werden, falls dass oder der Server abstürtzt, dass dadruch der Inhalt nicht verloren geht. Die erstelleten Backups und auch Fehlermeldungen in einem Logfile festgehalten werden.

### Muss:

 - Erstellt Backupverzeichnis
 - Backupverzeichnis ist im Config File angegeben.
 - Kopiert alle Dateien auf dem Webserver, das inkludiert auch HTML, CSS wie auch JS und Sonstiges.
 - Log File Pfad wird in config file angegeben. 

### Kann:

- Man kann auswählen, welche Dataien/Ordner man backupen will.
- Man kann mehrere Webseiten auf einmal Backupen
- 

## Activity Diagram
![activityDiagram drawio](https://github.com/metboi/m122-script/assets/70205436/f4b68e95-cdeb-487e-a76b-69b2e690353c)

