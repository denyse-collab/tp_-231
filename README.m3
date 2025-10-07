 Gestion_fichier.c
#include "gestion_fichier.h"

// Gestion fichiers
FILE* ouvrir_fichier(const char *nom, const char *mode) {
    FILE *fichier = fopen(nom, mode);
    if (!fichier) {
        char msg[TAILLE_LIGNE];
        snprintf(msg, TAILLE_LIGNE, "Impossible d'ouvrir: %s", nom);
        erreur(msg);
    }
    return fichier;
}

void fermer_fichier(FILE *fichier) {
    if (fichier) fclose(fichier);
}

void erreur(const char *message) {
    fprintf(stderr, "Erreur: %s\n", message);
    exit(1);
}

// Lecture PPM
ImagePPM* lire_ppm(const char *nom_fichier) {
    FILE *fichier = ouvrir_fichier(nom_fichier, "rb");
    ImagePPM *image = malloc(sizeof(ImagePPM));
    
    // Lire en-tête
    char ligne[TAILLE_LIGNE];
    fgets(ligne, TAILLE_LIGNE, fichier);
    sscanf(ligne, "%2s", image->type);
    
    // Lire dimensions
    do {
        fgets(ligne, TAILLE_LIGNE, fichier);
    } while (ligne[0] == '#');
    sscanf(ligne, "%d %d", &image->largeur, &image->hauteur);
    
    // Lire valeur max
    fgets(ligne, TAILLE_LIGNE, fichier);
    sscanf(ligne, "%d", &image->max_val);
    
    // Allouer pixels
    int taille = image->largeur * image->hauteur * 3;
    image->pixels = malloc(taille);
    
    // Lire données
    if (strcmp(image->type, "P6") == 0) {
        fread(image->pixels, 1, taille, fichier);
    } else {
        // Format P3 (ASCII)
        for (int i = 0; i < taille; i++) {
            int val;
            fscanf(fichier, "%d", &val);
            image->pixels[i] = (unsigned char)val;
        }
    }
    
    fermer_fichier(fichier);
    return image;
}

// Écriture PPM
int ecrire_ppm(const char *nom_fichier, ImagePPM *image) {
    FILE *fichier = ouvrir_fichier(nom_fichier, "wb");
    
    // Écrire en-tête
    fprintf(fichier, "%s\n", image->type);
    fprintf(fichier, "%d %d\n", image->largeur, image->hauteur);
    fprintf(fichier, "%d\n", image->max_val);
    
    // Écrire données
    int taille = image->largeur * image->hauteur * 3;
    
    if (strcmp(image->type, "P6") == 0) {
        fwrite(image->pixels, 1, taille, fichier);
    } else {
        // Format P3 (ASCII)
        for (int i = 0; i < taille; i++) {
            fprintf(fichier, "%d ", image->pixels[i]);
            if ((i + 1) % 15 == 0) fprintf(fichier, "\n");
        }
    }
    
    fermer_fichier(fichier);
    return 0;
}
