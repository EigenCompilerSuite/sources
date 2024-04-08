// SDL API wrapper
// Copyright (C) Florian Negele

// This file is part of the Eigen Compiler Suite.

// The ECS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// The ECS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// Under Section 7 of the GNU General Public License version 3,
// the copyright holder grants you additional permissions to use
// this file as described in the ECS Runtime Support Exception.

// You should have received a copy of the GNU General Public License
// and a copy of the ECS Runtime Support Exception along with
// the ECS.  If not, see <https://www.gnu.org/licenses/>.

#ifndef ECS_SDL_HEADER_INCLUDED
#define ECS_SDL_HEADER_INCLUDED

#include <cstdint>

#define SDL_ANYFORMAT 0x10000000
#define SDL_ASYNCBLIT 0x4
#define SDL_DOUBLEBUF 0x40000000
#define SDL_FULLSCREEN 0x80000000
#define SDL_HINT_ACCELEROMETER_AS_JOYSTICK "SDL_ACCELEROMETER_AS_JOYSTICK"
#define SDL_HINT_ALLOW_TOPMOST "SDL_ALLOW_TOPMOST"
#define SDL_HINT_FRAMEBUFFER_ACCELERATION "SDL_FRAMEBUFFER_ACCELERATION"
#define SDL_HINT_GAMECONTROLLERCONFIG "SDL_GAMECONTROLLERCONFIG"
#define SDL_HINT_GRAB_KEYBOARD "SDL_GRAB_KEYBOARD"
#define SDL_HINT_IDLE_TIMER_DISABLED "SDL_IOS_IDLE_TIMER_DISABLED"
#define SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS "SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS"
#define SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK "SDL_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK"
#define SDL_HINT_MOUSE_RELATIVE_MODE_WARP "SDL_MOUSE_RELATIVE_MODE_WARP"
#define SDL_HINT_ORIENTATIONS "SDL_IOS_ORIENTATIONS"
#define SDL_HINT_RENDER_DIRECT3D_THREADSAFE "SDL_RENDER_DIRECT3D_THREADSAFE"
#define SDL_HINT_RENDER_DRIVER "SDL_RENDER_DRIVER"
#define SDL_HINT_RENDER_OPENGL_SHADERS "SDL_RENDER_OPENGL_SHADERS"
#define SDL_HINT_RENDER_SCALE_QUALITY "SDL_RENDER_SCALE_QUALITY"
#define SDL_HINT_RENDER_VSYNC "SDL_RENDER_VSYNC"
#define SDL_HINT_TIMER_RESOLUTION "SDL_TIMER_RESOLUTION"
#define SDL_HINT_VIDEO_ALLOW_SCREENSAVER "SDL_VIDEO_ALLOW_SCREENSAVER"
#define SDL_HINT_VIDEO_HIGHDPI_DISABLED "SDL_VIDEO_HIGHDPI_DISABLED"
#define SDL_HINT_VIDEO_MAC_FULLSCREEN_SPACES "SDL_VIDEO_MAC_FULLSCREEN_SPACES"
#define SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS "SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS"
#define SDL_HINT_VIDEO_WIN_D3DCOMPILER "SDL_VIDEO_WIN_D3DCOMPILER"
#define SDL_HINT_VIDEO_WINDOW_SHARE_PIXEL_FORMAT "SDL_VIDEO_WINDOW_SHARE_PIXEL_FORMAT"
#define SDL_HINT_VIDEO_X11_XINERAMA "SDL_VIDEO_X11_XINERAMA"
#define SDL_HINT_VIDEO_X11_XRANDR "SDL_VIDEO_X11_XRANDR"
#define SDL_HINT_VIDEO_X11_XVIDMODE "SDL_VIDEO_X11_XVIDMODE"
#define SDL_HINT_XINPUT_ENABLED "SDL_XINPUT_ENABLED"
#define SDL_HWPALETTE 0x20000000
#define SDL_HWSURFACE 0x1
#define SDL_INIT_AUDIO 0x10
#define SDL_INIT_CDROM 0x100
#define SDL_INIT_EVENTTHREAD 0x1000000
#define SDL_INIT_EVERYTHING 0xffff
#define SDL_INIT_JOYSTICK 0x200
#define SDL_INIT_NOPARACHUTE 0x100000
#define SDL_INIT_TIMER 0x1
#define SDL_INIT_VIDEO 0x20
#define SDL_NOFRAME 0x20
#define SDL_OPENGL 0x2
#define SDL_OPENGLBLIT 0xa
#define SDL_RESIZABLE 0x10
#define SDL_SWSURFACE 0x0
#define SDL_WINDOWPOS_CENTERED 0x2fff0000
#define SDL_WINDOWPOS_UNDEFINED 0x1fff0000

