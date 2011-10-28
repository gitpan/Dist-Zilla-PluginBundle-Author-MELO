use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

my $v = "\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = '5.006';
    my $pv = ($^V || $]);
    $v .= "perl: $pv (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('Data::Dumper','any version') };
eval { $v .= pmver('Dist::Zilla','4.300002') };
eval { $v .= pmver('Dist::Zilla::Plugin::Authority','1.005') };
eval { $v .= pmver('Dist::Zilla::Plugin::Bootstrap::lib','0.01023600') };
eval { $v .= pmver('Dist::Zilla::Plugin::Bugtracker','1.111080') };
eval { $v .= pmver('Dist::Zilla::Plugin::CheckChangesHasContent','0.003') };
eval { $v .= pmver('Dist::Zilla::Plugin::CheckExtraTests','0.004') };
eval { $v .= pmver('Dist::Zilla::Plugin::Git::NextVersion','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::GithubMeta','0.26') };
eval { $v .= pmver('Dist::Zilla::Plugin::InstallRelease','0.007') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaNoIndex','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaProvides::Package','1.12060501') };
eval { $v .= pmver('Dist::Zilla::Plugin::MinimumPerl','1.003') };
eval { $v .= pmver('Dist::Zilla::Plugin::NextRelease','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::OurPkgVersion','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::PodWeaver','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::ReportVersions::Tiny','1.03') };
eval { $v .= pmver('Dist::Zilla::Plugin::Repository','0.18') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::Pod::No404s','1.001') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::Basic','any version') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::Git','1.112510') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::TestingMania','0.014') };
eval { $v .= pmver('Dist::Zilla::Role::PluginBundle::Config::Slicer','any version') };
eval { $v .= pmver('Dist::Zilla::Role::PluginBundle::Easy','any version') };
eval { $v .= pmver('ExtUtils::MakeMaker','6.30') };
eval { $v .= pmver('File::Find','any version') };
eval { $v .= pmver('File::Temp','any version') };
eval { $v .= pmver('List::Util','any version') };
eval { $v .= pmver('Method::Signatures','20111020') };
eval { $v .= pmver('Moose','any version') };
eval { $v .= pmver('Moose::Util::TypeConstraints','1.01') };
eval { $v .= pmver('Pod::Elemental','0.102360') };
eval { $v .= pmver('Pod::Elemental::Transformer::List','any version') };
eval { $v .= pmver('Pod::Weaver','3.101633') };
eval { $v .= pmver('Pod::Weaver::Config::Assembler','any version') };
eval { $v .= pmver('Pod::Weaver::Plugin::StopWords','1.001005') };
eval { $v .= pmver('Pod::Weaver::Plugin::Transformer','any version') };
eval { $v .= pmver('Pod::Weaver::Plugin::WikiDoc','0.093002') };
eval { $v .= pmver('Pod::Weaver::PluginBundle::Default','any version') };
eval { $v .= pmver('Pod::Weaver::Section::Support','1.001') };
eval { $v .= pmver('Test::CPAN::Meta::JSON','any version') };
eval { $v .= pmver('Test::More','0.98') };
eval { $v .= pmver('strict','any version') };
eval { $v .= pmver('warnings','any version') };



# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve you problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;
