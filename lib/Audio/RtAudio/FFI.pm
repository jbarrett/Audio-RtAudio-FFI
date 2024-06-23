use strict;
use warnings;
package Audio::RtAudio::FFI;

# ABSTRACT: Bindings for librtaudio - Realtime audio input/output library

use base qw/ Exporter /;
use FFI::Platypus 2.00;
use FFI::CheckLib 0.25 qw/ find_lib_or_die /;
use Carp qw/ croak carp /;

our $VERSION = '0.00';

my $enum_RtAudioError;
my $enum_RtAudioApi;
my $constants;
my $binds;
my $ffi;
sub _load_rtmidi {
    $ffi = FFI::Platypus->new(
        api => 2,
        lib => [
            find_lib_or_die(
                lib   => 'rtaudio',
                alien => 'Alien::RtAudio',
            )
        ]
    );
    return 1;
}

BEGIN {
    _load_rtmidi;

    $constants = {
        RTAUDIO_FORMAT_SINT8    => 0x01,
        RTAUDIO_FORMAT_SINT16   => 0x02,
        RTAUDIO_FORMAT_SINT24   => 0x04,
        RTAUDIO_FORMAT_SINT32   => 0x08,
        RTAUDIO_FORMAT_FLOAT32  => 0x10,
        RTAUDIO_FORMAT_FLOAT64  => 0x20,

        RTAUDIO_FLAGS_NONINTERLEAVED    => 0x1,
        RTAUDIO_FLAGS_MINIMIZE_LATENCY  => 0x2,
        RTAUDIO_FLAGS_HOG_DEVICE        => 0x4,
        RTAUDIO_FLAGS_SCHEDULE_REALTIME => 0x8,
        RTAUDIO_FLAGS_ALSA_USE_DEFAULT  => 0x10,
        RTAUDIO_FLAGS_JACK_DONT_CONNECT => 0x20,

        RTAUDIO_STATUS_INPUT_OVERFLOW   => 0x1,
        RTAUDIO_STATUS_OUTPUT_UNDERFLOW => 0x2,

        NUM_SAMPLE_RATES => 16,
        MAX_NAME_LENGTH  => 512,
    };
    $enum_RtAudioError = {
        RTAUDIO_ERROR_NONE              => 0,
        RTAUDIO_ERROR_WARNING           => 1,
        RTAUDIO_ERROR_UNKNOWN           => 2,
        RTAUDIO_ERROR_NO_DEVICES_FOUND  => 3,
        RTAUDIO_ERROR_INVALID_DEVICE    => 4,
        RTAUDIO_ERROR_DEVICE_DISCONNECT => 5,
        RTAUDIO_ERROR_MEMORY_ERROR      => 6,
        RTAUDIO_ERROR_INVALID_PARAMETER => 7,
        RTAUDIO_ERROR_INVALID_USE       => 8,
        RTAUDIO_ERROR_DRIVER_ERROR      => 9,
        RTAUDIO_ERROR_SYSTEM_ERROR      => 10,
        RTAUDIO_ERROR_THREAD_ERROR      => 11
    };
    $enum_RtAudioApi = {
        RTAUDIO_API_UNSPECIFIED    => 0,
        RTAUDIO_API_MACOSX_CORE    => 1,
        RTAUDIO_API_LINUX_ALSA     => 2,
        RTAUDIO_API_UNIX_JACK      => 3,
        RTAUDIO_API_LINUX_PULSE    => 4,
        RTAUDIO_API_LINUX_OSS      => 5,
        RTAUDIO_API_WINDOWS_ASIO   => 6,
        RTAUDIO_API_WINDOWS_WASAPI => 7,
        RTAUDIO_API_WINDOWS_DS     => 8,
        RTAUDIO_API_DUMMY          => 9,
        RTAUDIO_API_NUM            => 0,
    };

    $binds = {
        rtaudio_version                   => [ [qw/ void /]             => 'string' ],
        rtaudio_get_num_compiled_apis     => [ [qw/ void /]             => 'uint' ],
        rtaudio_compiled_api              => [ [qw/ void /]             => 'rtaudio_api_t*' ],
        rtaudio_api_name                  => [ [qw/ rtaudio_api_t /]    => 'string' ],
        rtaudio_api_display_name          => [ [qw/ rtaudio_api_t /]    => 'string' ],
        rtaudio_compiled_api_by_name      => [ [qw/ string /]           => 'rtaudio_api_t' ],
        rtaudio_error                     => [ [qw/ rtaudio_t /]        => 'string' ],
        rtaudio_error_type                => [ [qw/ rtaudio_t /]        => 'rtaudio_error_t' ],
        rtaudio_create                    => [ [qw/ rtaudio_api_t /]    => 'rtaudio_t' ],
        rtaudio_destroy                   => [ [qw/ rtaudio_t /]        => 'void' ],
        rtaudio_current_api               => [ [qw/ rtaudio_t /]        => 'rtaudio_api_t' ],
        rtaudio_device_count              => [ [qw/ rtaudio_t /]        => 'int' ],
        rtaudio_get_device_id             => [ [qw/ rtaudio_t int /]    => 'uint' ],
        rtaudio_get_device_info           => [ [qw/ rtaudio_t uint /]   => 'rtaudio_device_info_t' ],
        rtaudio_get_default_output_device => [ [qw/ rtaudio_t /]        => 'uint' ],
        rtaudio_get_default_input_device  => [ [qw/ rtaudio_t /]        => 'uint' ],
        rtaudio_close_stream              => [ [qw/ rtaudio_t /]        => 'void' ],
        rtaudio_start_stream              => [ [qw/ rtaudio_t /]        => 'rtaudio_error_t' ],
        rtaudio_stop_stream               => [ [qw/ rtaudio_t /]        => 'rtaudio_error_t' ],
        rtaudio_abort_stream              => [ [qw/ rtaudio_t /]        => 'rtaudio_error_t' ],
        rtaudio_is_stream_open            => [ [qw/ rtaudio_t /]        => 'int' ],
        rtaudio_is_stream_running         => [ [qw/ rtaudio_t /]        => 'int' ],
        rtaudio_get_stream_time           => [ [qw/ rtaudio_t /]        => 'double' ],
        rtaudio_set_stream_time           => [ [qw/ rtaudio_t double /] => 'void' ],
        rtaudio_get_stream_latency        => [ [qw/ rtaudio_t double /] => 'long' ],
        rtaudio_get_stream_sample_rate    => [ [qw/ rtaudio_t /]        => 'uint' ],
        rtaudio_show_warnings             => [ [qw/ rtaudio_t int /]    => 'void' ],

        rtaudio_open_stream => [ [qw/
            rtaudio_t rtaudio_stream_parameters_t* rtaudio_stream_parameters_t*
            rtaudio_format_t uint uint* rtaudio_cb_t opaque
            rtaudio_stream_options_t* rtaudio_error_cb_t
        /] => 'rtaudio_error_t' ],


    };

}

