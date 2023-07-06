# m122-script
M122 - Abläufe mit einer Scriptsprache automatisieren

## Projektbeschrieb

Dieses Script wird ein Backup in regelmässigen Abständen von einer Webseite erstellen. Dadruch soll verhindert werden, falls der Server zum Beispiel abstürtzt, dass dadruch der Inhalt nicht verloren geht. Die erstelleten Backups und auch die Fehlermeldungen in einem Logfile festgehalten werden.

### Muss:

 - Erstellt Backupverzeichnis
 - Backupverzeichnis ist im Config File angegeben.
 - Im config File gibt es angaben zum webserver 1 und webserver 2.
 - Kopiert alle Dateien auf dem Webserver, das inkludiert auch HTML, CSS wie auch JS und Sonstiges.
 - Log File Pfad wird in config file angegeben. 

### Kann:

- Man kann entweder alle Dateien oder auch nur ausgewählte backupen. Diese Angabe macht man über ein Property im configle file mit "yes" und "no".
- Man kann auswählen, welche Dataien/Ordner man backupen will. Diese Angabe macht man über ein Property im config file, die Pfade der Dateien und Verzeichnisse werden komasepariert aufgeführt.
- Man kann mehrere Webseiten auf einmal Backupen.

## Activity Diagram
![activityDiagramM122 drawio](https://github.com/metboi/m122-script/assets/70205436/4264a62f-daa7-46a5-80d4-ba64af5bcb1f)
