﻿#!/usr/bin/env perl

#
# 動画を分割する Perl Script
# 元ファイルが"sample_data.mp4"のとき、
# 出力ファイルは"sample_data_0.mp4","sample_data_1.mp4",...
# である。
#

# $of ファイル名
# $of_ka 拡張子
my $of="sample_data";
my $of_ka=".mp4";
my $rf=$of.$of_ka;
 
# 何秒ごとに分割するか
my $split_sec=20*60;

# ffmpeg コマンド 
# -i:入力ファイル
my $ffmpeg="/opt/ffmpeg_build/bin/ffmpeg -i $rf";

# 元動画ファイルの長さ
my $max_sec=&count_time;

for(my $i=0,$j=0;;$i+=$split_sec,$j++){
	#元動画ファイルよりも後ろの部分を切り取ろうとしたら、終了
	if($i>$max_sec+1){
		last;
	}

	#オプション
	#配列にしてあるので、好みで変更できる
	#-c :codecのコピー
	#-ss:指定した時間から変換を始める
	#-t :指定秒変換する
	my @option1=("-c copy","-ss $i","-t $split_sec");

	my $option=&mkop(\@option1);

	#コマンド作成
	$exe=$ffmpeg.$option;
	#出力ファイル
	$exe.=" $of"."_".$j.$of_ka;

	#コマンド実行
	print $exe."\n";
	print "system=".system($exe)."\n";
}

#オプション作成
sub mkop{
	my ($op)=@_;
	my $cmd="";

	foreach(@$op){
		$cmd.=" ".$_;
	}

	return $cmd;
}

#動画の長さを取得
sub count_time{
	my $from_time=`$ffmpeg 2>&1 | grep Duration |cut -c 13-20`;
	my @time=split(/:/,$from_time);
	my $max_sec=0;
	foreach(@time){
		$max_sec*=60;
		$max_sec+=$_;
	}

	return $max_sec;
}
