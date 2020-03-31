/************************************************************************
Lab 9 Nios Software
Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013
For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000080;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;


void RotateWord(unsigned char * key, int index, unsigned char * result){
	result[0] = key[index + 1];
	result[1] = key[index + 2];
	result[2] = key[index + 3];
	result[3] = key[index];
}

void SubBytesButOnly4(unsigned char * msg){
	int i;
	unsigned char upper, lower;
	for(i = 0; i < 4; i++){
		char upper = msg[i] >> 4;
		char lower = msg[i] & 0x0F;
		msg[i] = aes_sbox[upper * 16 + lower];
	}
}

void KeyExpansion(unsigned char * keySchedule){
	int i, j, k, l;
	int columnIndex;
	int rconCounter = 1;
	for(i = 0; i < 11; i++){
		for(j = 0; j < 4; j++){
			unsigned char temp[4];
			columnIndex = 4*i + 3+j;
			if(j == 0){
				// if j % 4 is 0 then rotate and subbyte
				RotateWord(keySchedule, columnIndex*4, temp);
				SubBytesButOnly4(temp);
			}
			else{
				for(l = 0; l < 4; l++){
					temp[l] = keySchedule[4*columnIndex + l];
				}
			}
			for(k = 0; k < 4; k++){
				// Rcon XOR has 24 LSB as 0, equivalent to adding 0 -> do nothing
				if(k == 0 && j == 0){
					keySchedule[4*columnIndex + k+4] = temp[k] ^ keySchedule[4*columnIndex + k-12] ^ (Rcon[rconCounter] >> 24);
					rconCounter++;
				}
				else{
					keySchedule[4*columnIndex + k+4] = temp[k] ^ keySchedule[4*columnIndex + k-12];
				}
			}
		}
	}

}



void SubBytes(unsigned char * msg){
	int i;
	unsigned char upper, lower;
	for(i = 0; i < 16; i++){
		char upper = msg[i] >> 4;
		char lower = msg[i] & 0x0F;
		msg[i] = aes_sbox[upper * 16 + lower];
	}
}

void AddRoundKey(unsigned char * msg, unsigned char * curr_key){
	int i;
	for(i = 0; i < 16; i++){
		msg[i] ^= curr_key[i];
	}
}

void ShiftRows(unsigned char * msg){
	char temp0 = msg[1];
	char temp1 = msg[5];
	char temp2 = msg[9];
	char temp3 = msg[13];
	msg[1] = temp1;
	msg[5] = temp2;
	msg[9] = temp3;
	msg[13] = temp0;

	temp0 = msg[2];
	temp1 = msg[6];
	temp2 = msg[10];
	temp3 = msg[14];
	msg[2] = temp2;
	msg[6] = temp3;
	msg[10] = temp0;
	msg[14] = temp1;

	temp0 = msg[3];
	temp1 = msg[7];
	temp2 = msg[11];
	temp3 = msg[15];
	msg[3] = temp3;
	msg[7] = temp0;
	msg[11] = temp1;
	msg[15] = temp2;
}

unsigned char m2(unsigned char in){
	if(in & 0x80){
		in <<= 1;
		return in ^ 0x1b;
	}
	else{
		return in << 1;
	}
}

unsigned char m3(unsigned char in){
	return m2(in) ^ in;
}

void MixColumns(unsigned char * msg){
	int i;
	unsigned char t[16];
	memcpy(t, msg, 16);


	for(i = 0; i < 4; i++){
		msg[4*i] = m2(t[4*i]) ^ m3(t[4*i + 1]) ^ t[4*i + 2] ^ t[4*i + 3];
		msg[4*i + 1] = t[4*i] ^ m2(t[4*i + 1]) ^ m3(t[4*i + 2]) ^ t[4*i + 3];
		msg[4*i + 2] = t[4*i] ^ t[4*i + 1] ^ m2(t[4*i + 2]) ^ m3(t[4*i + 3]);
		msg[4*i + 3] = m3(t[4*i]) ^ t[4*i + 1] ^ t[4*i + 2] ^ m2(t[4*i + 3]);
	}
}



/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function
	int i, j;
	unsigned char keySched[176];
	unsigned char message_in[16];
	unsigned char tempKey[16];
	// clean up the keySched array
	 memset(keySched, 0, 176);

	 for(i = 0; i < 16; i++){
	 	message_in[i] = charsToHex(msg_ascii[2*i], msg_ascii[2*i+1]);
	 	keySched[i] = charsToHex(key_ascii[2*i], key_ascii[2*i+1]);
	 }
//	message_in[0] = 0x32;
//	message_in[1] = 0x43;
//	message_in[2] = 0xf6;
//	message_in[3] = 0xa8;
//	message_in[4] = 0x88;
//	message_in[5] = 0x5a;
//	message_in[6] = 0x30;
//	message_in[7] = 0x8d;
//	message_in[8] = 0x31;
//	message_in[9] = 0x31;
//	message_in[10] = 0x98;
//	message_in[11] = 0xa2;
//	message_in[12] = 0xe0;
//	message_in[13] = 0x37;
//	message_in[14] = 0x07;
//	message_in[15] = 0x34;
//
//	keySched[0] = 0x2b;
//	keySched[1] = 0x7e;
//	keySched[2] = 0x15;
//	keySched[3] = 0x16;
//	keySched[4] = 0x28;
//	keySched[5] = 0xae;
//	keySched[6] = 0xd2;
//	keySched[7] = 0xa6;
//	keySched[8] = 0xab;
//	keySched[9] = 0xf7;
//	keySched[10] = 0x15;
//	keySched[11] = 0x88;
//	keySched[12] = 0x09;
//	keySched[13] = 0xcf;
//	keySched[14] = 0x4f;
//	keySched[15] = 0x3c;
//	for(int i = 16; i < 176; i++){
//		keySched[i] = 0;
//	}
	KeyExpansion(keySched);


	memcpy((char *)tempKey, (char *)&keySched, 16);
	AddRoundKey(message_in, tempKey);
	// fix indexing!
	for(i = 1; i < 10; i++){
		SubBytes(message_in);
		ShiftRows(message_in);
		MixColumns(message_in);
		memcpy((char *)tempKey, (char *)&keySched[i*16], 16);
		AddRoundKey(message_in, tempKey);
	}

	SubBytes(message_in);
	ShiftRows(message_in);
	memcpy((char *)tempKey, (char *)&keySched[160], 16);
	AddRoundKey(message_in, tempKey);

	// memcpy(msg_enc, message_in, 16);
	// memcpy(key, key_ascii, 16);
	int h;
	for(h = 0; h < 16; h++){
		printf("%02x", message_in[h]);
	}
	for(h = 0; h < 4; h++){
		msg_enc[h] = (message_in[4*h] << 24) | (message_in[4*h+1] << 16) | (message_in[4*h+2] << 8) | message_in[4*h+3];
		key[h] = (keySched[4*h] << 24) | (keySched[4*h+1] << 16) | (keySched[4*h+2] << 8) | keySched[4*h+3];
	}
}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	 unsigned char msg_ascii[33];
	 unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	// AES_PTR[10] = 0xDEADBEEF;
	// if(AES_PTR[10] != 0xDEADBEEF){
	// 	printf("%x\n", AES_PTR[10]);
	// }
//	unsigned char msg_ascii[33] = {'3', '2', '4', '3', 'f', '6', 'a', '8', '8', '8', '5', 'a', '3', '0', '8', 'd', '3', '1', '3', '1', '9', '8', 'a', '2', 'e', '0', '3', '7', '0', '7', '3', '4', '\0'};
//	unsigned char key_ascii[33] = {'2', 'b', '7', 'e', '1', '5', '1', '6', '2', '8', 'a', 'e', 'd', '2', 'a', '6', 'a', 'b', 'f', '7', '1', '5', '8', '8', '0', '9', 'c', 'f', '4', 'f', '3', 'c', '\0'};
//	encrypt(msg_ascii, key_ascii, msg_enc, key);

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);

			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
