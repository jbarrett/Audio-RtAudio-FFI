#!/usr/bin/env perl

use v5.40;

use Audio::RtAudio::FFI ':all';

my $samplerate = 48_000;
my $bufsize = 256;
my $rtaudio = rtaudio_create( RTAUDIO_API_UNIX_JACK );
my $device = rtaudio_get_default_output_device( $rtaudio );

my $output_params = RtAudioStreamParameters->new(
    device_id     => $device,
    num_channels  => 1,
    first_channel => 0,
);

my $stream_options = RtAudioStreamOptions->new(
    name  => 'LFO',
    flags => RTAUDIO_FLAGS_JACK_DONT_CONNECT,
);
sub lfo( $out, $in, $nframes, $stream_time, $stream_status, $userdata ) {
    ...
}

rtaudio_open_stream(
    $rtaudio,
    $output_params,
    undef,
    RTAUDIO_FORMAT_FLOAT32,
    $samplerate,
    \$bufsize,
    \&lfo,
    undef,
    $stream_options,
);

rtaudio_start_stream( $rtaudio );

sleep;
