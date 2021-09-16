# RSA + DSA


## I etap "Generowanie kluczy i Podpisywanie":
**Alice**
1. Alice generuje klucz tajny *k<sub>A</sub>* i klucz publiczny *K<sub>A<sub>* do algorytmu RSA
2. Alice generuje klucz tajny *k'<sub>A</sub>* i klucz publiczny *K'<sub>A<sub>* do algorytmu DSA
3. Alice podpisuje *K<sub>A<sub>* kluczem *k'<sub>A</sub>* algorytmem DSA<br>
<center>*sig = DSA<sub>k'<sub>A</sub></sub>(K<sub>A</sub>)*</center>
4. Alice wysyła [*K'<sub>A</sub>, K<sub>A</sub>, s*] do Boba

## II etap "Weryfikacja i Szyfrowanie":
**Bob**
1. Weryfikuje [*K<sub>A</sub>, s*] kluczem *K'<sub>A</sub>*
2. Ustala *M*
3. Oblicza *RSA<sub>K<sub>A</sub></sub>(M) = C*
4. Wysyła *C* do Alice

## III etap "Deszyfrowanie":
**Alice**
1. Oblicza *RSA<sub>k<sub>A</sub></sub>(C) = M*