use constant $constants;
use constant $enum_RtAudioError;
use constant $enum_RtAudioApi;

sub _init_api {
    $ffi->type( ulong  => 'rtaudio_format_t' );
    $ffi->type( uint   => 'rtaudio_stream_flags_t' );
    $ffi->type( uint   => 'rtaudio_stream_status_t' );
    $ffi->type( int    => 'rtaudio_api_t' );
    $ffi->type( int    => 'rtaudio_error_t' );
    $ffi->type( opaque => 'rtaudio_t' );
    $ffi->type('(rtaudio_error_t,string)->void' => 'rtaudio_error_cb_t');
    $ffi->type('(opaque,opaque,uint,double,rtaudio_stream_status_t,opaque)->int' => 'rtaudio_cb_t');
    $ffi->RtAudioDevice::init( NUM_SAMPLE_RATES, MAX_NAME_LENGTH );
    $ffi->RtAudioStreamParameters::init;
    $ffi->RtAudioStreamOptions::init( MAX_NAME_LENGTH );
    for my $fn ( keys %{ $binds } ) {
        $ffi->attach( $fn => @{ $binds->{ $fn } } );
    }
}

{
    package RtAudioStreamOptions;
    use FFI::Platypus::Record;
    sub init {
        my ( $ffi, $mnl ) = @_;
        record_layout_1(
            $ffi,
            rtaudio_stream_flags_t => 'flags',
            uint => 'num_buffers',
            int => 'priority',
            #"char[$mnl]"     => 'name',
            "string($mnl)"   => 'name',
        );
        $ffi->type('record(RtAudioStreamOptions)' => 'rtaudio_stream_options_t');
    }
}

{
    package RtAudioStreamParameters;
    use FFI::Platypus::Record;
    sub init {
        my ( $ffi ) = @_;
        record_layout_1(
            $ffi,
            uint => 'device_id',
            uint => 'num_channels',
            uint => 'first_channel',
        );
        $ffi->type('record(RtAudioStreamParameters)' => 'rtaudio_stream_parameters_t');
    }
}

{
    package RtAudioDevice;
    use FFI::Platypus::Record;
    sub init {
        my ( $ffi, $nsr, $mnl ) = @_;
        record_layout_1(
            $ffi,
            uint             => 'id',
            uint             => 'output_channels',
            uint             => 'input_channels',
            uint             => 'duplex_channels',
            int              => 'is_default_output',
            int              => 'is_default_input',
            rtaudio_format_t => 'native_formats',
            uint             => 'preferred_sample_rate',
            "int[$nsr]"      => 'sample_rates',
            #"char[$mnl]"     => 'name',
            "string($mnl)"   => 'name',
        );
        $ffi->type('record(RtAudioDevice)' => 'rtaudio_device_info_t');
    }
}

_init_api;

our @export_constants = ( sort keys %{ $constants } );
our @export_binds     = ( sort keys %{ $binds } );
our @export_enums     = ( sort keys %{ $enum_RtAudioApi }, sort keys %{ $enum_RtAudioError } );
our @EXPORT_OK       = ( @export_constants, @export_binds, @export_enums );
our %EXPORT_TAGS     = (
    all => \@EXPORT_OK,
    constants => \@export_constants,
    binds => \@export_binds,
    enums => \@export_enums,
);

'My son is also named Bort';