enum SDL_bool {
	SDL_FALSE = 0,
	SDL_TRUE = 1,
};

enum SDL_BlendMode {
	SDL_BLENDMODE_ADD = 0x2,
	SDL_BLENDMODE_BLEND = 0x1,
	SDL_BLENDMODE_MOD = 0x4,
	SDL_BLENDMODE_NONE = 0x0,
};

enum SDL_EventType {
	SDL_APP_DIDENTERBACKGROUND = 0x104,
	SDL_APP_DIDENTERFOREGROUND = 0x106,
	SDL_APP_LOWMEMORY = 0x102,
	SDL_APP_TERMINATING = 0x101,
	SDL_APP_WILLENTERBACKGROUND = 0x103,
	SDL_APP_WILLENTERFOREGROUND = 0x105,
	SDL_AUDIODEVICEADDED = 0x1100,
	SDL_AUDIODEVICEREMOVED = 0x1101,
	SDL_CLIPBOARDUPDATE = 0x900,
	SDL_CONTROLLERAXISMOTION = 0x650,
	SDL_CONTROLLERBUTTONDOWN = 0x651,
	SDL_CONTROLLERBUTTONUP = 0x652,
	SDL_CONTROLLERDEVICEADDED = 0x653,
	SDL_CONTROLLERDEVICEREMAPPED = 0x655,
	SDL_CONTROLLERDEVICEREMOVED = 0x654,
	SDL_DOLLARGESTURE = 0x800,
	SDL_DOLLARRECORD = 0x801,
	SDL_DROPFILE = 0x1000,
	SDL_FINGERDOWN = 0x700,
	SDL_FINGERMOTION = 0x702,
	SDL_FINGERUP = 0x701,
	SDL_FIRSTEVENT = 0x0,
	SDL_JOYAXISMOTION = 0x600,
	SDL_JOYBALLMOTION = 0x601,
	SDL_JOYBUTTONDOWN = 0x603,
	SDL_JOYBUTTONUP = 0x604,
	SDL_JOYDEVICEADDED = 0x605,
	SDL_JOYDEVICEREMOVED = 0x606,
	SDL_JOYHATMOTION = 0x602,
	SDL_KEYDOWN = 0x300,
	SDL_KEYMAPCHANGED = 0x304,
	SDL_KEYUP = 0x301,
	SDL_LASTEVENT = 0xffff,
	SDL_MOUSEBUTTONDOWN = 0x401,
	SDL_MOUSEBUTTONUP = 0x402,
	SDL_MOUSEMOTION = 0x400,
	SDL_MOUSEWHEEL = 0x403,
	SDL_MULTIGESTURE = 0x802,
	SDL_QUIT = 0x100,
	SDL_RENDER_DEVICE_RESET = 0x2001,
	SDL_RENDER_TARGETS_RESET = 0x2000,
	SDL_SYSWMEVENT = 0x201,
	SDL_TEXTEDITING = 0x302,
	SDL_TEXTINPUT = 0x303,
	SDL_USEREVENT = 0x8000,
	SDL_WINDOWEVENT = 0x200,
};

enum SDL_Keycode {
};

enum SDL_RendererFlags {
	SDL_RENDERER_ACCELERATED = 0x2,
	SDL_RENDERER_PRESENTVSYNC = 0x4,
	SDL_RENDERER_SOFTWARE = 0x1,
	SDL_RENDERER_TARGETTEXTURE = 0x8,
};

