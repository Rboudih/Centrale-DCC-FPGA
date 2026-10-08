#include "xgpio.h"
#include "xparameters.h"
#include "centrale_dcc_ip.h"
#include "my_acc.h"
#include "dcc.h"
#include "sept_segment.h"
#include "xil_io.h"

#define SEUIL  300  // seuil de l'accel

int main(void) {
	XGpio sept_segment_led;
	XGpio sw_bouton;
	int sw;
	int bouton;


	// Initialisation des gpio :
	XGpio_Initialize(&sept_segment_led,XPAR_SEPT_SEGMENT_LED_DEVICE_ID);
	XGpio_Initialize(&sw_bouton,XPAR_SW_BOUTTON_DEVICE_ID);

	// GPIO : sept_segment_led
	// ----> Port 1 : sept_segment en sortie
	XGpio_SetDataDirection (&sept_segment_led,1,0x000);
	// ----> Port 2 : led en sortie
	XGpio_SetDataDirection (&sept_segment_led,2,0x0000);
	// GPIO : sw_bouton
	// ----> Port 1 : sw en entrée
	XGpio_SetDataDirection (&sw_bouton,1,0x7FF);
	// ----> Port 2 : bouton en entrée
	XGpio_SetDataDirection (&sw_bouton,2,0x1F);

    // Variables de système
    int etat        = 0;
    int adresse     = 0;
    int mode        = 0;
    int vitesse     = 0;
    int direction   = 0;
    int on_off      = 0;
    int num_fct     = 0;
    int x = 0;
    int y = 0;


    // mémorisation des états précédent des boutons
    int btnC_prev = 0;
    int btnU_prev = 0;
    int btnR_prev = 0;
    int btnD_prev = 0;

    // Par défaut : vitesse = stop, pas de fonction active
    u64 trame = trame_vitesse(0, 0, 0);


	while(1) {
		sw = XGpio_DiscreteRead(&sw_bouton, 1);
		bouton = XGpio_DiscreteRead(&sw_bouton, 2);

		// Detection d'appui sur les btn
		int btnC = btn_appuye((bouton >> 0) & 0x1, &btnC_prev);
		int btnU = btn_appuye((bouton >> 1) & 0x1, &btnU_prev);
		int btnR = btn_appuye((bouton >> 3) & 0x1, &btnR_prev);
		int btnD = btn_appuye((bouton >> 4) & 0x1, &btnD_prev);

		// dernière trame en permanant pour alimenter les trains
		envoyer_trame(trame);

		switch(etat) {
			// ETAPE 1 : choisir l'adresse
			case 0:
				adresse = sw & 0x7;
				seg_afficher_adr(&sept_segment_led, adresse);
				// Attendre le premier appui btnR pour choisir le mode
				if (btnR) etat = 1;
				break;

			// ETAPE 1 : choisir le mode
			case 1:
				mode = (sw >> 0) & 0x3;
				seg_afficher_adr(&sept_segment_led, adresse);
				// si SW0 = 1 donc on passe en mode vitesse
				if ((mode >> 0) & 0x1) {
					seg_afficher_mot_step(&sept_segment_led);
				}
				// si SW1 = 1 donc on passe en mode fonction
				if ((mode >> 1) & 0x1) {
					seg_afficher_mot_fct(&sept_segment_led);
				}
				// l'appui du le btnR permet de passer a l etape suivante pour choisir les
				// parametres de la trame
				if (btnR){
					if ((mode >> 0) & 0x1 ) { etat = 2;}
					else if ((mode >> 1) & 0x1 ) { etat = 3;}
				}

				break;

			// Etape 2 : choisir la vitesse et l adresse
			case 2:
				direction = (sw >> 0) & 0x1;
				if (btnU) vitesse++;
				else if (btnD) vitesse--;
				seg_afficher_step(&sept_segment_led,vitesse,direction);
				// valider la commande avec btnC
				if (btnC){
					trame = trame_vitesse(adresse,vitesse,direction);
					envoyer_trame(trame);
					etat = 2;
				}
				if (btnR) etat = 0;
				break;
			// Etape 3 : choisir la fonction a activer ou desactiver
			case 3:
				on_off = (sw >> 0) & 0x1;
				if (btnU) num_fct++;
				else if (btnD) num_fct--;
				seg_afficher_fct(&sept_segment_led, num_fct);
				// valider la commande avec btnC
				if (btnC){
					trame = trame_fonction(adresse, num_fct, on_off);
					envoyer_trame(trame);
					etat=3;
					break;
				}
				if (btnR) etat = 0;
				break;

		}
		// --- Gestion accelerometre ---
		// Lire axe X et Y et determiner le signe
		// L'ACCEL retourne une valeur sur 12 bits (0x000 à 0xFFF)
		// la variable int est sur 32 bits donc les bits 31..12 sont à 0
		// Si le bit 11 (MSB) est à 1 donc la valeur est négative
		// On met les bits 31..12 à 1 pour obtenir le bon entier signé
		x = MY_ACC_mReadReg(XPAR_MY_ACC_0_S00_AXI_BASEADDR,MY_ACC_S00_AXI_SLV_REG0_OFFSET);
		if(x & 0x800) x |= 0xFFFFF000;
		y = MY_ACC_mReadReg(XPAR_MY_ACC_0_S00_AXI_BASEADDR,MY_ACC_S00_AXI_SLV_REG1_OFFSET);
		if(y & 0x800) y |= 0xFFFFF000;

		// Axe X : vitesse (+1 ou -1)
		if(x > SEUIL) {
			if(vitesse < 28) vitesse+=2;
			trame = trame_vitesse(adresse, vitesse, direction);
			envoyer_trame(trame);
			usleep(30000);
		}
		else if(x < -SEUIL) {
			if(vitesse > 0) vitesse-=2;
			trame = trame_vitesse(adresse, vitesse, direction);
			envoyer_trame(trame);
			usleep(30000);
		}
		// Axe Y : permet de changer la direction du train
		if(y > SEUIL) {
			direction = 1;  // avant
			trame = trame_vitesse(adresse, vitesse, direction);
			envoyer_trame(trame);
			usleep(30000);
		}
		else if(y < -SEUIL) {
			direction = 0;  // arrière
			trame = trame_vitesse(adresse, vitesse, direction);
			envoyer_trame(trame);
			usleep(30000);
		}

		usleep(1000);
	}
	return 0;

}
