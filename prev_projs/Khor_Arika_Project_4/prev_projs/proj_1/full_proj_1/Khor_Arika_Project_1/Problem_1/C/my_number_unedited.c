
/* my_number.c */

#include <stdio.h>
#include <stdlib.h>

int main ()
{ /* main */
   /*
    * DECLARATION SECTION
    */
   /*
    * Named Constant Declarations
    *
    * minimum_number:    the user's number should be at least this.
    * maximum_number:    the user's number should be at most this.
    * close_distance:    how close the user has to be to be told that
    *                    they're close.
    * computers_number:  the number that the computer is "thinking" of.
    * program_success_code: By convention, returning 0 from a program
    *                       to the operating system (in this case,
    *                       Linux) means that the program has finished
    *                       successfully.
    */
    const int minimum_number       =  1;
    const int maximum_number       = 10;
    const int close_distance       =  1;
    const int computers_number     =  5;
    const int maximum_guesses      = 10;
    const int program_success_code =  0;
   /*
    * Variable Declarations
    *
    * users_number:   the user's chosen number.
    * guesses_so_far: the number of guesses made so far.
    */
    int users_number;
    int guesses_so_far;

   /*
    * EXECUTION SECTION (BODY)
    */
   /*
    * Describe what the program does.
    */
    printf("Let's see whether you can guess ");
    printf("the number that I'm thinking of.\n");

   /*
    * Tell the user the range to choose from.
    */
    printf("It's between %d and %d.\n",
        minimum_number, maximum_number);

   /*
    * Keep asking for the user's number until they guess correctly.
    */

    guesses_so_far = 0;

    users_number = minimum_number - 1;

    while ((users_number != computers_number) &&
           (guesses_so_far < maximum_guesses)) {
       /*
        * Prompt the user to guess.
        */
        printf("What number am I thinking of?\n");
       /*
        * Input the user's number.
        */
        scanf("%d", &users_number);
       /*
        * Report the user's number.
        */
        printf("You guessed %d.\n", users_number);
       /*
        * Increment the number of guesses so far.
        */
        guesses_so_far++;
       /*
        * Judge the user's number.
        */
        if ((users_number < minimum_number) ||
            (users_number > maximum_number)) {
           /*
            * Idiotproof:  they're outside the range, so complain.
            */
            printf("Hey! That's not between %d and %d!\n",
                minimum_number, maximum_number);
        } /* if ((users_number < minimum_number) || ...) */
        else if (users_number == computers_number) {
           /*
            * They're correct, so be amazed.
            */
            printf("That's amazing!\n");
        } /* if (users_number == computers_number) */
        else if (abs(users_number - computers_number) <= close_distance) {
           /*
            * They're within close_distance, so say that they're close.
            */
            printf("Close, but no cigar.\n");
        } /* if (abs(users_number - computers_number) <= ...) */
        else {
           /*
            * They're not even close, so be cruel.
            */
            printf("Bzzzt! Not even close.\n");
        } /* if (abs(users_number - computers_number) <= ...)...else */
    } /* while ((users_number != computers_number) && ... */
   /*
    * By convention, returning 0 from a program to the operating
    * system (in this case, Linux) means that the program finished
    * successfully.
    */
    return program_success_code;
} /* main */

