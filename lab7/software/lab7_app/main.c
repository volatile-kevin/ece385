

int main()
{
	volatile unsigned int sum = 0;
//	printf("hi");

	volatile unsigned int *LED_PIO = (unsigned int*)0x30; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x60; //make a pointer to access the PIO block
	volatile unsigned int *BUTT_PIO = (unsigned int*)0x80; //make a pointer to access the PIO block

	*LED_PIO = 0b0;

	while (1) //infinite loop
	{
		if(!(*BUTT_PIO & 0b0100)){
			*LED_PIO = 0;
			sum = 0;
			while(!(*BUTT_PIO & 0b0100)){}
		}

		if(!(*BUTT_PIO & 0b1000)){
			sum += *SW_PIO;
			while(!(*BUTT_PIO & 0b1000)){}
		}
		*LED_PIO = sum%256;

//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO |= 0x1; //set LSB
//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO &= ~0x1; //clear LSB

	}
	return 1; //never gets here
}
