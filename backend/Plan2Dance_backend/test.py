#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   test.py    
@Contact :   sfreebobo@163.com
@License :   (C)Copyright 2020-2021

@Modify Time      @Author    @Version    @Desciption
------------      -------    --------    -----------
2020/5/20 15:58   bobo      1.0         None
'''
from plan2dance.Plan2Dance.run import step_by_step

if __name__ == '__main__':
    music_path = "plan2dance/Data/Prepare/Music/POP/GEM-picture.mp3"
    ms = step_by_step(music_path, 1)
