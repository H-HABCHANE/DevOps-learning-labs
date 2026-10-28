import pytest

from app.calcul import prix_ttc, remise


def test_tva_par_defaut():
    assert prix_ttc(10) == 11.0


def test_tva_personnalisee():
    assert prix_ttc(10, 0.20) == 12.0


def test_prix_negatif_refuse():
    with pytest.raises(ValueError):
        prix_ttc(-5)
        
def test_remise_valide():
    assert remise(100, 15) == 85.0


def test_remise_pourcentage_invalide():
    with pytest.raises(ValueError):
        remise(100, 150)