enum SDL_Scancode {
	SDL_NUM_SCANCODES = 512,
	SDL_SCANCODE_0 = 39,
	SDL_SCANCODE_1 = 30,
	SDL_SCANCODE_2 = 31,
	SDL_SCANCODE_3 = 32,
	SDL_SCANCODE_4 = 33,
	SDL_SCANCODE_5 = 34,
	SDL_SCANCODE_6 = 35,
	SDL_SCANCODE_7 = 36,
	SDL_SCANCODE_8 = 37,
	SDL_SCANCODE_9 = 38,
	SDL_SCANCODE_A = 4,
	SDL_SCANCODE_AC_BACK = 270,
	SDL_SCANCODE_AC_BOOKMARKS = 274,
	SDL_SCANCODE_AC_FORWARD = 271,
	SDL_SCANCODE_AC_HOME = 269,
	SDL_SCANCODE_AC_REFRESH = 273,
	SDL_SCANCODE_AC_SEARCH = 268,
	SDL_SCANCODE_AC_STOP = 272,
	SDL_SCANCODE_AGAIN = 121,
	SDL_SCANCODE_ALTERASE = 153,
	SDL_SCANCODE_APOSTROPHE = 52,
	SDL_SCANCODE_APP1 = 283,
	SDL_SCANCODE_APP2 = 284,
	SDL_SCANCODE_APPLICATION = 101,
	SDL_SCANCODE_AUDIOMUTE = 262,
	SDL_SCANCODE_AUDIONEXT = 258,
	SDL_SCANCODE_AUDIOPLAY = 261,
	SDL_SCANCODE_AUDIOPREV = 259,
	SDL_SCANCODE_AUDIOSTOP = 260,
	SDL_SCANCODE_B = 5,
	SDL_SCANCODE_BACKSLASH = 49,
	SDL_SCANCODE_BACKSPACE = 42,
	SDL_SCANCODE_BRIGHTNESSDOWN = 275,
	SDL_SCANCODE_BRIGHTNESSUP = 276,
	SDL_SCANCODE_C = 6,
	SDL_SCANCODE_CALCULATOR = 266,
	SDL_SCANCODE_CANCEL = 155,
	SDL_SCANCODE_CAPSLOCK = 57,
	SDL_SCANCODE_CLEAR = 156,
	SDL_SCANCODE_CLEARAGAIN = 162,
	SDL_SCANCODE_COMMA = 54,
	SDL_SCANCODE_COMPUTER = 267,
	SDL_SCANCODE_COPY = 124,
	SDL_SCANCODE_CRSEL = 163,
	SDL_SCANCODE_CURRENCYSUBUNIT = 181,
	SDL_SCANCODE_CURRENCYUNIT = 180,
	SDL_SCANCODE_CUT = 123,
	SDL_SCANCODE_D = 7,
	SDL_SCANCODE_DECIMALSEPARATOR = 179,
	SDL_SCANCODE_DELETE = 76,
	SDL_SCANCODE_DISPLAYSWITCH = 277,
	SDL_SCANCODE_DOWN = 81,
	SDL_SCANCODE_E = 8,
	SDL_SCANCODE_EJECT = 281,
	SDL_SCANCODE_END = 77,
	SDL_SCANCODE_EQUALS = 46,
	SDL_SCANCODE_ESCAPE = 41,
	SDL_SCANCODE_EXECUTE = 116,
	SDL_SCANCODE_EXSEL = 164,
	SDL_SCANCODE_F10 = 67,
	SDL_SCANCODE_F11 = 68,
	SDL_SCANCODE_F12 = 69,
	SDL_SCANCODE_F13 = 104,
	SDL_SCANCODE_F14 = 105,
	SDL_SCANCODE_F15 = 106,
	SDL_SCANCODE_F1 = 58,
	SDL_SCANCODE_F16 = 107,
	SDL_SCANCODE_F17 = 108,
	SDL_SCANCODE_F18 = 109,
	SDL_SCANCODE_F19 = 110,
	SDL_SCANCODE_F20 = 111,
	SDL_SCANCODE_F21 = 112,
	SDL_SCANCODE_F22 = 113,
	SDL_SCANCODE_F23 = 114,
	SDL_SCANCODE_F24 = 115,
	SDL_SCANCODE_F2 = 59,
	SDL_SCANCODE_F3 = 60,
	SDL_SCANCODE_F4 = 61,
	SDL_SCANCODE_F5 = 62,
	SDL_SCANCODE_F6 = 63,
	SDL_SCANCODE_F7 = 64,
	SDL_SCANCODE_F8 = 65,
	SDL_SCANCODE_F = 9,
	SDL_SCANCODE_F9 = 66,
	SDL_SCANCODE_FIND = 126,
	SDL_SCANCODE_G = 10,
	SDL_SCANCODE_GRAVE = 53,
	SDL_SCANCODE_H = 11,
	SDL_SCANCODE_HELP = 117,
	SDL_SCANCODE_HOME = 74,
	SDL_SCANCODE_I = 12,
	SDL_SCANCODE_INSERT = 73,
	SDL_SCANCODE_INTERNATIONAL1 = 135,
	SDL_SCANCODE_INTERNATIONAL2 = 136,
	SDL_SCANCODE_INTERNATIONAL3 = 137,
	SDL_SCANCODE_INTERNATIONAL4 = 138,
	SDL_SCANCODE_INTERNATIONAL5 = 139,
	SDL_SCANCODE_INTERNATIONAL6 = 140,
	SDL_SCANCODE_INTERNATIONAL7 = 141,
	SDL_SCANCODE_INTERNATIONAL8 = 142,
	SDL_SCANCODE_INTERNATIONAL9 = 143,
	SDL_SCANCODE_J = 13,
	SDL_SCANCODE_K = 14,
	SDL_SCANCODE_KBDILLUMDOWN = 279,
	SDL_SCANCODE_KBDILLUMTOGGLE = 278,
	SDL_SCANCODE_KBDILLUMUP = 280,
	SDL_SCANCODE_KP_000 = 177,
	SDL_SCANCODE_KP_00 = 176,
	SDL_SCANCODE_KP_0 = 98,
	SDL_SCANCODE_KP_1 = 89,
	SDL_SCANCODE_KP_2 = 90,
	SDL_SCANCODE_KP_3 = 91,
	SDL_SCANCODE_KP_4 = 92,
	SDL_SCANCODE_KP_5 = 93,
	SDL_SCANCODE_KP_6 = 94,
	SDL_SCANCODE_KP_7 = 95,
	SDL_SCANCODE_KP_8 = 96,
	SDL_SCANCODE_KP_9 = 97,
	SDL_SCANCODE_KP_A = 188,
	SDL_SCANCODE_KP_AMPERSAND = 199,
	SDL_SCANCODE_KP_AT = 206,
	SDL_SCANCODE_KP_B = 189,
	SDL_SCANCODE_KP_BACKSPACE = 187,
	SDL_SCANCODE_KP_BINARY = 218,
	SDL_SCANCODE_KP_C = 190,
	SDL_SCANCODE_KP_CLEAR = 216,
	SDL_SCANCODE_KP_CLEARENTRY = 217,
	SDL_SCANCODE_KP_COLON = 203,
	SDL_SCANCODE_KP_COMMA = 133,
	SDL_SCANCODE_KP_D = 191,
	SDL_SCANCODE_KP_DBLAMPERSAND = 200,
	SDL_SCANCODE_KP_DBLVERTICALBAR = 202,
	SDL_SCANCODE_KP_DECIMAL = 220,
	SDL_SCANCODE_KP_DIVIDE = 84,
	SDL_SCANCODE_KP_E = 192,
	SDL_SCANCODE_KP_ENTER = 88,
	SDL_SCANCODE_KP_EQUALS = 103,
	SDL_SCANCODE_KP_EQUALSAS400 = 134,
	SDL_SCANCODE_KP_EXCLAM = 207,
	SDL_SCANCODE_KP_F = 193,
	SDL_SCANCODE_KP_GREATER = 198,
	SDL_SCANCODE_KP_HASH = 204,
	SDL_SCANCODE_KP_HEXADECIMAL = 221,
	SDL_SCANCODE_KP_LEFTBRACE = 184,
	SDL_SCANCODE_KP_LEFTPAREN = 182,
	SDL_SCANCODE_KP_LESS = 197,
	SDL_SCANCODE_KP_MEMADD = 211,
	SDL_SCANCODE_KP_MEMCLEAR = 210,
	SDL_SCANCODE_KP_MEMDIVIDE = 214,
	SDL_SCANCODE_KP_MEMMULTIPLY = 213,
	SDL_SCANCODE_KP_MEMRECALL = 209,
	SDL_SCANCODE_KP_MEMSTORE = 208,
	SDL_SCANCODE_KP_MEMSUBTRACT = 212,
	SDL_SCANCODE_KP_MINUS = 86,
	SDL_SCANCODE_KP_MULTIPLY = 85,
	SDL_SCANCODE_KP_OCTAL = 219,
	SDL_SCANCODE_KP_PERCENT = 196,
	SDL_SCANCODE_KP_PERIOD = 99,
	SDL_SCANCODE_KP_PLUS = 87,
	SDL_SCANCODE_KP_PLUSMINUS = 215,
	SDL_SCANCODE_KP_POWER = 195,
	SDL_SCANCODE_KP_RIGHTBRACE = 185,
	SDL_SCANCODE_KP_RIGHTPAREN = 183,
	SDL_SCANCODE_KP_SPACE = 205,
	SDL_SCANCODE_KP_TAB = 186,
	SDL_SCANCODE_KP_VERTICALBAR = 201,
	SDL_SCANCODE_KP_XOR = 194,
	SDL_SCANCODE_L = 15,
	SDL_SCANCODE_LALT = 226,
	SDL_SCANCODE_LANG1 = 144,
	SDL_SCANCODE_LANG2 = 145,
	SDL_SCANCODE_LANG3 = 146,
	SDL_SCANCODE_LANG4 = 147,
	SDL_SCANCODE_LANG5 = 148,
	SDL_SCANCODE_LANG6 = 149,
	SDL_SCANCODE_LANG7 = 150,
	SDL_SCANCODE_LANG8 = 151,
	SDL_SCANCODE_LANG9 = 152,
	SDL_SCANCODE_LCTRL = 224,
	SDL_SCANCODE_LEFT = 80,
	SDL_SCANCODE_LEFTBRACKET = 47,
	SDL_SCANCODE_LGUI = 227,
	SDL_SCANCODE_LSHIFT = 225,
	SDL_SCANCODE_M = 16,
	SDL_SCANCODE_MAIL = 265,
	SDL_SCANCODE_MEDIASELECT = 263,
	SDL_SCANCODE_MENU = 118,
	SDL_SCANCODE_MINUS = 45,
	SDL_SCANCODE_MODE = 257,
	SDL_SCANCODE_MUTE = 127,
	SDL_SCANCODE_N = 17,
	SDL_SCANCODE_NONUSBACKSLASH = 100,
	SDL_SCANCODE_NONUSHASH = 50,
	SDL_SCANCODE_NUMLOCKCLEAR = 83,
	SDL_SCANCODE_O = 18,
	SDL_SCANCODE_OPER = 161,
	SDL_SCANCODE_OUT = 160,
	SDL_SCANCODE_P = 19,
	SDL_SCANCODE_PAGEDOWN = 78,
	SDL_SCANCODE_PAGEUP = 75,
	SDL_SCANCODE_PASTE = 125,
	SDL_SCANCODE_PAUSE = 72,
	SDL_SCANCODE_PERIOD = 55,
	SDL_SCANCODE_POWER = 102,
	SDL_SCANCODE_PRINTSCREEN = 70,
	SDL_SCANCODE_PRIOR = 157,
	SDL_SCANCODE_Q = 20,
	SDL_SCANCODE_R = 21,
	SDL_SCANCODE_RALT = 230,
	SDL_SCANCODE_RCTRL = 228,
	SDL_SCANCODE_RETURN2 = 158,
	SDL_SCANCODE_RETURN = 40,
	SDL_SCANCODE_RGUI = 231,
	SDL_SCANCODE_RIGHT = 79,
	SDL_SCANCODE_RIGHTBRACKET = 48,
	SDL_SCANCODE_RSHIFT = 229,
	SDL_SCANCODE_S = 22,
	SDL_SCANCODE_SCROLLLOCK = 71,
	SDL_SCANCODE_SELECT = 119,
	SDL_SCANCODE_SEMICOLON = 51,
	SDL_SCANCODE_SEPARATOR = 159,
	SDL_SCANCODE_SLASH = 56,
	SDL_SCANCODE_SLEEP = 282,
	SDL_SCANCODE_SPACE = 44,
	SDL_SCANCODE_STOP = 120,
	SDL_SCANCODE_SYSREQ = 154,
	SDL_SCANCODE_T = 23,
	SDL_SCANCODE_TAB = 43,
	SDL_SCANCODE_THOUSANDSSEPARATOR = 178,
	SDL_SCANCODE_U = 24,
	SDL_SCANCODE_UNDO = 122,
	SDL_SCANCODE_UNKNOWN = 0,
	SDL_SCANCODE_UP = 82,
	SDL_SCANCODE_V = 25,
	SDL_SCANCODE_VOLUMEDOWN = 129,
	SDL_SCANCODE_VOLUMEUP = 128,
	SDL_SCANCODE_W = 26,
	SDL_SCANCODE_WWW = 264,
	SDL_SCANCODE_X = 27,
	SDL_SCANCODE_Y = 28,
	SDL_SCANCODE_Z = 29,
};

