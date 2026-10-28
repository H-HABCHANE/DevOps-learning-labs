def prix_ttc(prix_ht: float, tva: float = 0.10) -> float:
    """Prix TTC arrondi au centime (TVA restauration : 10 %)."""
    if prix_ht < 0:
        raise ValueError("le prix ne peut pas être négatif")
    return round(prix_ht * (1 + tva), 2)


def remise(prix: float, pourcentage: float) -> float:
    """Calcule le prix après application d'une remise en pourcentage."""
    if prix < 0:
        raise ValueError("Le prix ne peut pas être négatif")
    if not (0 <= pourcentage <= 100):
        raise ValueError("Le pourcentage doit être compris entre 0 et 100")
    return round(prix * (1 - pourcentage / 100), 2)
