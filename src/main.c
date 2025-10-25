#include <efi.h>
#include <efilib.h>

EFI_STATUS
EFIAPI
efi_main(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable){
    InitializeLib(ImageHandle, SystemTable);

    EFI_STATUS Status;
    EFI_BOOT_SERVICES *BootServices = SystemTable->BootServices;
    SIMPLE_TEXT_OUTPUT_INTERFACE *ConOut = SystemTable->ConOut;
    SIMPLE_INPUT_INTERFACE *ConIn = SystemTable->ConIn;
    EFI_INPUT_KEY Key;
    // Store the system table for future use in other functions
    ST = SystemTable;

    // Print messages to the UEFI console
    Print(L"Working\r\n");
    // Print 2, Status = ST->ConOut->OutputString(ST->ConOut, L"Hello World\r\n"); // Must use uefi_call_wrapper() with gnu-efi
    Status = uefi_call_wrapper(ConOut->OutputString,2,ConOut,L"Hello World\r\n"); // EFI Applications use Unicode and CRLF
    if (EFI_ERROR(Status))
        return Status;

    // Empty the console input buffer to flush out any keystrokes entered before this point, can also use ReadKeyStroke
    //Status = ST->ConIn->Reset(ST->ConIn, FALSE);
    Status = uefi_call_wrapper(ConIn->Reset,2,ConIn,FALSE);
    if (EFI_ERROR(Status))
        return Status;
    // Simple polling implementation,waits for input, could use WaitForEvent, Status = ST->ConIn->ReadKeyStroke(ST->ConIn, &Key)
    //while ((Status = uefi_call_wrapper(ConIn->ReadKeyStroke,2,ConIn,&Key)) == EFI_NOT_READY);

    // Clear the screen, Status = ST->ConOut->ClearScreen(ST->ConOut);
    Status = uefi_call_wrapper(ConOut->ClearScreen,1,ConOut);
    if(EFI_ERROR(Status)) {
        Print(L"ClearScreen failed: %r\n", Status);
        return Status;
    }
    
    Print(L"Waiting\r\n");
    for(int x=0;x<500000000;x++){
        volatile void;
    }
    Print(L"Done\r\n");

    Status = uefi_call_wrapper(ConIn->Reset,2,ConIn,FALSE);
    // Wait for a key press before exiting, SystemTable->BootServices->WaitForEvent(1, &SystemTable->ConIn->WaitForKey, NULL);
    UINTN Index = 0;
    Status = uefi_call_wrapper(BootServices->WaitForEvent,3,1,&ConIn->WaitForKey,&Index);

    Status = uefi_call_wrapper(ConIn->ReadKeyStroke,2,ConIn,&Key);
    if (EFI_ERROR(Status)) {
        Print(L"\nReadKeyStroke failed: %r\n", Status);
        return Status;
    }
    /* Print the Unicode character (if printable) */
    Print(L"\nYou pressed: ");
    if (Key.UnicodeChar >= 0x20 && Key.UnicodeChar <= 0x7E) {
        /* Printable ASCII range */
        Print(L"%c", Key.UnicodeChar);
    } else {
        /* Show the scan code for non‑printable keys */
        Print(L"<scan code 0x%04x>", Key.ScanCode);
    }
    Print(L"\n");

    return EFI_SUCCESS;
    //return Status;
}