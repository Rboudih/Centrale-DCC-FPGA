#include "dcc.h"

// tableau qui contient le code de vitesse stop + les 28 step
static const int step_codes[29] = {
    0b00000, 0b00010, 0b10010, 0b00011, 0b10011,
    0b00100, 0b10100, 0b00101, 0b10101, 0b00110,
    0b10110, 0b00111, 0b10111, 0b01000, 0b11000,
    0b01001, 0b11001, 0b01010, 0b11010, 0b01011,
    0b11011, 0b01100, 0b11100, 0b01101, 0b11101,
    0b01110, 0b11110, 0b01111, 0b11111
};

// Fonction return le code de step
int step_to_code(int step) {
    if(step < 0)  return step_codes[0];  // Stop
    if(step > 28) return step_codes[29];  // Step 28 max
    return step_codes[step];
}

// Construction du trame d'1 octet
u64 trame_1octet(int adresse, int commande, int controle){
	// Construction de trame 50 bits
	u64 trame = 0x7FFFFF;       					 // pr�ambule de 23 bits � 1
	trame = (trame << 1);                            // start bit 0
	trame = (trame << 8) | (adresse & 0xFF);         // adresse 8 bits
    trame = (trame << 1);                            // start bit 0
    trame = (trame << 8) | (commande & 0xFF);        // commande 8 bits
    trame = (trame << 1);                            // start bit 0
    trame = (trame << 8) | (controle & 0xFF);        // controle 8 bits
    trame = (trame << 1) | 0x1;					 // stop bit 1
    return trame ;
}


// Construction du trame d'2 octet
u64 trame_2octet(int adresse, int commande1, int commande2, int controle){
	// Construction de trame 50 bits
	u64 trame = 0x3FFF;       					     // pr�ambule de 14 bits � 1
	trame = (trame << 1);                            // start bit 0
	trame = (trame << 8) | (adresse & 0xFF);         // adresse 8 bits
    trame = (trame << 1);                            // start bit 0
    trame = (trame << 8) | (commande1 & 0xFF);        // commande 1 sur 8 bits
    trame = (trame << 1);                            // start bit 0
    trame = (trame << 8) | (commande2 & 0xFF);        // commande 2 sur 8 bits
    trame = (trame << 1);                            // start bit 0
    trame = (trame << 8) | (controle & 0xFF);        // controle 8 bits
    trame = (trame << 1) | 0x1;					 // stop bit 1
    return trame ;
}


// Construction du trame de vitesse
u64 trame_vitesse(int adresse, int num_step, int direction) {
	// Octet de commande : 01DXXXXX
	int vitesse = step_to_code(num_step);
	int commande = 0x40 | ((direction & 0x1) << 5) | (vitesse & 0x1F);

	// Octet de controle : XOR
	int controle = (adresse & 0xFF) ^ (commande & 0xFF);

    return trame_1octet(adresse, commande, controle);
}


// Construction du trame pour les fonction F0-F4
u64 trame_f0_f4(int adresse, int num_fct, int on_off) {
    int commande = 0x80;
    if(num_fct == 0)
        commande |= (on_off & 0x1) << 4;
    else
        commande |= (on_off & 0x1) << (num_fct - 1);
    int controle = (adresse & 0xFF) ^ (commande & 0xFF);
    return trame_1octet(adresse, commande, controle);
}


// Construction du trame pour les fonction F5-F12
u64 trame_f5_f12(int adresse, int num_fct, int on_off) {
    int commande = 0xA0;
    if(num_fct >= 5 && num_fct <= 8) {
        commande |= 0x10;
        commande |= (on_off & 0x1) << (num_fct - 5);
    } else {
        commande |= (on_off & 0x1) << (num_fct - 9);
    }
    int controle = (adresse & 0xFF) ^ (commande & 0xFF);
    return trame_1octet(adresse, commande, controle);
}

// Construction du trame pour les fonction F13-F20
u64 trame_f13_f20(int adresse, int num_fct, int on_off) {
    int commande1 = 0xDE;
    int commande2 = (on_off & 0x1) << (num_fct - 13);
    int controle  = (adresse & 0xFF) ^ (commande1 & 0xFF) ^ (commande2 & 0xFF);
    return trame_2octet(adresse, commande1, commande2, controle);
}


// fonction pour envoyer la trame vers les registres slv
void envoyer_trame(u64 trame){
	u32 reg0 = (trame >> 19) & 0xFFFFFFFF;			// slv_reg0 = trame [50:19]
	u32 reg1 = trame & 0x7FFFF;						// slv_reg1 = trame [18:0]
	// �criture dans les registre de l'ip centrale_dcc
	CENTRALE_DCC_IP_mWriteReg( XPAR_CENTRALE_DCC_IP_0_S00_AXI_BASEADDR, CENTRALE_DCC_IP_S00_AXI_SLV_REG0_OFFSET, reg0);
	CENTRALE_DCC_IP_mWriteReg( XPAR_CENTRALE_DCC_IP_0_S00_AXI_BASEADDR, CENTRALE_DCC_IP_S00_AXI_SLV_REG1_OFFSET, reg1);
}

u64 trame_fonction(int adresse, int num_fct, int on_off) {
    if(num_fct >= 0 && num_fct <= 4)
        return trame_f0_f4(adresse, num_fct, on_off);
    else if(num_fct >= 5 && num_fct <= 12)
        return trame_f5_f12(adresse, num_fct, on_off);
    else
        return trame_f13_f20(adresse, num_fct, on_off);
}

// fonction pour detecter l'appui sur un BP
int btn_appuye(int etat_actuel, int *etat_precedent) {
    int appuye = (etat_actuel == 1) && (*etat_precedent == 0);
    *etat_precedent = etat_actuel;
    if (appuye) usleep(20000);   // anti-rebond de 20ms
    return appuye;
}