enum SDL_TextureAccess {
	SDL_TEXTUREACCESS_STATIC = 0,
	SDL_TEXTUREACCESS_STREAMING = 1,
	SDL_TEXTUREACCESS_TARGET = 2,
};

enum SDL_WindowEventID {
	SDL_WINDOWEVENT_CLOSE = 14,
	SDL_WINDOWEVENT_ENTER = 10,
	SDL_WINDOWEVENT_EXPOSED = 3,
	SDL_WINDOWEVENT_FOCUS_GAINED = 12,
	SDL_WINDOWEVENT_FOCUS_LOST = 13,
	SDL_WINDOWEVENT_HIDDEN = 2,
	SDL_WINDOWEVENT_LEAVE = 11,
	SDL_WINDOWEVENT_MAXIMIZED = 8,
	SDL_WINDOWEVENT_MINIMIZED = 7,
	SDL_WINDOWEVENT_MOVED = 4,
	SDL_WINDOWEVENT_NONE = 0,
	SDL_WINDOWEVENT_RESIZED = 5,
	SDL_WINDOWEVENT_RESTORED = 9,
	SDL_WINDOWEVENT_SHOWN = 1,
	SDL_WINDOWEVENT_SIZE_CHANGED = 6,
};

enum SDL_WindowFlags {
	SDL_WINDOW_ALLOW_HIGHDPI = 0x02000,
	SDL_WINDOW_BORDERLESS = 0x010,
	SDL_WINDOW_FOREIGN = 0x0800,
	SDL_WINDOW_FULLSCREEN = 0x01,
	SDL_WINDOW_FULLSCREEN_DESKTOP = 0x01001,
	SDL_WINDOW_HIDDEN = 0x08,
	SDL_WINDOW_INPUT_FOCUS = 0x0200,
	SDL_WINDOW_INPUT_GRABBED = 0x0100,
	SDL_WINDOW_MAXIMIZED = 0x080,
	SDL_WINDOW_MINIMIZED = 0x040,
	SDL_WINDOW_MOUSE_FOCUS = 0x0400,
	SDL_WINDOW_OPENGL = 0x02,
	SDL_WINDOW_RESIZABLE = 0x020,
	SDL_WINDOW_SHOWN = 0x04,
};

