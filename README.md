# Silicon CLI

This Swift Package was created using the core of the [Silicon app](https://github.com/DigiDNA/Silicon), 
created by [DigiDNA](https://www.digidna.net).
 
The idea is to expose some informations of the apps inside of your macOS in order to make it easier to identify important
informations, such as: the architecture.

Here is a small snippet returned by this CLI:

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
      "version": "0.60.46"
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
      "version": "1.2"
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
      "version": "13.3.1"
    }
  ],
  "total": 3
}
```

## Author

`Silicon CLI` was created and is maintained by [Thiago Holanda](https://twitter.com/tholanda)

## Acknowledgements

- [`Silicon app`](https://github.com/DigiDNA/Silicon)

## License

`Silicon CLI` is released under an [MIT License](http://opensource.org/licenses/MIT). See `LICENSE` for details.
