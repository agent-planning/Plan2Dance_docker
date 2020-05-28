def file_wav_feature_extraction(file_name, mt_win, mt_step, st_win, st_step,
                                    compute_beat=False):
        """
        This function extracts the mid-term features of the WAVE files .

        The resulting feature vector is extracted by long-term averaging the mid-term features.
        Therefore ONE FEATURE VECTOR is extracted for each WAV file.

        ARGUMENTS:
            - fileName:        the path of the WAVE
            - mt_win, mt_step:    mid-term window and step (in seconds)
            - st_win, st_step:    short-term window and step (in seconds)
        """

        all_mt_feats = np.array([])

        print("Analyzing file name {}".format(file_name))

        if os.stat(file_name).st_size == 0:
            print("   (EMPTY FILE -- SKIPPING)")
            return
        [fs, x] = read_audio_file(file_name)
        if isinstance(x, int):
            return

        t1 = time.clock()
        x = stereo_to_mono(x)  # 将双声道或立体声的信号转为单声道，声道可以说是录制时候的音源数量问题
        if x.shape[0] < float(fs) / 5:
            print("  (AUDIO FILE TOO SMALL - SKIPPING)")
            return
        if compute_beat:  # fs（采样率） 每秒获取的信号 举例：一段音频10s，采样率为8000，即是1s的音频用8000信号单元表示
            [mt_term_feats, st_features, mt_feature_names] = mid_feature_extraction(x, fs, round(mt_win * fs),
                                                                                    round(mt_step * fs),
                                                                                    round(fs * st_win),
                                                                                    round(fs * st_step))
            mt_win_ratio = int(round(mt_win / st_step))
            mt_step_ratio = int(round(mt_step / st_step))
            beat_list, beat_conf_list = [], []
            cur_p = 0
            N = len(st_features[1])
            while (cur_p < N):
                N1 = cur_p
                N2 = cur_p + mt_win_ratio
                if N2 > N:
                    N2 = N
                cur_st_features = st_features[:, N1:N2]
                [beat, beat_conf] = beat_extraction(cur_st_features, st_step)
                if np.isnan(beat):
                    beat_conf = beat_list[-1]
                if np.isnan(beat_conf):
                    beat_conf = beat_conf_list[-1]
                beat_list.append(beat)
                beat_conf_list.append(beat_conf)
                cur_p += mt_step_ratio

            mt_term_feats = np.append(mt_term_feats, [beat_list], axis=0)
            mt_term_feats = np.append(mt_term_feats, [beat_conf_list], axis=0)
        else:
            [mt_term_feats, _, mt_feature_names] = mid_feature_extraction(x, fs, round(mt_win * fs),
                                                                          round(mt_step * fs),
                                                                          round(fs * st_win), round(fs * st_step))

        mt_term_feats = np.transpose(mt_term_feats)  # 转置矩阵
        # long term averaging of mid-term statistics
        if (not np.isnan(mt_term_feats).any()) and (not np.isinf(mt_term_feats).any()):
            all_mt_feats = mt_term_feats
            t2 = time.clock()
            duration = float(len(x)) / fs
            print("Music duration time: ", duration, ' s')
            # if len(process_times) > 0:
            print("Feature extraction complexity ratio: "
                  "{0:.1f} x realtime".format((1.0 / np.mean(np.array((t2 - t1) / duration)))))
        return (all_mt_feats, mt_feature_names)