using Sint32 = std::int32_t;
using Uint8 = std::uint8_t;
using Uint16 = std::uint16_t;
using Uint32 = std::uint32_t;

using SDL_GLContext = void*;

struct SDL_Color {Uint8 r, g, b, a;};
struct SDL_Point {int x, y;};
struct SDL_Rect {int x, y, w, h;};
struct SDL_Renderer;
struct SDL_Surface;
struct SDL_Texture;
struct SDL_Window;

struct SDL_Keysym {
	SDL_Scancode scancode;
	SDL_Keycode sym;
	Uint16 mod;
	Uint32 unused;
};

struct SDL_CommonEvent {
	Uint32 type;
	Uint32 timestamp;
};

struct SDL_KeyboardEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Uint8 state;
	Uint8 repeat;
	Uint8 padding2;
	Uint8 padding3;
	SDL_Keysym keysym;
};

struct SDL_MouseButtonEvent
{
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Uint32 which;
	Uint8 button;
	Uint8 state;
	Uint8 clicks;
	Uint8 padding1;
	Sint32 x;
	Sint32 y;
};

struct SDL_MouseMotionEvent
{
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Uint32 which;
	Uint32 state;
	Sint32 x;
	Sint32 y;
	Sint32 xrel;
	Sint32 yrel;
};

