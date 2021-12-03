# HH 4 B

Gure alabaren gelan gurasoak zertan aritzen ginen azaltzeko bideo bat-edo eskatu ziguten. Nire gaur egungo lana ez denez haurrentzat ikusgarriegia, lehenago egiten nuenaren adibide ttiki bat prestatu nuen. Bideoa baino gustorago erabiliko zutelakoan.

Joku honetan, gelakideen argazkiak banan-banan agertzen ziren eta hiru izenen artean zuzena aukeratu behar da hurrengo ikaslera pasatzeko.

Kodean aldaketatxo batzuk egin ditut orokorragoa egiteko eta hemen uzten dut, nahi duenak erabil dezan.

## Pertsonalizazioa

Exekutagarriaren maila berean dagoen `app.props` izeneko fitxategiak jokoaren hainbat konfigurazio parametro definitzen ditu. Fitxategi hau editatu eta ondorengo azaltzen ditudan aldaketak egin daitezke. Kontutan izan fitxategi honetako lerro baten hasieran `#` ikurra agertzean ez zaiola kasurik eginen lerro jakin horri. Adibidez:

```properties
photos-dir=photos
#photos-dir=animaliak
```

Fitxategian horrelako lerro multzo bat baldin badago, argazkiak `photos` direktoriotik hartuko dira eta `animaliak` direktorioa berriz ez da ezertarako erabiliko.

### Argazkiak

Jokoan agertuko diren argazkiak `res/photos` karpetan daudenak dira (defektuz) eta argazkiaren izenak agertuko dira aukeren artean (luzapenik gabe, jakina). Argazki multzo desberdinak izan daitezke `res` barruko karpeta desberdinetan. Gero jokuan zein multzotatik hartuko diren aldatu dezakegu `app.props` fitxategiko `photos-dir` propietatearen bidez.

### Logoa

Ikastetxearen logotiporen bat jarri nahi izanez gero, `res/logo.png` ordezkatzea bertzerik ez duzue. Agertzerik ez baduzue nahi, ezabatu eta kitto.

### Musika

Jokoan zehar entzuten den musika aldatu nahi izanez gero, `res/music.mp3` ordezkatzea bertzerik ez duzue. Musikarik ez baduzue nahi, ezabatu eta kitto.

### Izenburua

Logoaren ondoan izenburu bat agertuko da, gelaren izena jarri nuen nik. Hau aldatu nahi izanez gero `app.props` fitxategian `title` propietatearen balioa aldatu.

### Asmatzean txaloak

Izen bat asmatzean, txalo egiten duten esku batzuk agertuko dira. Irudi hau ere aldatu daiteke `res/applause.png` ordezkatuz. Eta egiten duen animazioaren propietate hauek aldatzen ahal dira `app.props` fitxtegian:

* pantailan agertuko den denbora (`applause.show-time`)
* hasierako eskala (`applause.start-scale`)
* bukaerako eskala (`applause.end-scale`)

### Bukaera

Izen guztiak asmatzean irudi bat agertuko da eta bertan testu bat. Testua klikatzean berriz hasiko jokoa. Irudia eta testua aldatu daitezke `res/end.png` ordezkatuz eta `app.props` fitxategiko `ending-text` propietatearekin. Irudiaren barruan testuak izanen duen posizioa ere aldatu daiteke, ehunekotan jarriz `endint-text.x-pos-percentage` eta `endint-text.y-pos-percentage` propietateetan.

### Pantaila osoa

Fitxategiko `fullscreen` propietatearekin jokoa hasieratik pantaila osoan nahi dugu edo ez adieraziko dugu. Aukerak:

* true
* false (defektuz)

Jokoaren edozein unetan aldatu daiteke pantaila osotik leihora eta alderantziz F11 botoia sakatuz.

## Assets

* [Digital kid loop](https://www.dl-sounds.com/royalty-free/digital-kid-loop/)
* [Applause emoji](https://freepngimg.com/thumb/emoji/61612-applause-clapping-fonts-hand-noto-emoji.png)
* [Wurper Regular font](https://www.fontspace.com/wurper-regular-font-f13454)