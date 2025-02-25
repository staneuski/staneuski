# https://github.com/kovidgoyal/kitty/blob/c99d55691d6ecfe095f4423608fdc5f8bf432321/docs/kittens/custom.rst#L164
# map ctrl+k kitten zen_mode.py

from typing import List

from kitty.boss import Boss
from kittens.tui.handler import result_handler

def main(args: List[str]) -> str:
    pass

@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    in_zen_mode = getattr(boss, 'in_zen_mode', False)

    tab = boss.active_tab
    if tab is not None and tab.current_layout.name == 'stack':
        tab.last_used_layout()
    elif tab is not None:
        tab.goto_layout('stack')

    boss.change_font_size("all", "-" if in_zen_mode else '+', 8.0)
    boss.in_zen_mode = not in_zen_mode