struct SDL_MouseWheelEvent
{
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Uint32 which;
	Sint32 x;
	Sint32 y;
	Uint32 direction;
};

struct SDL_Palette
{
	int ncolors;
	SDL_Color* colors;
	Uint32 version;
	int refcount;
};

struct SDL_PixelFormat
{
	Uint32 format;
	SDL_Palette* palette;
	Uint8 BitsPerPixel;
	Uint8 BytesPerPixel;
	Uint8 padding[2];
	Uint32 Rmask;
	Uint32 Gmask;
	Uint32 Bmask;
	Uint32 Amask;
	Uint8 Rloss;
	Uint8 Gloss;
	Uint8 Bloss;
	Uint8 Aloss;
	Uint8 Rshift;
	Uint8 Gshift;
	Uint8 Bshift;
	Uint8 Ashift;
	int refcount;
	SDL_PixelFormat* next;
};

struct SDL_Surface
{
	Uint32 flags;
	SDL_PixelFormat *format;
	int w;
	int h;
	int pitch;
	void* pixels;
	void* userdata;
	int locked;
	void* list_blitmap;
	SDL_Rect clip_rect;
	void* map;
	int refcount;
};

struct SDL_TextEditingEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	char text[32];
	Sint32 start;
	Sint32 length;
};

struct SDL_TextInputEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	char text[32];
};

