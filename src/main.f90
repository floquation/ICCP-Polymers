PROGRAM main

    USE Polymers
    USE timingModule

    IMPLICIT NONE

!OpenMP variables
    integer::  NUM_THREADS, TID

    call init()
    call simulate()
    call exportData()
    call finalize()

contains

!Obtain input variables, allocate variables
    subroutine init()
    !Read files
        open (12, file="polymere.params")
        read (12, *) NUM_THREADS
        read (12, *) max_poly_length
        read (12, *) max_num_poly
        read (12, *) num_thetha
        read (12, *) temperature
        read (12, *) alpha_UpLim
        read (12, *) alpha_LowLim
        read (12, *) greatest_duplication_fraction
        read (12, *) sigma
        close(12)

        CALL OMP_SET_NUM_THREADS(num_threads)

    !Random ssed
        CALL my_random_seed()

    !Allocate variables
        allocate(polymerList(max_num_poly), threadPolymerList(max_num_poly), &
            avWeight(max_poly_length), avWeightSize(max_poly_length))

        PRINT *, "INIT() completed"
    end subroutine init

!Random Generator
    subroutine my_random_seed()
        integer:: i, n, clock
        integer, allocatable :: seed(:)

        call random_seed(size = n)
        allocate(seed(n))

        call system_clock(count = clock)

        seed = clock  + 37*(/ (i-1, i=1, n) /)
        call random_seed(PUT = seed)


        deallocate(seed)


    end subroutine

!Main loop
    subroutine simulate()
        integer OMP_GET_THREAD_NUM !OMP gives compile issues if I do not declare this inside the subroutine...
        call startTimer()
        !$OMP PARALLEL PRIVATE(TID)
             DO WHILE(cur_num_poly < max_num_poly)
                ! TID = OMP_GET_THREAD_NUM()
                ! WRITE (6,'("(",I3,") cur_num_poly = ",I6)') TID, cur_num_poly
                 call newPolymer()
             END DO
        !$OMP END PARALLEL
        call stopTimer()
        call printTimer()
    end subroutine simulate

!This subroutine spawns a new polymer and attempts to grow it
    subroutine newPolymer()
        type(polymer):: p
        call p%create(max_poly_length) !Will automatically add the first 2 beads
        call p%add_bead(3) !Add the 3rd bead
    end subroutine newPolymer

!Write the polymeres to a file
    subroutine exportData()
        integer:: i

        print *, 'Starting to write to file...'

        open (31, file="polymereX.output")
        open (32, file="polymereY.output")
        open (33, file="thread.output")
        do i = 1,cur_num_poly
            call polymerList(i)%toString(31, 32)
        end do
        do i = 1,max_num_poly
            write (33,'(I4)') threadPolymerList(i)
        end do

        flush(31)
        close(31)
        flush(32)
        close(32)
        flush(33)
        close(33)

        print *, 'Finished writing to file.'
    end subroutine exportData

!Deallocation
    subroutine finalize()
        integer i
        do i = 1,SIZE(polymerList)
            call polymerList(i)%destroy()
        end do
        deallocate(polymerList, threadPolymerList, avWeight, avWeightSize)
    end subroutine finalize

END PROGRAM main
