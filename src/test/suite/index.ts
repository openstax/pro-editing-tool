import fs from 'fs';
import path from 'path';
import Mocha from 'mocha';
import glob from 'glob';

export function run(): Promise<void> {
	// Create the mocha test
	const mocha = new Mocha({
		ui: 'tdd',
		color: true
	});

	const testsRoot = path.resolve(__dirname, '..');

	return (new Promise((c, e) => {
		glob('**/**.test.js', { cwd: testsRoot }, (err, files) => {
			if (err) {
				return e(err);
			}

			// Add files to the test suite
			files.forEach(f => mocha.addFile(path.resolve(testsRoot, f)));

			try {
				// Run the mocha test
				mocha.run(failures => {
					if (failures > 0) {
						e(new Error(`${failures} tests failed.`));
					} else {
						c(true);
					}
				});
			} catch (err) {
				console.error(err);
				e(err);
			}
		});
	})).then(() => {
		console.log('Extracting the code coverage from __coverage__ and writing it to .nyc_output/coverage.json')
		fs.writeFileSync(path.join(__dirname, '../../../.nyc_output/coverage.json'), JSON.stringify((global as any).__coverage__))
	});
}
