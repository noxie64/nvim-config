#!/bin/bash

# Define connections
export DBEE_CONNECTIONS='[
    {
        "name": "{{ exec `echo Hidden Database` }}",
        "url": "postgres://{{ env \"DB_USER\" }}:{{ env `DB_PASS` }}@db3.htl-kaindorf.at:1521/SCHUELER_PDB",
        "type": "postgres"
    }
]'

read -p "Enter Oracle Username: " DB_USER
read -s -p "Enter Oracle Password: " DB_PASS
echo ""

nvim
