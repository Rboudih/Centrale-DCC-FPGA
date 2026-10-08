#ifndef SEPT_SEGMENT_H
#define SEPT_SEGMENT_H

#include <stdint.h>
#include "xgpio.h"
#include "xparameters.h"
#include "unistd.h"



// Code des chiffres 0-9 (cathodes actives a 0)
// segments : gfedcba
#define SEG_0  0x40
#define SEG_1  0x79
#define SEG_2  0x24
#define SEG_3  0x30
#define SEG_4  0x19
#define SEG_5  0x12
#define SEG_6  0x02
#define SEG_7  0x78
#define SEG_8  0x00
#define SEG_9  0x10

// Code des lettres
#define SEG_A  0x08
#define SEG_d  0x21
#define SEG_E  0x06
#define SEG_F  0x0E
#define SEG_G  0x3F // pour afficher le tiret -
#define SEG_r  0x2F
#define SEG_P  0x0C
#define SEG_o  0x23
#define SEG_S  0x12
#define SEG_T  0x07

// Anodes actives a 0
#define AN0  0xE   // digit 0 : 1110(droite)
#define AN1  0xD   // digit 1 : 1101
#define AN2  0xB   // digit 2 : 1011
#define AN3  0x7   // digit 3 : 0111 (gauche)


// fonctions d'affichage sur les sept segment
void seg_afficher_adr(XGpio *gpio_seg, int adresse);
void seg_afficher_step(XGpio *gpio_seg, int code_step,int direction);
void seg_afficher_stop(XGpio *gpio_seg);
void seg_afficher_start(XGpio *gpio_seg);
void seg_afficher_fct(XGpio *gpio, int num_fct) ;
void seg_afficher_mot_step(XGpio *gpio);
void seg_afficher_mot_fct(XGpio *gpio);

#endif
