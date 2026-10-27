import sys

from app.calcul import prix_ttc

prix_ht = float(sys.argv[1]) if len(sys.argv) > 1 else 10.0
print(f"{prix_ht} € HT = {prix_ttc(prix_ht)} € TTC")
