# LoRa-Pico-BME280

Kısa açıklama  
Raspberry Pi Pico 2 W ve Ai-Thinker RA-01 (SX1278) kullanılarak, BME280 sensöründen alınan sıcaklık/nispi nem/basınç verilerinin LoRa P2P ile diğer bir Pico node'a gönderilip terminalde gösterilmesi amaçlanmıştır. Dengeli, sade ve doğrudan kullanılabilir bir proje yapısı sunar.

---

## İçindekiler
- [Açıklama](#açıklama)  
- [Özellikler](#özellikler)  
- [Donanım](#donanım)  
- [Yazılım Mimarisi](#yazılım-mimarisi)  
- [Haberleşme Parametreleri](#haberleşme-parametreleri)  
- [Bağlantı (kısa)](#bağlantı-kısa)  
- [Çalıştırma / Seri Monitör](#çalıştırma--seri-monitör)  
- [Testler](#testler)  
- [Katkıda Bulunma](#katkıda-bulunma)  
- [İletişim](#iletişim)

---

## Açıklama
Bu proje iki Pico tabanlı node (verici ve alıcı) arasında LoRa P2P haberleşmesi ile sensör verisi aktarımı gerçekleştirir. Verici tarafında BME280 sensöründen okunup paketlenen veriler LoRa ile gönderilir; alıcı tarafı bu paketleri alıp seri (terminal) üzerinde gösterir.

## Özellikler
- Basit P2P LoRa iletişimi (verici ↔ alıcı)  
- BME280 ile sıcaklık, nem ve basınç okuma  
- Taşınabilir C++ tabanlı uygulama (Pico SDK ile C/C++)  
- Dengeli, gereksiz ayrıntıya girmeyen kullanım/kurulum yönergeleri

## Donanım
- Raspberry Pi Pico 2 W (her iki node için)  
- BME280 sensörü (I2C) — verici tarafta  
- AI Thinker RA-01 (SX1278) LoRa modülü — her node için ayrı modül  
- Anten (uygun 433 MHz anten)  
- Güç kaynağı (USB güç veya batarya)

## Yazılım Mimarisi
- Sensör okuma (BME280, I2C)  
- Veri paketleme (koşullu, küçük paket yapısı)  
- LoRa gönderim (SX1278 üzerinden SPI)  
- RX tarafında alma ve seri terminale yazma

C++ standardı: C++17 (proje C++ ile yazılmıştır; Pico SDK ile uyumlu şekilde C/C++ karışımı olabilir).

## Haberleşme Parametreleri
- Frekans: 433 MHz  
- Spreading Factor: SF7  
- Bandwidth: 125 kHz  
- Coding Rate: 4/5  
- TX Gücü: 17 dBm

Bu parametreler LoRa link'i ve menzili doğrudan etkiler — gerekirse ayarlanabilir.

## Bağlantı (kısa)
- BME280: I2C (SDA, SCL) — verici Pico'ya bağlanır. VCC=3.3V, GND ortak.  
- RA-01 (SX1278): SPI (MOSI, MISO, SCK) + CS + DIOx + RESET (modül pinlerini proje dokümanınıza göre eşleyin). VCC=3.3V.  
- Anten takılı ve uygun şekilde topraklanmış olmalı.  
Not: Tam pin eşlemeleri proje kodundaki pin tanımlarına göre yapılmalıdır; burada genel yönlendirme verilmektedir.

## Çalıştırma / Seri Monitör
- Seri hız: 115200 baud (varsayılan; proje içinde değiştirilebilir).  
- Terminal ile izleme örneği:
```bash
# Linux / macOS
picocom /dev/ttyUSB0 -b 115200
# veya
minicom -D /dev/ttyUSB0 -b 115200
```
Verici: sensör verilerini periyodik olarak paket gönderir.  
Alıcı: gelen paketları çözümler ve terminale yazdırır.

## Testler
- Projede otomatik test altyapısı yoksa, ilk testler manuel olacaktır: verici ve alıcıyı aynı ortamda çalıştırıp, sensör okuma ve paket alımını doğrulayın.  
- İyi bir sonraki adım: basit bir loopback testleri ve menzil testleri yapmaktır (farklı mesafeler/engeller altında paket kaybını kontrol edin).

## Katkıda Bulunma
1. Fork → branch oluştur (ör. feature/iyileme-adi)  
2. Değişiklik yap → test et → PR aç  
3. Küçük, odaklı PR'lar tercih edilir; büyük değişiklikler için önce issue açın.

## İletişim
- Sahip / Repo: https://github.com/Emin-gunel (güncellemek isterseniz gerçek repo linkinizi ekleyin)

---