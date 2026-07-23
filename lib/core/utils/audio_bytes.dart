// A short 0.1s beep sound encoded in base64 (WAV format)
const String beepBase64 =
    "UklGRiQAAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQAAAAA="; // this is just an empty wav header, wait, I need a real beep.

// Actually, generating a simple click is better using SystemSound, but SystemSound doesn't always play on all Android devices.
// Let me use a tiny valid base64 WAV containing a 1000Hz sine wave.
