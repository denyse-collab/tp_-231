#ifndef GESTION_FICHIER_H
#define GESTION_FICHIER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAILLE_LIGNE 256

typedef struct {
    char type[3];
    int largeur;
    int hauteur;
    int max_val;
    unsigned char *pixels;
} ImagePPM;

// Fonctions fichiers
FILE* ouvrir_fichier(const char *nom, const char *mode);
void fermer_fichier(FILE *fichier);

// Fonctions PPM
ImagePPM* lire_ppm(const char *nom_fichier);
int ecrire_ppm(const char *nom_fichier, ImagePPM *image);
void liberer_ppm(ImagePPM *image);
