#ifndef DCC_H
#define DCC_H
#include "xparameters.h"
#include "centrale_dcc_ip.h"
#include "unistd.h"
#include "xil_io.h"
#include "xil_types.h" // definit u8, u16, u32 et u64

int step_to_code(int step);
u64 trame_1octet(int adresse, int commande, int controle);
u64 trame_2octet(int adresse, int commande1, int commande2, int controle);
u64 trame_vitesse(int adresse, int num_step, int direction);
u64 trame_f0_f4(int adresse, int num_fct, int on_off);
u64 trame_f5_f12(int adresse, int num_fct, int on_off);
u64 trame_f13_f20(int adresse, int num_fct, int on_off);
u64 trame_fonction(int adresse, int num_fct, int on_off);
void envoyer_trame(u64 trame);
int btn_appuye(int etat_actuel, int *etat_precedent);
#endif
