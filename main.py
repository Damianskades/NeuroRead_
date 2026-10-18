import os
import sys


def ajustar_escala_windows():
    if sys.platform != 'win32':
        return
    try:
        import ctypes
        try:
            if ctypes.windll.shcore.SetProcessDpiAwareness(2) not in (0, -2147024891):
                raise OSError
        except Exception:
            ctypes.windll.user32.SetProcessDPIAware()
        try:
            dpi = ctypes.windll.user32.GetDpiForSystem()
        except Exception:
            hdc = ctypes.windll.user32.GetDC(0)
            dpi = ctypes.windll.gdi32.GetDeviceCaps(hdc, 88)
            ctypes.windll.user32.ReleaseDC(0, hdc)
        factor = round(dpi / 96, 2) if dpi else 0
        if factor > 0:
            os.environ['KIVY_METRICS_DENSITY'] = str(factor)
    except Exception:
        pass


os.environ.setdefault('KIVY_METRICS_FONTSCALE', '1.15')
ajustar_escala_windows()

from app import NeuroReadApp

if __name__ == '__main__':
    NeuroReadApp().run()
