function quick_save(sim_type, LHe_temp, BLoff_flag, rfoff_flag, Vcavout, Vampout, freqout, fnom, xpos, xpos1, xpos2, zpos, time, loss_frac, tbunch)

if sim_type == 0 % LHC cavity
    if LHe_temp == 2
        if BLoff_flag == 0 && rfoff_flag == 0
            Vcav_LHC_2K = Vcavout; %#ok<*NASGU>
            Vamp_LHC_2K = Vampout;
            df_LHC_2K = freqout - fnom;
            xpos_LHC_2K = xpos;
            xpos1_LHC_2K = xpos1;
            xpos2_LHC_2K = xpos2;
            zpos_LHC_2K = zpos;
            loss_frac_LHC_2K = loss_frac;
            delete('LHC_2K.mat');
            save('LHC_2K', 'Vcav_LHC_2K', 'Vamp_LHC_2K', 'df_LHC_2K', 'xpos_LHC_2K', 'xpos1_LHC_2K', 'xpos2_LHC_2K', 'zpos_LHC_2K', 'loss_frac_LHC_2K', 'tbunch');
        elseif BLoff_flag == 1 && rfoff_flag == 0
            Vcav_LHC_2K_BLoff = Vcavout;
            Vamp_LHC_2K_BLoff = Vampout;
            df_LHC_2K_BLoff = freqout - fnom;
            xpos_LHC_2K_BLoff = xpos;
            xpos1_LHC_2K_BLoff = xpos1;
            xpos2_LHC_2K_BLoff = xpos2;
            zpos_LHC_2K_BLoff = zpos;
            loss_frac_LHC_2K_BLoff = loss_frac;
            delete('LHC_2K_BLoff.mat');
            save('LHC_2K_BLoff', 'Vcav_LHC_2K_BLoff', 'Vamp_LHC_2K_BLoff', 'df_LHC_2K_BLoff', 'xpos_LHC_2K_BLoff', 'xpos1_LHC_2K_BLoff', 'xpos2_LHC_2K_BLoff', 'zpos_LHC_2K_BLoff', 'loss_frac_LHC_2K_BLoff');
        elseif BLoff_flag == 0 && rfoff_flag == 1
            Vcav_LHC_2K_RFoff = Vcavout;
            Vamp_LHC_2K_RFoff = Vampout;
            df_LHC_2K_RFoff = freqout - fnom;
            xpos_LHC_2K_RFoff = xpos;
            xpos1_LHC_2K_RFoff = xpos1;
            xpos2_LHC_2K_RFoff = xpos2;
            zpos_LHC_2K_RFoff = zpos;
            loss_frac_LHC_2K_RFoff = loss_frac;
            delete('LHC_2K_RFoff.mat');
            save('LHC_2K_RFoff', 'Vcav_LHC_2K_RFoff', 'Vamp_LHC_2K_RFoff', 'df_LHC_2K_RFoff', 'xpos_LHC_2K_RFoff', 'xpos1_LHC_2K_RFoff', 'xpos2_LHC_2K_RFoff', 'zpos_LHC_2K_RFoff', 'loss_frac_LHC_2K_RFoff');
        elseif BLoff_flag == 1 && rfoff_flag == 1
            Vcav_LHC_2K_BLoff_RFoff = Vcavout;
            Vamp_LHC_2K_BLoff_RFoff = Vampout;
            df_LHC_2K_BLoff_RFoff = freqout - fnom;
            xpos_LHC_2K_BLoff_RFoff = xpos;
            xpos1_LHC_2K_BLoff_RFoff = xpos1;
            xpos2_LHC_2K_BLoff_RFoff = xpos2;
            zpos_LHC_2K_BLoff_RFoff = zpos;
            loss_frac_LHC_2K_BLoff_RFoff = loss_frac;
            delete('LHC_2K_BLoff_RFoff.mat');
            save('LHC_2K_BLoff_RFoff', 'Vcav_LHC_2K_BLoff_RFoff', 'Vamp_LHC_2K_BLoff_RFoff', 'df_LHC_2K_BLoff_RFoff', 'xpos_LHC_2K_BLoff_RFoff', 'xpos1_LHC_2K_BLoff_RFoff', 'xpos2_LHC_2K_BLoff_RFoff', 'zpos_LHC_2K_BLoff_RFoff', 'loss_frac_LHC_2K_BLoff_RFoff');
        end
    elseif LHe_temp == 4
        if BLoff_flag == 0 && rfoff_flag == 0
            Vcav_LHC_4K = Vcavout;
            Vamp_LHC_4K = Vampout;
            df_LHC_4K = freqout - fnom;
            xpos_LHC_4K = xpos;
            xpos1_LHC_4K = xpos1;
            xpos2_LHC_4K = xpos2;
            zpos_LHC_4K = zpos;
            loss_frac_LHC_4K = loss_frac;
            delete('LHC_4K.mat');
            save('LHC_4K', 'Vcav_LHC_4K', 'Vamp_LHC_4K', 'df_LHC_4K', 'xpos_LHC_4K', 'xpos1_LHC_4K', 'xpos2_LHC_4K', 'zpos_LHC_4K', 'loss_frac_LHC_4K');
        elseif BLoff_flag == 1 && rfoff_flag == 0
            Vcav_LHC_4K_BLoff = Vcavout;
            Vamp_LHC_4K_BLoff = Vampout;
            df_LHC_4K_BLoff = freqout - fnom;
            xpos_LHC_4K_BLoff = xpos;
            xpos1_LHC_4K_BLoff = xpos1;
            xpos2_LHC_4K_BLoff = xpos2;
            zpos_LHC_4K_BLoff = zpos;
            loss_frac_LHC_4K_BLoff = loss_frac;
            delete('LHC_4K_BLoff.mat');
            save('LHC_4K_BLoff', 'Vcav_LHC_4K_BLoff', 'Vamp_LHC_4K_BLoff', 'df_LHC_4K_BLoff', 'xpos_LHC_4K_BLoff', 'xpos1_LHC_4K_BLoff', 'xpos2_LHC_4K_BLoff', 'zpos_LHC_4K_BLoff', 'loss_frac_LHC_4K_BLoff');
        elseif BLoff_flag == 0 && rfoff_flag == 1
            Vcav_LHC_4K_RFoff = Vcavout;
            Vamp_LHC_4K_RFoff = Vampout;
            df_LHC_4K_RFoff = freqout - fnom;
            xpos_LHC_4K_RFoff = xpos;
            xpos1_LHC_4K_RFoff = xpos1;
            xpos2_LHC_4K_RFoff = xpos2;
            zpos_LHC_4K_RFoff = zpos;
            loss_frac_LHC_4K_RFoff = loss_frac;
            delete('LHC_4K_RFoff.mat');
            save('LHC_4K_RFoff', 'Vcav_LHC_4K_RFoff', 'Vamp_LHC_4K_RFoff', 'df_LHC_4K_RFoff', 'xpos_LHC_4K_RFoff', 'xpos1_LHC_4K_RFoff', 'xpos2_LHC_4K_RFoff', 'zpos_LHC_4K_RFoff', 'loss_frac_LHC_4K_RFoff');
        elseif BLoff_flag == 1 && rfoff_flag == 1
            Vcav_LHC_4K_BLoff_RFoff = Vcavout;
            Vamp_LHC_4K_BLoff_RFoff = Vampout;
            df_LHC_4K_BLoff_RFoff = freqout - fnom;
            xpos_LHC_4K_BLoff_RFoff = xpos;
            xpos1_LHC_4K_BLoff_RFoff = xpos1;
            xpos2_LHC_4K_BLoff_RFoff = xpos2;
            zpos_LHC_4K_BLoff_RFoff = zpos;
            loss_frac_LHC_4K_BLoff_RFoff = loss_frac;
            delete('LHC_4K_BLoff_RFoff.mat');
            save('LHC_4K_BLoff_RFoff', 'Vcav_LHC_4K_BLoff_RFoff', 'Vamp_LHC_4K_BLoff_RFoff', 'df_LHC_4K_BLoff_RFoff', 'xpos_LHC_4K_BLoff_RFoff', 'xpos1_LHC_4K_BLoff_RFoff', 'xpos2_LHC_4K_BLoff_RFoff', 'zpos_LHC_4K_BLoff_RFoff', 'loss_frac_LHC_4K_BLoff_RFoff');
        end
    end
