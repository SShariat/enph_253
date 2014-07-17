/*
int  const_values [NUM_CONST] = {1,2,3,0,12};
char const_names  [NUM_CONST][STR_SIZE] =  {"foo", "bar", "bletch", "foofoo", "lol"};
*/


void init_variables(int values[], char names[][STR_SIZE], int array_size){
	
	LCD.clear(); LCD.home();
	LCD.setCursor(0,0); LCD.print("Init-Constants");
	LCD.setCursor(0,1); LCD.print("Press Start");
	while (!(startbutton()));

//	initialization template, for now you have to make sure the names match up so that it is not confusing when you code	
//	int ___ = value[]; 
	int foo 	= values[0];
	int bar 	= values[1];
	int bletch 	= values[2];
	int foofoo 	= values[3];
	int lol 	= values[4];
}
