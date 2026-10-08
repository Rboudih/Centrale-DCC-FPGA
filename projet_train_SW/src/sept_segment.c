#include "sept_segment.h"


// tableau des chiffres 0-9
static int chiffres[] = {
    SEG_0, SEG_1, SEG_2, SEG_3, SEG_4,
    SEG_5, SEG_6, SEG_7, SEG_8, SEG_9
};

// Anodes actives a  0
static int anodes[] = {AN0, AN1, AN2, AN3};

// Fonction de base, pour afficher les 4 digits
static void seg_afficher(XGpio *gpio_seg, int d3, int d2, int d1, int d0) {
    int digits[4] = {d0, d1, d2, d3};
    for (int i = 0; i < 4; i++) {
        int val = (anodes[i] << 8) | digits[i]; // [d3,d2,d1,d0] = bits [11,10,9,8]
        XGpio_DiscreteWrite(gpio_seg, 1, val);
        usleep(1000);
    }
}

// Affiche "StoP"
void seg_afficher_stop(XGpio *gpio_seg) {
    seg_afficher(gpio_seg, SEG_S, SEG_T, SEG_o, SEG_P);
}


// Affiche Ad adresse du train
void seg_afficher_adr(XGpio *gpio_seg, int adresse) {
    int dizaine = adresse / 10;
    int unite   = adresse % 10;
    seg_afficher(gpio_seg, SEG_A, SEG_d, chiffres[dizaine], chiffres[unite]);
}


// Affiche step et la direction
// direction = 1  avant :  "SXXA"
// direction = 0  arriere : "SXXd"
// Stop pour une commande de stop
void seg_afficher_step(XGpio *gpio_seg, int step,int direction) {
	int dizaine = step / 10;
	int unite   = step % 10;

	if (step == 0) {seg_afficher_stop(gpio_seg);}
	else {
		if (direction == 1) {
			seg_afficher(gpio_seg, SEG_S, chiffres[dizaine], chiffres[unite],SEG_A);
		} else {
			seg_afficher(gpio_seg, SEG_S, chiffres[dizaine], chiffres[unite],SEG_r);
		}
	}
}



// fonction affiche le num de la fonction : F-XX
void seg_afficher_fct(XGpio *gpio, int num_fct) {
    int dizaine = num_fct / 10;
    int unite   = num_fct % 10;
    seg_afficher(gpio, SEG_F, SEG_G, chiffres[dizaine], chiffres[unite]);
}

void seg_afficher_mot_fct(XGpio *gpio) {
    seg_afficher(gpio, SEG_F, SEG_T, SEG_G, SEG_G);
}
void seg_afficher_mot_step(XGpio *gpio) {
    seg_afficher(gpio, SEG_S, SEG_T, SEG_E, SEG_P);
}
