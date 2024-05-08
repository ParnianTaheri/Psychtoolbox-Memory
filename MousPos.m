function o = MousPos(fractal_pos, good_ind, mouse_x, mouse_y, size_w)
    display_size = size(fractal_pos, 2);
    o = 0;
    for i=1:display_size
        if (mouse_x >= fractal_pos(1, i)-size_w) && (mouse_x <= fractal_pos(1, i)+size_w) && (mouse_y >= fractal_pos(2, i)-size_w) && (mouse_y <= fractal_pos(2, i)+size_w)
            if (i == good_ind)
                o = 2;
            else
                o = 1;
            end
        end
    end
end

