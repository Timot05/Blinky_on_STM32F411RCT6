#include "stm32f4xx.h"

void initGPIO()
{
    GPIO_InitTypeDef GPIO_InitStructure;

    RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOC , ENABLE);

    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
    GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
    GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
    GPIO_Init(GPIOC, &GPIO_InitStructure);

    GPIO_WriteBit(GPIOC, GPIO_Pin_0, Bit_SET);
}

int main(void)
{
    uint32_t i;

    initGPIO();

    while (1)
    {
        for (i = 0; i < 5000000; i++) ;
        GPIO_WriteBit(GPIOC, GPIO_Pin_0, Bit_SET);

        for (i = 0; i < 5000000; i++) ;
        GPIO_WriteBit(GPIOC, GPIO_Pin_0, Bit_RESET);
    }
}
