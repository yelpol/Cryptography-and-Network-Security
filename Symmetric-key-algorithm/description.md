# Symetryczny protokół szyfrowania
> (działa w sieci między dwoma urządzeniami, wykorzystuje bibliotekę `openssl`)

## Definicji symboli
1. *E* - algorytm szyfrowania
2. *D* - algorytm deszyfrowania
3. *K* - klucz
4. *M* - wiadomość (tekst jawny)
5. *C* - szyfrogram

## I etap "Przygotowania":
**Alice i Bob**
1. Ustalają *(E, D)*, mają dwa szyfry do wyboru: *DES* i *AES_128_CBC*
2. Ustalają wspólny sekret *S* za pomocą protokołu Diffiego-Hellmana
3. Generują klucz tajny *K* z sekretu *S*

## II etap "Szyfrowanie":
**Alice**
1. Ustala *M* (plik z dysku)
2. Oblicza *C = E~k(M)*
3. Wysyła *C* do Boba

## III etap "Deszyfrowanie":
**Bob**
1. Oblicza *M = D~k(C)*
