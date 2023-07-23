use Test;
use FontConfig::Raw;
use FontConfig::Defs :enums;

my $weight = FcObjectType::get-object-type('weight');
is $weight.object, 'weight';
is $weight.type, +FcTypeRange;

my $blah = FcObjectType::get-object-type('blah');
is $blah.object, 'blah';
is $blah.type, +FcTypeUnknown;

if FcName::constant('extrabold', my int32 $val) {
    is $val, 205, 'known constant';
}
else {
    flunk 'known constant';
}

nok FcName::constant('blah', $val);

done-testing();