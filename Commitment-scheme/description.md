# Protokół zobowiązania bitowego
> (działa w sieci między dwoma urządzeniami, wykorzystuje bibliotekę `openssl`)

## I etap "Klient podejmuje decyzję":
**Alice**
1. Wybiera losowo bit *b*
2. Wybiera losowo ciągi *A* i *B*
3. Oblicza zobowiązanie bitowe *H(ABb) = Y*
4. Wysyła ciągi *A* i *Y* do Boba

## II etap "Klient odkrywa decyzję":
**Alice**
1. Wysyła ciągi *A*, *B* i *b* do Boba

## III etap "Serwer sprawdza zobowiązanie klienta":
**Bob**
1. Porównuje otrzymane ciągi *A*
2. Oblicza *H(ABb)* i porównuje z *Y*
3. Jeśli powyższe ciągi są równe, to uznaje bit *b* Alice
