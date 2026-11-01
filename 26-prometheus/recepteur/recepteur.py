"""Faux « téléphone d'astreinte » : affiche chaque notification envoyée par Alertmanager."""
import json
from datetime import datetime
from http.server import BaseHTTPRequestHandler, HTTPServer


class Recepteur(BaseHTTPRequestHandler):
    def do_POST(self):
        corps = json.loads(self.rfile.read(int(self.headers["Content-Length"])))
        heure = datetime.now().strftime("%H:%M:%S")
        print(f"\n📟 {heure} notification : {corps['status'].upper()} ({len(corps['alerts'])} alerte(s))", flush=True)
        for alerte in corps["alerts"]:
            nom = alerte["labels"]["alertname"]
            gravite = alerte["labels"].get("severity", "?")
            print(f"   - [{alerte['status']}] {nom} ({gravite}) : {alerte['annotations'].get('summary', '')}", flush=True)
        self.send_response(200)
        self.end_headers()

    def log_message(self, *args):  # pas de ligne de journal HTTP en plus
        pass


print("📟 Récepteur prêt sur le port 5001", flush=True)
HTTPServer(("0.0.0.0", 5001), Recepteur).serve_forever()
