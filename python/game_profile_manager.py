#!/usr/bin/env python3
"""HyperBoost Game Profile Manager"""
import json
import os

PROFILES_FILE = os.path.join(os.path.dirname(__file__), '..', 'data', 'game_tweak_profiles.json')

def load_profiles():
    with open(PROFILES_FILE, 'r') as f:
        return json.load(f)

def list_games():
    profiles = load_profiles()
    for i, profile in enumerate(profiles['profiles']):
        print(f"{i+1}. {profile['game']} ({profile['package']})")

if __name__ == "__main__":
    list_games()