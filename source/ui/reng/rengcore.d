module ui.reng.rengcore;

import raylib;
import re;
import re.math;
import std.algorithm.comparison : max;
import ui.device;
import ui.reng.emudebugscene;
import ui.reng.emuscene;


class RengCore : Core {
    int width;
    int height;
    int screen_scale;
    bool start_full_ui = false;

    this(int screen_scale, bool full_ui) {
        this.start_full_ui = full_ui;

        this.width  = WII_SCREEN_WIDTH * screen_scale;
        this.height = WII_SCREEN_HEIGHT * screen_scale;
        this.screen_scale = screen_scale;

        if (this.start_full_ui) {
            this.width  = max(this.width,  1280);
            this.height = max(this.height, 720);

            sync_render_window_resolution = true;
            auto_compensate_hidpi = true;
        }

        // raylib.SetConfigFlags(raylib.ConfigFlags.FLAG_WINDOW_RESIZABLE);
        super(width, height, "BeanWii");
    }

    override void initialize() {
        default_resolution = Vector2(width, height);
        content.paths ~= ["../content/", "content/"];

        screen_scale *= cast(int) window.scale_dpi;

        if (start_full_ui) {
            load_scenes([new EmuDebugInterfaceScene(screen_scale)]);
        } else {
            load_scenes([new EmuScene(screen_scale)]);
        }
    }

    pragma(inline, true) {
        void update_pub() {
            update();
        }

        void draw_pub() {
            draw();
        }
    }
}
