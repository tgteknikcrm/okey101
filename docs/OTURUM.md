# Oturum günlüğü

Bu dosya bir oturumun tamamını anlatır: ne istendi, ne yapıldı, **neyi yanlış
yaptım**, nasıl bulundu, nasıl düzeltildi ve ne ölçüldü. Övünme listesi değil —
asıl değerli kısmı hataların anlatıldığı yerler.

Başlangıç: `5c99f15` · Bitiş: `c13ff92` · **13 commit**
Test: 258 → **277** · Canlı: <https://tgteknikcrm.github.io/okey101/>

Teknik harita için [ARCHITECTURE.md](ARCHITECTURE.md), çalışma kuralları için
[../CLAUDE.md](../CLAUDE.md).

---

## Özet: bu oturumda ne oldu

Oturum "üç hata var" diye başladı, sonunda oyunun **masa düzeni baştan
kuruldu**, **iki temel jest geri geldi**, **botlara yeni bir oyun yolu
öğretildi** ve yol üstünde **on bir ayrı kusur** daha çıktı.

En önemli üç ders:

1. **Üç tur boyunca yanlış şeyi düzelttim.** "Desteden taş çekemiyorum"
   şikâyetinde anahtar kelime **"tutup"** idi — sürükleme. Ben dokunmayı
   düzeltip durdum. Bkz. [Bölüm 4](#4-desteden-taş-çekemiyorum--üç-tur-boyunca-yanlış-şeyi-düzelttim).
2. **Bir düzeltmem bir özelliği yok etti.** Kazara ıskartayı önlemek için
   sürükleyip atmayı kaldırdım — ve insanların taş atmak için kullandığı **tek
   yolu** kaldırmış oldum. Bkz. [Bölüm 5](#5-elimdeki-taşı-atamıyorum--kendi-düzeltmemin-yıktığı-özellik).
3. **Sessizce reddeden bir kontrol, bozuk kontroldan ayırt edilemez.** Bu
   projede en çok "hata" olarak bildirilen şey buydu. Bkz.
   [Bölüm 4b](#4b-sessiz-red).

---

## 1. Başlangıç durumu ve ilk kırılma

Oturum, önceki turdan devreden yarım bir düzenlemeyle başladı: `RackWidget`'tan
`onDragOut` alanını silmiştim ama **yapıcıdaki parametresini ve çağıran üç yeri
silmemiştim**. Yani depo derlenmiyordu.

**Ders:** yarım bırakılmış bir düzenleme, en ucuz kontrolle (`flutter analyze`,
iki saniye) yakalanır. Devam etmeden önce onu bitirdim.

---

## 2. Üç hata bildirimi + düzen talebi

> "çift açan yok çalıştığına emin misin? birde desteden taş çekemiyorum … ıstaka
> ile oynarken taşı bırakmıyor … ıstakanın yüksekliğini %20 azalt … sırala işle
> masaya koy bu butonlar ıstakanın üstünde olsun … sol sağ üstte profiller
> olsun"

### 2a. Botlar hiç çift açmıyordu

**Bulgu:** 10.000 oyunluk koşuda `pairs` ve `pairsWithOkey` **sıfır** kez
görülmüştü.

**Kök neden bir hata değil, bir eksiklikti:** hiçbir botun *planı* yoktu.

- Bir el şansa ortalama **~2 çift** tutar; açmak için **5** gerekir. Yani beş
  çift asla dağıtılmaz.
- `HardBot` **7** çift arıyordu (1/833 el), `MediumBot` **6** (1/108),
  `EasyBot`'un çift kolu **hiç yoktu**.
- Beşe ulaşmanın tek yolu **erken karar verip toplamak**tır.

**Sorun:** botlar durumsuz. `decide(view, rng)` sadece bir görüntü alır, turlar
arası hafızası yoktur.

**Çözüm:** planı her tur **ıstakadan yeniden türetmek**. Çift sayısı tam da buna
uygun — bot bu yolu oynadıkça sayı sadece artar.

```dart
BotUtils.pairsRoad(view, bestPoints:) -> PairsRoad(pairs, committed)
```

Bağlanmış bir el: eşini tamamlayan taşı çeker, asla çift olamayacak taşı atar
(`DiscardStrategy` → `pairsFocus`), ve yeter sayıya ulaşınca koyar.

**Sonra çıkan ikinci kusur:** her bot 5 çiftten 11'e **tek hamlede** sıçramayı
bekliyordu. 38.000 simüle elde bu **sıfır kez** oldu. Yani çift açmak
kendi kendine kaybetmekti. `pairsToLayAfterOpening` her yeni çifti geldikçe
koyuyor artık.

**Ölçüm** (hard ×4, 1.319 el):

| | Önce | Sonra |
|---|---|---|
| Çift koyma hamlesi | **0** | 880 → **1.331** (kademeli koymayla) |
| Güç (çift yolu kapalı aynı bota karşı, 400 maç) | — | **198–202** (fark yok) |
| Zorluk sırası (hard/medium, 400 maç) | 61,7 / 38,3 | **237 / 163** |

**Dürüst not:** çiftle **bitirme** (11 çift) hâlâ olmuyor. 20 taşlık deste
tükenmeden 11 çift toplamak bu kural setinde neredeyse imkânsız. Şikâyet "çift
açan yok"tu; o çözüldü ve masada görünüyor.

### 2b. Düzen yeniden kuruldu

- Rakipler **küçük daire + isim** olarak kenarlara alındı (`SeatChip`)
- Iskarta yığınları herkesin kendi kenarına
- Eylem düğmeleri sağ raydan **ıstakanın üstüne** yatay şeride
- Istaka yüksekliği `0.37 → 0.30`
- Çift paneli 4 sütundan **2**'ye
- Boşalan ~130 piksel ortadaki ızgaraya

**Commit:** `ae147a7`

### 2c. Yol üstünde çıkan kusurlar

| Kusur | Sonucu |
|---|---|
| `maxJokersPerMeld: 0` → `bestPairs` **RangeError** | Ayarlar'daki çevirici 0'a iniyor; canlı çökme |
| `_GridPainter` her zaman 13 sütun boyuyordu | 2 sütunluk çift paneli boş hücrelerini yan rayın üstüne taşırıyordu (`CustomPaint` kırpmaz) |
| `_applyHuman` her hamlede **seçimi siliyordu** | Iskarta düğmesi seçimi elle temizlemek zorundaydı |
| Reddedilen bot yedek hamlesi durumu **değiştirmeden** dönüyordu | Bot döngüsü sonsuza kadar dönüyor, `botThinking` açık kalıyor, masa kalıcı kilitleniyordu |
| `_disposed` tek yönlü mandaldı | Riverpod yeniden kurulumunda tahta kalıcı ölüyordu |

---

## 3. Yayınlama zinciri: iki kabuk tuzağı

**Birinci:** Git Bash'te `--base-href /okey101/`, MSYS tarafından
`C:/Program Files/Git/okey101/` diye yeniden yazılıyor ve derleme reddediyor.
Çözüm: `publish.sh` içine `MSYS_NO_PATHCONV=1`. **Commit:** `60ba4dd`

**İkinci:** dosya CRLF satır sonlu olduğu için ters bölü ile satır devamı
çalışmıyor — kabuk satırları birleştirmiyor, Flutter'a yalnız bir ters bölü
gidiyor ve `Target file "n" not found` diyor. Çözüm: tek satır.
**Commit:** `19ac8c5`

**Ders:** kabuk betiği "çalışıyor gibi" görünüp sessizce farklı bir şey
yapabilir. Çıktıyı oku.

---

## 4. "Desteden taş çekemiyorum" — üç tur boyunca yanlış şeyi düzelttim

Bu oturumun en pahalı bölümü. Aynı şikâyet **dört kez** geldi.

### Tur 1 — dokunma hedefini büyüttüm

Desteyi kaydırma alanının dışına çıkardım, dolgulu ve çerçeveli büyük bir hedef
yaptım, göstergeyi üst köşeye taşıdım.

**Gerçek bir kusurdu:** deste, gösterge ve ıskarta ile birlikte bir
`SingleChildScrollView` içindeydi. 390 mantıksal pikselden kısa **her** yatay
ekranda sütun taşıyor ve deste kırpılıyordu — üstelik kaydırma çubuğu bile
görünmüyordu. 640×360'ta desteye dokunmak hiçbir şey yapmıyordu. Testle
doğruladım: düzeltmeden önce "tapping the deck drew nothing at Size(640, 360)".

**Ama şikâyeti çözmedi.**

### 4b. Sessiz red

Tur 2'de ikinci gerçek kusuru buldum: **deste yalnızca çekmenin tam olarak
yasal olduğu anda dokunulabilirdi.** Diğer her an dokunmak *hiçbir şey*
yapmıyordu — mesaj yok, titreme yok.

O "diğer anlar" hiç de az değil:

- Botlar düşünürken (her turun arasında 3 bot × ~2 saniye)
- **Eli dağıtan koltuk 22 taşla ve "at" aşamasında başlıyor** — her maçta 2-3 el
- Zaten çektikten sonra

Düzeltme: deste ve komşunun yığını **her zaman** dokunulabilir; motor reddedip
**sebebini söylüyor** ("Sıra sizde değil." / "Sıra şöyle: önce bir taş çekin,
sonra bir taş atın."). `_applyHuman` artık sessizce dönmüyor.

Aynı commit'te: hata fırlatan bir bot beyni artık masayı kilitleyemiyor, ve
menüye **yapı damgası** eklendi — "hâlâ eski hatayı görüyorum" ile "düzeltme işe
yaramamış" birbirinden ayrılsın diye.

**Commit:** `6b2e5f7`

### Tur 3 — "kaç kere söyleyeceğim?"

Bu turda **dik/dönmüş modu** test ettim. `ForceLandscape` dik tutulan telefonda
tüm arayüzü `RotatedBox` ile döndürüyor ve dokunma o dönüşümden geçiyor — o yolu
o güne kadar tarayıcıda hiç denememiştim. Gerçek **touch** olaylarıyla denedim:
**çalışıyordu** (20→19, taş geldi).

### Kök neden: kelimeyi kaçırmışım

> "desteden **tutup** taş çekemiyorum"

**Tutup** = tutarak, sürükleyerek. Bir önceki mesajdaki "hâlâ tıklamalı" da
aynı şeyi söylüyordu: *sadece tıklamayla oluyor, ben tutup çekmek istiyorum.*

Ben üç tur boyunca **dokunmayı** düzelttim. İstenen **sürükleme** idi ve o
hiç yoktu.

**Ders:** aynı şikâyet ikinci kez geldiğinde, düzeltmeye devam etmek yerine
**şikâyetin kelimelerine** dönmek gerekir. Üçüncü turda kullanıcının
sinirlenmesi haklıydı.

---

## 5. "Elimdeki taşı atamıyorum" — kendi düzeltmemin yıktığı özellik

Sürükleme eksikliğini tam düzeltirken ikinci şikâyet geldi.

**Sebep bendim.** Daha önce "kazara ıskarta" diye bir kusur bulmuştum: sürüklemeyi
ıstakanın 8 piksel üstünde bırakmak taşı atıyordu, ve alt sıradan üst sıraya taş
taşırken bu mesafe 46 piksel — yani sıradan bir düzenleme turu bitiriyordu.
Doğru bir tespitti. **Ama çözümüm özelliği tamamen kaldırmaktı** ve böylece
insanların taş atmak için kullandığı tek jesti yok etmiş oldum. Geriye önce taşı
seçmeni isteyen bir düğme kaldı — kimsenin eli oraya gitmiyor.

**Doğru çözüm:** jesti geri getir, ama **hedefi olsun**.

- Istaka artık "dışarı çıktı" diye karar vermiyor; parmağın **nerede olduğunu**
  bildiriyor.
- Masa bunu **kendi ıskarta yığınının dikdörtgeniyle** (28 piksel payla)
  karşılaştırıyor.
- Nişan alınan atış gidiyor, kazara olan gitmiyor.

Aynı commit'te **desteden ıstakaya sürükleme** eklendi (`Draggable` /
`DragTarget`), yani asıl istenen jest.

**Teknik tuzak:** ıstaka bırakma noktasını son sürükleme güncellemesinden
alıyordu ve o **geriden geliyor** — tam yığının üstüne bırakılan taş 160 piksel
geride raporlanıyordu. Artık parmağın gerçekten kalktığı nokta kullanılıyor.

**Commit:** `3ad62a1` · Doğrulama: dik telefonda gerçek dokunmayla, desteden
ıstakaya sürükleme 20→19 yaptı; ıstakadan yığına sürükleme taşı attı ve sıra
geçti.

---

## 6. "Sıra karşıya geçince taşlarla oynayamıyorum"

**Kök neden:** `RackWidget(enabled: session.isHumanTurn)`.

Ama **taş dizmek bir hamle değil.** Motor slotları hiç görmüyor;
`setRackSlots`, `toggleSelection`, `sortForRuns`, `sortForSets` — hiçbiri sıra
kontrolü yapmıyor. Kilit tamamen arayüz katmanındaydı ve her turunda üç bot
oynadığı için **elinin çoğunda** kendi taşlarına dokunamıyordun.

`RackWidget`'ın `enabled` parametresi **tamamen kaldırıldı** — yanlışlıkla
tekrar kilitlenemesin diye. Aynı kilit hamle olmayan üç yerden daha kalktı:
Sırala, masadaki grubu inceleme, ve sıra dışıyken ıskartaya sürükleme (bu
gerçek bir hamle, o yüzden sessizce yutulmak yerine "Sıra sizde değil."
diyerek reddediliyor).

**Commit:** `6c4507c` · Test eski kilide karşı doğrulandı: *"the rack refused an
arrangement while a bot was playing"*.

---

## 7. Masa geometrisi: yarısını doğru kurdum, kullanıcı düzeltti

### İlk deneme — "her profilin altında onun çekeceği taş"

Kullanıcının tarifinden şu kuralı çıkardım: *bir profilin altındaki yığın, o
oyuncunun aldığı yığındır.* Sağdaki senden çeker → senin attığın onun altında.
Kısmen doğruydu. **Commit:** `f9d7f54`

Aynı commit'te bilgi şeridi (`_HudBar`) kaldırıldı, gösterge destenin altına
döndü, ve fark ettiğim bir kusur düzeltildi: sahte okey `✻` (U+273B) ve okey
yıldızı `★` (U+2605) **Unicode karakteriydi** — Roboto'da da her telefonun
yedek yazı tipinde de yoklar, yani **boş kutu** olarak çıkabiliyorlardı. Ekran
görüntüsünde tam da bunu yakaladım. İkisi de artık **canvas'a çiziliyor**.

### Kullanıcının düzeltmesi

> "sağdaki profil yükseklikte ortalı değil, onun attığı taş tam üstünde olmalı"

Haklıydı ve benim kuralım eksikti. Doğrusu **tek bir kural değil, geometri**:

> Bir yığın, ilgilendirdiği **iki oyuncunun arasındaki köşede** durur — atan ve
> alma hakkı olan. Okey sağa döndüğü için taşlar **sağ kenardan yukarı**, **sol
> kenardan aşağı** akar.

```
sol üst: karşıdaki attı            sağ üst: sağdaki attı
   ● soldaki          (tahta)          ● sağdaki
sol alt: soldaki attı              sağ alt: SEN attın
  (alabileceğin tek yığın)         (atmak için buraya bırak)
```

Sonuç: **her profil kendi kenarının tam ortasında**, biri üstünde biri altında
yığınla. Basit "üst/alt" kuralı yok çünkü akış iki kenarda ters yönde.

**Commit:** `8c8c73d`

**Ders:** kullanıcının tarifini bir kurala indirgerken, **tarifin her cümlesini**
kurala karşı sınamak gerekiyordu. "Onunki yukarıda" cümlesi ilk kuralı zaten
çürütüyordu; ben o cümleyi atlamışım.

---

## 8. Header: yine iki turda

**Tur 1:** header'ı mevcut üst şeridin içine kurdum — geri/ayarlar solda,
karşıdaki profil ortada, kese sağda. Gerekçem yükseklik tasarrufuydu (yatay
telefonda 390 piksel var, ıstaka ve düğmeler beşte ikisini alıyor).
**Commit:** `ded433a`

**Tur 2:** kullanıcı "**en üstte** olsun, profil hizasında değil" dedi. Haklı —
ben tasarrufu talebin önüne koymuşum. Header kendi satırına alındı (34 px),
profil şeridi altına (38 px). Aynı turda "El 2/11" ve puan tablosu simgesi
kaldırıldı, ve **Sırala** düğmesi ıstakanın sağındaki **Seri / Per** ikilisine
dönüştü. **Commit:** `1173424`

**Teknik tuzak:** o sütunu `Expanded` ile kurunca düzen çöktü — ıstaka kendi
boyunu kendi hesapladığı için `CrossAxisAlignment.stretch` satırdan **sonsuz
yükseklik** istiyor. Düğmeler sabit boylu yapıldı.

### Kese hakkında dürüst not

Altın ve elmas **gerçek ve kalıcı** (kendi anahtarlarında iki tam sayı). Ama
**hiçbir şey onları harcamıyor** — sadece gösterge. "Altın Yükle" bir satın alma
taklidi yapmıyor, açıkça *"Okey 101 ücretsizdir ve hiçbir şey satmaz; altın
ikramımız"* diyor. Bunu commit mesajında da, kullanıcıya da açıkça söyledim.

---

## 9. "Taşlar patlıyor" — iki ayrı sebep

### 9a. Sürüklerken kayma ve kendiliğinden animasyon

> "tıkladığında sarı border var onu kaldır … taşları üzerine gelince yer
> değiştirmesin … kendi kendine animasyon yapmasın"

Üçü de ıstakanın kendi kendine kıpırdamasıydı:

1. **Sarı çerçeve** sıra oyuncudayken sürekli yanıyordu. Hiç sönmeyen bir halka
   "bir şey ters" gibi okunur. Artık sadece üzerine taş sürüklenirken yanıyor.
2. **Sürüklemenin her karesinde tüm diziliş yeniden yazılıyordu** — parmağın
   üzerinden geçtikçe taşlar kaçışıyor, bazıları alt sıraya düşüyordu. Artık
   sadece taşınan taş hareket ediyor; diziliş **bir kez**, bırakışta değişiyor.
3. Istaka taşları `AnimatedPositioned` idi → düz `Positioned`.

**Bu turda kendi düzeltmemin açtığı bir hata:** 4. yuvaya bırakılan taş **8.
yuvaya** düşüyordu. Sebep: bırakma noktasını `globalToLocal` ile ıstakanın **tüm
bandına** göre çeviriyordum, ama yükseklik sınırı devreye girince taşlar o
bandın **ortasında** duruyor — yani her yatay telefonda. Boşluk (`_insetX`)
çıkarılıyor artık.

**Commit:** `9da4f82`

### 9b. Tek taş bıraktın, on yedi taş oynadı

Kullanıcı "taşlar hâlâ patlıyor" deyince asıl sebebi buldum:

`RackLayout.move` iki konum arasındaki **bütün aralığı** döndürüyordu. Tek sıra
içinde bu makul görünür; **iki sıra arasında felaket**:

> El dağıtılırken üst sıra **tam dolu** gelir (13 taş), kalanlar alt sırada. Alt
> sıranın son taşını üst sıranın 4. yuvasına taşıdığında 3'ten 20'ye kadar tüm
> yuvalar dönüyordu: üst sıra bir kayıyor, sonuncusu alt sıraya düşüyor, alt
> sıra da onunla kayıyor. **Bir taş bıraktın, on yedi taş oynadı.**

**Yeni davranış:** taş komşularını **kendi sırasındaki en yakın boşluğa** doğru
iter, daha ötesine değil. Hedef sıra baştan sona doluysa iki taş **yer
değiştirir**. Yani **en fazla iki taş** oynar. Kaldırdığın yerdeki boşluk orada
kalır — elle oynadığın bir ıstakada da öyle olur.

**Commit:** `10546c8` · Test eski dönüşe karşı **on yedi** ile başarısız oluyor.

---

## 10. Son rötuşlar

> "sağdaki karede çift yazıyor yazmasın, arkasındaki gölgeyi de kaldır, bu
> kareleri %10 küçült, aşağıya 1 sıra daha ekle"

- Çift şeridinin başlığı ve arkasındaki renkli kutu kaldırıldı
- Izgara kareleri %10 küçültüldü
- Tahta **5 sıra** tutuyor

Son ikisi bağlantılı: sadece genişliğe göre boyutlandırınca kareler o kadar uzun
kalıyordu ki dörtten fazlası sığmıyordu. Beşinci sırayı öylece eklemek onu alt
kenarda **kesilmiş** gösterirdi — yarım sıra boş kare "geniş" değil "bozuk"
görünür. Artık yükseklik de boyuta karar veriyor.

**Commit:** `c13ff92`

---

## 11. Test disiplini: neyi yanlış yaptım

Bu oturumda kural şuydu: **her yeni regresyon testi, düzeltilmemiş koda karşı
başarısız olduğu görülerek yazıldı.** Üç kez ilk denemede **ısırmadı** ve sebebi
her seferinde testin kendisiydi:

| Test | Neden ısırmadı | Düzeltme |
|---|---|---|
| Çoklu dokunma (ikinci parmak) | Geri alma betiğim aslında uygulanmamıştı (`replace` sessizce eşleşmedi) | Çıpayı `assert` ile doğrula |
| Deste kırpılması | Desteyi sütunda **öne** almıştım; eski sırayı (gösterge → deste) kurmadan test geçiyordu | Yayınlanmış sırayı birebir kur |
| Bırakma yuvası (`_insetX`) | 390 genişlikte yükseklik sınırı devreye girmiyor, boşluk sıfır kalıyor | Gerçekten ısıran bir sınır ver (`maxHeight: 70`) |

**Ders:** "test geçti" ile "test bir şey koruyor" aynı şey değil. Bir testin
değeri, **düzeltilmemiş koda karşı başarısız olduğunu görmekle** ölçülür.

Bir de saf bir düzenleme hatası: bir `replace` çağrım **yanlış testin içine**
düştü (dikey HUD testine, yatay düzen testi yerine) çünkü iki testte aynı satır
vardı. `flutter test` yakaladı.

Ve bir dil kuralı tuzağı: `lib/domain/` içinde matematik kütüphanesini bir
**yorum satırında** anmak bile `purity_test`'i düşürüyor — test metni birebir
arıyor.

---

## 12. Arka plandaki derin inceleme

Oturumun ortasında üç hata için arka planda çok ajanlı bir inceleme koştu ve
sonuçları geldiğinde **kendi bulgularımı hem doğruladı hem genişletti**:

**Doğruladıkları:** dağıtan koltuğun 22 taşla başlaması (400 maçta %24,75'i
oyuncuya denk geliyor), çift yolunun kapalılığı (benim sayılarımla aynı
çıktı: `bestPairs ≥ 5` → %5,36), desteyi kırpan kaydırma alanı.

**Benim bulmadıklarım:** ıstakadaki çoklu dokunma kilitlenmesi (dinlenen bir
başparmak taşı havada bırakıyor), 5→11 tek hamle kapısı, `maxJokersPerMeld: 0`
çökmesi, denetleyicideki durum kayıpları.

**Katılmadığım bir bulgu:** "Geri Al `pendingMelds`'i siliyor" bir hata olarak
raporlanmıştı. Bence değil — Geri Al turu başına döndürür, o tur içinde
hazırlanan taslak da o turun parçasıdır. Değiştirmedim ve gerekçemi yazdım.

**Ders:** başka bir ajanın raporu da doğrulanmadan kabul edilmez. Her maddeyi
kodda kendim okudum; ısırdığını görmediğim hiçbir düzeltmeyi "doğrulandı" diye
yazmadım.

---

## 13. Ölçümler

Hepsi bu oturumda, bu makinede alındı.

| Ölçüm | Sonuç |
|---|---|
| Çift koyma (hard ×4, 1.319 el) | 0 → 880 → **1.331** |
| Çift yolunun güce etkisi (400 maç, A/B) | **198–202** — fark yok |
| Zorluk sırası (hard/medium, 400 maç) | **237 / 163** |
| Grup uzunluğu dağılımı (1.628 el, 20.612 grup) | 3–4 taş %84,6 · 5 taş %8,1 · 6–8 %6,8 · **9+ %0,51** |
| 8'den uzun grup barındıran el | **%6,02** |
| Deste dokunulabilirliği (640×360) | düzeltmeden önce **hiç çekmiyor**, sonra çekiyor |
| Test sayısı | 258 → **277** |

Tarayıcı doğrulamaları gerçek **touch** olaylarıyla, hem 844×390 yatayda hem
390×844 dik (döndürülmüş) modda yapıldı — fare olayları `RotatedBox` yolunu hiç
sınamıyor.

---

## 14. Açık kalanlar ve bilinçli sınırlar

Bunları saklamıyorum:

1. **Çiftle bitirme (11 çift) pratikte olmuyor.** Kural setinin sonucu, hata
   değil. 20 taşlık deste tükenmeden 11 çift toplanamıyor.
2. **Altın ve elmas hiçbir şeye yaramıyor.** Gösterge. Bahis/ödül olarak
   bağlamak ayrı bir karar.
3. **Puan tablosu düğmesi kaldırıldı** (kullanıcı istedi). Rakiplerin puanı
   kendi dairelerinde; tam tablo her el sonundaki özet sayfasında.
4. **GitHub Actions boru hattı kurulu değil.** Token'da `workflow` yetkisi yok;
   `gh-pages` dalından yayınlanıyor. Tek seferlik çözüm README'de.
5. **Çift şeridi 11 çiftte kayar.** 46 piksel genişlikte 11 sıra sığmıyor;
   kaydırılabilir.
6. **Portre düzeni bir yedek.** Telefonlar `ForceLandscape` ile döndürülüyor;
   portre yalnızca dar bir masaüstü penceresi için.

---

## 15. Bu oturumun commit'leri

| # | SHA | Ne |
|---|---|---|
| 1 | `ae147a7` | Yatay masayı yeniden kur, çift yolunu ulaşılabilir yap |
| 2 | `60ba4dd` | Git Bash'in base href'i bozmasını engelle |
| 3 | `6b2e5f7` | Hiçbir dokunmayı sessizce reddetme; fırlatan bot masayı kilitlemesin |
| 4 | `19ac8c5` | Yayın derlemesini tek satıra al |
| 5 | `3ad62a1` | Oyunun asıl oynandığı iki jesti geri getir |
| 6 | `6c4507c` | Rakipler oynarken ıstaka canlı kalsın |
| 7 | `f9d7f54` | Iskarta yığınlarını gerçek masa gibi otur, bilgi şeridini kaldır |
| 8 | `8c8c73d` | Her yığını ait olduğu köşeye koy |
| 9 | `ded433a` | Masaya header: geri, ayarlar, kese |
| 10 | `1173424` | Header'ı koltukların üstüne al; Seri ve Per'i ıstakanın yanına |
| 11 | `9da4f82` | Taş bırakılana kadar ıstaka kıpırdamasın |
| 12 | `10546c8` | Bırakılan bir taş on yedi taşı oynatmasın |
| 13 | `c13ff92` | Tahtaya beşinci sıra; çift şeridinden kutuyu kaldır |

---

## 16. Bir sonraki oturuma öneriler

Öncelik sırasıyla, hiçbiri istenmedi — sadece not:

1. **Altın/elmasa anlam ver** ya da kaldır. Şu hâliyle boş bir vaat.
2. **`tool/publish.sh` yerine GitHub Actions.** Tek seferlik `gh auth refresh`.
3. **Çift şeridi 11 çifte sığsın** — hücre boyunu yükseklikten de türet, tahtada
   yaptığım gibi.
4. **Portre düzeni** ya gerçekten desteklensin ya da açıkça engellensin.
5. **Bot zorluk ayarları** artık çift yolunu içeriyor; Easy'nin çift kolu
   `mistakeRate`'e bağlı, orası bir kez daha ölçülebilir.
