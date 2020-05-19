import os
temp_dir = '/home/plan2dance'

if not os.path.exists(temp_dir):
    os.mkdir(temp_dir)
music_path = os.path.join(temp_dir, 'music')
pkl_path = os.path.join(temp_dir, 'pkl')
if not os.path.exists(music_path):
    os.mkdir(music_path)
if not os.path.exists(pkl_path):
    os.mkdir(pkl_path)