struct SDL_WindowEvent {
	Uint32 type;
	Uint32 timestamp;
	Uint32 windowID;
	Uint8 event;
	Uint8 padding1;
	Uint8 padding2;
	Uint8 padding3;
	Sint32 data1;
	Sint32 data2;
};

union SDL_Event {
	Uint32 type;
	SDL_CommonEvent common;
	SDL_WindowEvent window;
	SDL_KeyboardEvent key;
	SDL_TextEditingEvent edit;
	SDL_TextInputEvent text;
	SDL_MouseMotionEvent motion;
	SDL_MouseButtonEvent button;
	SDL_MouseWheelEvent wheel;
};

extern "C" auto SDL_BlitSurface (SDL_Surface* src, const SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect) noexcept -> int;
extern "C" auto SDL_CreateRenderer (SDL_Window* window, int index, Uint32 flags) noexcept -> SDL_Renderer*;
extern "C" auto SDL_CreateTextureFromSurface (SDL_Renderer* renderer, SDL_Surface* surface) noexcept -> SDL_Texture*;
extern "C" auto SDL_CreateTexture (SDL_Renderer* renderer, Uint32 format, int access, int w, int h) noexcept -> SDL_Texture*;
extern "C" auto SDL_CreateWindow (const char* title, int x, int y, int w, int h, Uint32 flags) noexcept -> SDL_Window*;
extern "C" auto SDL_Delay (Uint32 ms) noexcept -> void;
extern "C" auto SDL_DestroyRenderer (SDL_Renderer* renderer) noexcept -> void;
extern "C" auto SDL_DestroyTexture (SDL_Texture* texture) noexcept -> void;
extern "C" auto SDL_DestroyWindow (SDL_Window* window) noexcept -> void;
extern "C" auto SDL_DisableScreenSaver () noexcept -> void;
extern "C" auto SDL_EnableScreenSaver () noexcept -> void;
extern "C" auto SDL_EnclosePoints (const SDL_Point* points, int count, const SDL_Rect* clip, SDL_Rect* result) noexcept -> SDL_bool;
extern "C" auto SDL_FillRect (SDL_Surface* dst, const SDL_Rect* rect, Uint32 color) noexcept -> int;
extern "C" auto SDL_GetClipboardText () noexcept -> char*;
extern "C" auto SDL_GetDisplayBounds (int displayIndex, SDL_Rect* rect) noexcept -> int;
extern "C" auto SDL_GetError () noexcept -> const char*;
extern "C" auto SDL_GetHint (const char* name) noexcept -> const char*;
extern "C" auto SDL_GetNumVideoDisplays () noexcept -> int;
extern "C" auto SDL_GetTextureAlphaMod (SDL_Texture* texture, Uint8* alpha) noexcept -> int;
extern "C" auto SDL_GetTextureBlendMode (SDL_Texture* texture, SDL_BlendMode* blendMode) noexcept -> int;
extern "C" auto SDL_GetTextureColorMod (SDL_Texture* texture, Uint8* r, Uint8* g, Uint8* b) noexcept -> int;
extern "C" auto SDL_GetTicks () noexcept -> Uint32;
extern "C" auto SDL_GetWindowSize (SDL_Window* window, int* w, int* h) noexcept -> void;
extern "C" auto SDL_GetWindowSurface (SDL_Window *window) noexcept -> SDL_Surface*;
extern "C" auto SDL_GL_CreateContext (SDL_Window* window) noexcept -> SDL_GLContext;
extern "C" auto SDL_GL_DeleteContext (SDL_GLContext context) noexcept -> void;
extern "C" auto SDL_GL_MakeCurrent (SDL_Window* window, SDL_GLContext context) noexcept -> int;
extern "C" auto SDL_HasClipboardText () noexcept -> SDL_bool;
extern "C" auto SDL_HasIntersection (const SDL_Rect* A, const SDL_Rect* B) noexcept -> SDL_bool;
extern "C" auto SDL_Init (Uint32 flags) noexcept -> int;
extern "C" auto SDL_InitSubSystem (Uint32 flags) noexcept -> int;
extern "C" auto SDL_IntersectRect (const SDL_Rect* A, const SDL_Rect* B, SDL_Rect* result) noexcept -> SDL_bool;
extern "C" auto SDL_IsScreenSaverEnabled () noexcept -> SDL_bool;
extern "C" auto SDL_LockTexture (SDL_Texture* texture, const SDL_Rect* rect, void** pixels, int* pitch) noexcept -> int;
extern "C" auto SDL_MapRGB (const SDL_PixelFormat* format, Uint8 r, Uint8 g, Uint8 b) noexcept -> Uint32;
extern "C" auto SDL_MapRGBA (const SDL_PixelFormat* format, Uint8 r, Uint8 g, Uint8 b, Uint8 a) noexcept -> Uint32;
extern "C" auto SDL_PollEvent (SDL_Event* event) noexcept -> int;
extern "C" auto SDL_QueryTexture (SDL_Texture* texture, Uint32* format, int* access, int* w, int* h) noexcept -> int;
extern "C" auto SDL_Quit () noexcept -> void;
extern "C" auto SDL_QuitSubSystem (Uint32 flags) noexcept -> void;
extern "C" auto SDL_RenderClear (SDL_Renderer* renderer) noexcept -> int;
extern "C" auto SDL_RenderCopy (SDL_Renderer* renderer, SDL_Texture* texture, const SDL_Rect* srcrect, const SDL_Rect* dstrect) noexcept -> int;
extern "C" auto SDL_RenderDrawLine (SDL_Renderer* renderer, int x1, int y1, int x2, int y2) noexcept -> int;
extern "C" auto SDL_RenderDrawLines (SDL_Renderer* renderer, const SDL_Point* points, int count) noexcept -> int;
extern "C" auto SDL_RenderDrawPoint (SDL_Renderer* renderer, int x, int y) noexcept -> int;
extern "C" auto SDL_RenderDrawPoints (SDL_Renderer* renderer, const SDL_Point* points, int count) noexcept -> int;
extern "C" auto SDL_RenderDrawRect (SDL_Renderer* renderer, const SDL_Rect* rect) noexcept -> int;
extern "C" auto SDL_RenderDrawRects (SDL_Renderer* renderer, const SDL_Rect* rects, int count) noexcept -> int;
extern "C" auto SDL_RenderFillRect (SDL_Renderer* renderer, const SDL_Rect* rect) noexcept -> int;
extern "C" auto SDL_RenderPresent (SDL_Renderer* renderer) noexcept -> void;
extern "C" auto SDL_RenderReadPixels (SDL_Renderer* renderer, const SDL_Rect* rect, Uint32 format, void* pixels, int pitch) noexcept -> int;
extern "C" auto SDL_SetClipboardText (const char* text) noexcept -> int;
extern "C" auto SDL_SetHint (const char* name, const char* value) noexcept -> SDL_bool;
extern "C" auto SDL_SetRenderDrawColor (SDL_Renderer* renderer, Uint8 r, Uint8 g, Uint8 b, Uint8 a) noexcept -> int;
extern "C" auto SDL_SetTextureAlphaMod (SDL_Texture* texture, Uint8 alpha) noexcept -> int;
extern "C" auto SDL_SetTextureBlendMode (SDL_Texture* texture, SDL_BlendMode blendMode) noexcept -> int;
extern "C" auto SDL_SetTextureColorMod (SDL_Texture* texture, Uint8 r, Uint8 g, Uint8 b) noexcept -> int;
extern "C" auto SDL_SetVideoMode (int width, int height, int bpp, Uint32 flags) noexcept -> SDL_Surface*;
extern "C" auto SDL_ShowCursor (int toggle) noexcept -> int;
extern "C" auto SDL_ShowSimpleMessageBox (Uint32 flags, const char* title, const char* message, SDL_Window* window) noexcept -> int;
extern "C" auto SDL_ShowWindow (SDL_Window* window) noexcept -> void;
extern "C" auto SDL_UnionRect (const SDL_Rect* A, const SDL_Rect* B, SDL_Rect* result) noexcept -> void;
extern "C" auto SDL_UnlockTexture (SDL_Texture* texture) noexcept -> void;
extern "C" auto SDL_UpdateTexture (SDL_Texture* texture, const SDL_Rect* rect, const void* pixels, int pitch) noexcept -> int;
extern "C" auto SDL_UpdateWindowSurface (SDL_Window* window) noexcept -> int;
extern "C" auto SDL_UpdateWindowSurfaceRects (SDL_Window* window, const SDL_Rect* rects, int numrects) noexcept -> int;
extern "C" auto SDL_WaitEvent (SDL_Event* event) noexcept -> int;
extern "C" auto SDL_WaitEventTimeout (SDL_Event* event, int timeout) noexcept -> int;
extern "C" auto SDL_WasInit (Uint32 flags) noexcept -> Uint32;
extern "C" auto SDL_WM_SetCaption (const char* title, const char* icon) noexcept -> void;

#endif // ECS_SDL_HEADER_INCLUDED
