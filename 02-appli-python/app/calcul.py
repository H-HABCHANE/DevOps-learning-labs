def prix_ttc(prix_ht: float, tva: float = 0.10) -> float:
    """Prix TTC arrondi au centime (TVA restauration : 10 %)."""
    if prix_ht < 0:
        raise ValueError("le prix ne peut pas être négatif")
    return round(prix_ht * (1 + tva), 2)
