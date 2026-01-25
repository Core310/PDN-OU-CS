
!
! my_number.f90
!

      PROGRAM my_number

          IMPLICIT NONE
!
!........ DECLARATION SECTION
!
!........ Named Constant Declarations
!
!........ minimum_number:    the user's number should be at least this.
!........ maximum_number:    the user's number should be at most this.
!........ close_distance:    how close the user has to be to be told that
!........                    they're close.
!........ computers_number:  the number that the computer is "thinking" of.
!
          INTEGER,PARAMETER :: minimum_number       =  1
          INTEGER,PARAMETER :: maximum_number       = 10
          INTEGER,PARAMETER :: close_distance       =  1
          INTEGER,PARAMETER :: computers_number     =  5
          INTEGER,PARAMETER :: maximum_guesses      = 10
!
!........ Variable Declarations

!........ guesses_so_far:  how many guesses the user has made so far.

          INTEGER :: guesses_so_far

!........ users_number:  the user's chosen number.

          INTEGER :: users_number

!
!........ EXECUTION SECTION (BODY)
!
!........ Describe what the program does.

          PRINT *, "Let's see whether you can guess ",  &
     &        "the number that I'm thinking of."

!........ Tell the user the range to choose from.

          PRINT *, "It's between ", minimum_number, " and ",  &
     &        maximum_number, "."

!........ Keep asking for the user's number until they guess correctly.

          users_number   = minimum_number - 1

          guesses_so_far = 0

          DO WHILE ((users_number /= computers_number) .AND.  &
     &              (guesses_so_far < maximum_guesses))

!............ Prompt the user to guess.

              PRINT *, "What number am I thinking of?"

!............ Input the user's number.

              READ *, users_number

!............ Report the user's number.

              PRINT *, "You guessed ", users_number, "."

!............ Increment the number of guesses so far.

              guesses_so_far = guesses_so_far + 1

!............ Judge the user's number.

              IF ((users_number < minimum_number) .OR.  &
     &            (users_number > maximum_number)) THEN

!................ Idiotproof:  they're outside the range, so complain.

                  PRINT *, "Hey! That's not between ",  &
     &                minimum_number, " and ", maximum_number, "!"

              ELSE IF (users_number == computers_number) THEN

!................ They're correct, so be amazed.

                  PRINT *, "That's amazing!"

              ELSE IF (ABS(users_number - computers_number) <=  &
     &                 close_distance) THEN

!................ They're within close_distance, so say that they're close.

                  PRINT *, "Close, but no cigar."

              ELSE  !! (ABS(...) <= close_distance)

!................ They're not even close, so be cruel.

                  PRINT *, "Bzzzt! Not even close."

              END IF !! (ABS(...) <= close_distance)...ELSE

          END DO !! WHILE (users_number /= computers_number)

      END PROGRAM my_number

