import static org.freesource.farm.FarmUtils.*

def cli = new CliBuilder(usage: 'dep_diff --base-run <farmJobId> --target-run <farmJobId> --lrg <lrgName>')
cli._(longOpt: 'base-job', 'Base farm run against which to compare.', required: true, args: 1)
cli._(longOpt: 'target-job', 'The farm run which needs to be compared.', required: true, args: 1)
cli._(longOpt: 'lrg-name', 'The name of the lrg whose dependencies need to be compared.', required: true, args: 1)
cli._(longOpt: 'help', 'Usage information', required: false)

def options = cli.parse(args)

if (!options) {
    return
}
def lrgName = options.'lrg-name'.startsWith('lrg') ? options.'lrg-name' : "lrg" + options.'lrg-name'

def baseLrgFiles = getFilesToParse(options.'base-job', lrgName)
def targetLrgFiles = getFilesToParse(options.'target-job', lrgName)

GradleDependencyParser parser1 = new GradleDependencyParser(baseLrgFiles)
GradleDependencyParser parser2 = new GradleDependencyParser(targetLrgFiles)
GradleDependencyComparator compare = new GradleDependencyComparator(parser1, parser2)
compare.printReport()
