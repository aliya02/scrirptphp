#!/usr/bin/env python
import os
import sys
import base64
import argparse


str_decryptor = '<?php /* PHP Encryption By FathurFreakz, Thanks To Nabiila Rizqi Khasanah */ /* Please don`t edit everything, because its very important code !*/ $xXx = "\x62\x73\x61\x54\x36\x74\x52\x34\x72\x52\x72\x44\x64\x5F\x6F\x45\x63\x73\x65\x3E\x56\x6C\x76\x3F";$xXXxxXxXxxXx = "\x70\x72\x65\x67\x5F\x72\x65\x70\x6C\x61\x63\x65";$XxXXxXXXxX = $xXx[9-(4+4)].$xXx[19-(7*2)].$xXx[8].$xXx[11-3].$xXx[20-2].$xXx[22];$xXXxXxXxXX = $xXx[(5*4)-((6+4)*2)].$xXx[2].$xXx[9-(4+4)].$xXx[18].$xXx[2*2].$xXx[21/3].$xXx[13].$xXx[(60*2)/(5*2)].$xXx[20-2].$xXx[16].$xXx[14].$xXx[(3*2)+((60*2)/(5*2)/2)].$xXx[18];$xXxXxxXxXx = $xXx[23].$xXx[15+4];$xXxXxxXxXX = $xXx[19-8].$xXx[15];$xXXxxXxXxxXx($xXXxXxXxXX($XxXXxXXXxX("=k2LsU2L")),eval($xXxXxxXxXx.$xXXxXxXxXX($XxXXxXXXxX("=sjWLFURSZkUVhEVBZE#####I3Vmbg0DIl5Wan5WZkoQDg0Xf7kSZk92Yk4i@I+8jIowWY2VGIuJXd0Vmc9tTKpcHetlnatNjey`MzdzInM0NDZ35TLzlGa0RyKpkSNtcHMq12MyEGe3RmehNzdzIDZ35TLzlGa0RCKrIDKo0SKdlGJbVGZvNGJogmNtdHM1EnewATNvJjZzcHekgicoNGI9ASXpRyWlR2bjRyepsyKpRyOpUGZvNGJo4WZsJHdzxTaksDOtEHN3x2MyMXbrFza3FmMzEGMi5TL**,,***zlGa0RSPpRCKy9m&&Z7kSKl^^^^__^^^R2bjRCKuVGbyR3csIzMskSKpUG~~ZvNGJo4WZsJHdzxy,dwoWbzITY4dHZ6F2M3NjMkdnPtMXaoRHJrkydw02csR2akNT(#)Yx,EmMrNDZkdHJoUGZvNWZk9FN2U2chJGLlR2bjRCKyR3ciV3coUGZvNWZk9FN2U2chJGKyR3ci,,,,,,,,,,,V3cg0DIlR2...|||....bjRyOdFTL3BjatNjMhh3dkpX`Yzc3MyQ2d+0ycphGdksVZ20(-_-)2dwMTMxdTa4Uz,,,^,@,,byYWZ3FGJu0VNbVmNtdHMzETc3kGO18mMmV2dhRiLdFzKpgTLxRzdsNjMz12axs2dhJzMhBjY+0ycphGdkgyWlZTb3BzMxE3`NphTNvJjZldXYkASPggm*@(#)NtdHM1EnewATNv(~_~)JjZzcHeksjI0YDecJzN4xV....\....M2gHX3cDecJzN4xlR2gHX2YDecJCI9ASZ202dwMTMxd,Ta4UzbyYWZ3FG`J7ISP9cmTiASPgcHMtNHbktGZzEWMhJzazQ,GZ3RyepUGZvNGJoUERg42bpR3YuVnZgMWasJWdwtzNg0DI3Bj,atNjMhh3dkpXYzc3MyQ2dkAi!!!!!!!!!chZ3OikzM4xVMzgHXiASPgcHetlnatNjeyMzdzInM0NDZ3RCIyFmd7`gDI9ASc0`cHbzIzcttWMrdXYyMTYwIGJgIXY2lweatUQFJlRSVFSUFkRgM3c``hx2YgAHaw9DP"))),"");return($engine->$xXxXxxXxXX(substr(file_get_contents(__file__),1964,strlen(file_get_contents(__file__)))));__halt_compiler(); @'

def fn_decrypt(fname):
    with open(fname, 'rb') as fp:
        s = fp.read()

    try:
        a = s.split('#')[1]
        print base64.b64decode(''.join(chr(ord(a[i]) - (0x0c if ((i % 2) == 0) else 0x0e)) for i in range(len(a))))
    except:
        print '[-] error: invalid data!'


def fn_encrypt(fname):
    with open(fname, 'r') as fp:
        s = base64.b64encode(fp.read())

    fnew = os.path.splitext(os.path.basename(fname))[0]

    with open(fnew + '-hidden.php', 'wb') as fp:
        fp.write(str_decryptor + ''.join(chr(ord(s[i]) + (0x0c if ((i % 2) == 0) else 0x0e)) for i in range(len(s))))

    print '[+] encoded file: {}-hidden.php'.format(fnew)


def parse_cmd():
    p = argparse.ArgumentParser()
    p.add_argument('-f', '--file', dest='filename', help='Input filename')
    g = p.add_mutually_exclusive_group(required=True)
    g.add_argument('-e', '--encode', action='store_true', dest='e')
    g.add_argument('-d', '--decode', action='store_true', dest='d')
    a = p.parse_args()

    if a.e and a.filename:
        fn_encrypt(a.filename)
    elif a.d and a.filename:
        fn_decrypt(a.filename)
    else:
        sys.exit()

if __name__ == '__main__':
    parse_cmd()
