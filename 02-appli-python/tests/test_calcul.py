import pytest

from app.calcul import prix_ttc


def test_tva_par_defaut():
    assert prix_ttc(10) == 11.5


def test_tva_personnalisee():
    assert prix_ttc(10, 0.20) == 12.0


def test_prix_negatif_refuse():
    with pytest.raises(ValueError):
        prix_ttc(-5)