elseif sim_type == 1
    if LHe_temp == 2
        if BLoff_flag == 0 && rfoff_flag == 0
            Vcav_KEK_2K = Vcavout;
            Vamp_KEK_2K = Vampout;
            df_KEK_2K = freqout - fnom;
            xpos_KEK_2K = xpos;
            xpos1_KEK_2K = xpos1;
            xpos2_KEK_2K = xpos2;
            zpos_KEK_2K = zpos;
            loss_frac_KEK_2K = loss_frac;
            delete('KEK_2K.mat');
            save('KEK_2K', 'Vcav_KEK_2K', 'Vamp_KEK_2K', 'df_KEK_2K', 'xpos_KEK_2K', 'xpos1_KEK_2K', 'xpos2_KEK_2K', 'zpos_KEK_2K', 'loss_frac_KEK_2K');
        elseif BLoff_flag == 1 && rfoff_flag == 0
            Vcav_KEK_2K_BLoff = Vcavout;
            Vamp_KEK_2K_BLoff = Vampout;
            df_KEK_2K_BLoff = freqout - fnom;
            xpos_KEK_2K_BLoff = xpos;
            xpos1_KEK_2K_BLoff = xpos1;
            xpos2_KEK_2K_BLoff = xpos2;
            zpos_KEK_2K_BLoff = zpos;
            loss_frac_KEK_2K_BLoff = loss_frac;
            delete('KEK_2K_BLoff.mat');
            save('KEK_2K_BLoff', 'Vcav_KEK_2K_BLoff', 'Vamp_KEK_2K_BLoff', 'df_KEK_2K_BLoff', 'xpos_KEK_2K_BLoff', 'xpos1_KEK_2K_BLoff', 'xpos2_KEK_2K_BLoff', 'zpos_KEK_2K_BLoff', 'loss_frac_KEK_2K_BLoff');
        elseif BLoff_flag == 0 && rfoff_flag == 1
            Vcav_KEK_2K_RFoff = Vcavout;
            Vamp_KEK_2K_RFoff = Vampout;
            df_KEK_2K_RFoff = freqout - fnom;
            xpos_KEK_2K_RFoff = xpos;
            xpos1_KEK_2K_RFoff = xpos1;
            xpos2_KEK_2K_RFoff = xpos2;
            zpos_KEK_2K_RFoff = zpos;
            loss_frac_KEK_2K_RFoff = loss_frac;
            delete('KEK_2K_RFoff.mat');
            save('KEK_2K_RFoff', 'Vcav_KEK_2K_RFoff', 'Vamp_KEK_2K_RFoff', 'df_KEK_2K_RFoff', 'xpos_KEK_2K_RFoff', 'xpos1_KEK_2K_RFoff', 'xpos2_KEK_2K_RFoff', 'zpos_KEK_2K_RFoff', 'loss_frac_KEK_2K_RFoff');
        elseif BLoff_flag == 1 && rfoff_flag == 1
            Vcav_KEK_2K_BLoff_RFoff = Vcavout;
            Vamp_KEK_2K_BLoff_RFoff = Vampout;
            df_KEK_2K_BLoff_RFoff = freqout - fnom;
            xpos_KEK_2K_BLoff_RFoff = xpos;
            xpos1_KEK_2K_BLoff_RFoff = xpos1;
            xpos2_KEK_2K_BLoff_RFoff = xpos2;
            zpos_KEK_2K_BLoff_RFoff = zpos;
            loss_frac_KEK_2K_BLoff_RFoff = loss_frac;
            delete('KEK_2K_BLoff_RFoff.mat');
            save('KEK_2K_BLoff_RFoff', 'Vcav_KEK_2K_BLoff_RFoff', 'Vamp_KEK_2K_BLoff_RFoff', 'df_KEK_2K_BLoff_RFoff', 'xpos_KEK_2K_BLoff_RFoff', 'xpos1_KEK_2K_BLoff_RFoff', 'xpos2_KEK_2K_BLoff_RFoff', 'zpos_KEK_2K_BLoff_RFoff', 'loss_frac_KEK_2K_BLoff_RFoff');
        end
    elseif LHe_temp == 4
        if BLoff_flag == 0 && rfoff_flag == 0
            Vcav_KEK_4K = Vcavout;
            Vamp_KEK_4K = Vampout;
            df_KEK_4K = freqout - fnom;
            xpos_KEK_4K = xpos;
            xpos1_KEK_4K = xpos1;
            xpos2_KEK_4K = xpos2;
            zpos_KEK_4K = zpos;
            loss_frac_KEK_4K = loss_frac;
            delete('KEK_4K.mat');
            save('KEK_4K', 'Vcav_KEK_4K', 'Vamp_KEK_4K', 'df_KEK_4K', 'xpos_KEK_4K', 'xpos1_KEK_4K', 'xpos2_KEK_4K', 'zpos_KEK_4K', 'loss_frac_KEK_4K');
        elseif BLoff_flag == 1 && rfoff_flag == 0
            Vcav_KEK_4K_BLoff = Vcavout;
            Vamp_KEK_4K_BLoff = Vampout;
            df_KEK_4K_BLoff = freqout - fnom;
            xpos_KEK_4K_BLoff = xpos;
            xpos1_KEK_4K_BLoff = xpos1;
            xpos2_KEK_4K_BLoff = xpos2;
            zpos_KEK_4K_BLoff = zpos;
            loss_frac_KEK_4K_BLoff = loss_frac;
            delete('KEK_4K_BLoff.mat');
            save('KEK_4K_BLoff', 'Vcav_KEK_4K_BLoff', 'Vamp_KEK_4K_BLoff', 'df_KEK_4K_BLoff', 'xpos_KEK_4K_BLoff', 'xpos1_KEK_4K_BLoff', 'xpos2_KEK_4K_BLoff', 'zpos_KEK_4K_BLoff', 'loss_frac_KEK_4K_BLoff');
        elseif BLoff_flag == 0 && rfoff_flag == 1
            Vcav_KEK_4K_RFoff = Vcavout;
            Vamp_KEK_4K_RFoff = Vampout;
            df_KEK_4K_RFoff = freqout - fnom;
            xpos_KEK_4K_RFoff = xpos;
            xpos1_KEK_4K_RFoff = xpos1;
            xpos2_KEK_4K_RFoff = xpos2;
            zpos_KEK_4K_RFoff = zpos;
            loss_frac_KEK_4K_RFoff = loss_frac;
            delete('KEK_4K_RFoff.mat');
            save('KEK_4K_RFoff', 'Vcav_KEK_4K_RFoff', 'Vamp_KEK_4K_RFoff', 'df_KEK_4K_RFoff', 'xpos_KEK_4K_RFoff', 'xpos1_KEK_4K_RFoff', 'xpos2_KEK_4K_RFoff', 'zpos_KEK_4K_RFoff', 'loss_frac_KEK_4K_RFoff');
        elseif BLoff_flag == 1 && rfoff_flag == 1
            Vcav_KEK_4K_BLoff_RFoff = Vcavout;
            Vamp_KEK_4K_BLoff_RFoff = Vampout;
            df_KEK_4K_BLoff_RFoff = freqout - fnom;
            xpos_KEK_4K_BLoff_RFoff = xpos;
            xpos1_KEK_4K_BLoff_RFoff = xpos1;
            xpos2_KEK_4K_BLoff_RFoff = xpos2;
            zpos_KEK_4K_BLoff_RFoff = zpos;
            loss_frac_KEK_4K_BLoff_RFoff = loss_frac;
            delete('KEK_4K_BLoff_RFoff.mat');
            save('KEK_4K_BLoff_RFoff', 'Vcav_KEK_4K_BLoff_RFoff', 'Vamp_KEK_4K_BLoff_RFoff', 'df_KEK_4K_BLoff_RFoff', 'xpos_KEK_4K_BLoff_RFoff', 'xpos1_KEK_4K_BLoff_RFoff', 'xpos2_KEK_4K_BLoff_RFoff', 'zpos_KEK_4K_BLoff_RFoff', 'time', 'loss_frac_KEK_4K_BLoff_RFoff');
        end
    end
end