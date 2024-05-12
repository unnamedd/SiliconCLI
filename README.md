# Silicon CLI

Silicon CLI is a Swift Package built upon the core technology of the [Silicon app](https://github.com/DigiDNA/Silicon), a product of [DigiDNA](https://www.digidna.net).
 
This tool is designed to provide users with valuable information about the applications on their macOS systems, with a particular focus on app architecture. 

To illustrate, here's a sample of the output you can expect from this CLI:

```shell
$ ./silicon-cli --json
```

Result

```json
{
  "applications": [
    {
      "architecture": "Apple",
      "architectures": [
        "arm64"
      ],
      "bundleIdentifier": "co.teamport.around",
      "isAppleSilicon": true,
      "isSystemApp": false,
      "name": "Around",
      "path": "/Applications/Around.app",
      "version": "0.60.46",
      "isElectronApp" : true
    },
    {
      "architecture": "Intel 64",
      "architectures": [
        "x86_64"
      ],
      "bundleIdentifier": "com.krill.Patterns",
      "isAppleSilicon": false,
      "isSystemApp": false,
      "name": "Patterns",
      "path": "/Applications/Patterns.app",
      "version": "1.2",
      "isElectronApp" : false
    },
    {
      "architecture": "Universal",
      "architectures": [
        "x86_64",
        "arm64"
      ],
      "bundleIdentifier": "com.apple.dt.Xcode",
      "isAppleSilicon": true,
      "isSystemApp": false,
      "name": "Xcode",
      "path": "/Applications/Xcode.app",
      "version": "13.3.1",
      "isElectronApp" : false
    }
  ],
  "total": 3
}
```

## System Requirements

-  Swift 5.9 or newer

## Compile and run

```shell
git clone https://github.com/unnamedd/SiliconCLI.git
cd SiliconCLI
make run
```

## Author

Silicon CLI was developed and is maintained by [Thiago Holanda](https://twitter.com/tholanda).

## Acknowledgements

-  The original [`Silicon app`](https://github.com/DigiDNA/Silicon) serves as the foundational technology for this tool.

## License

Silicon CLI is available under the [MIT License](http://opensource.org/licenses/MIT). 
You can find all the necessary details in the [LICENSE](LICENSE) file.
