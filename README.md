# nc_cookbook_generator

Cookbook generator to follow a set of standards we use at New Context Services, Inc.

## Requirements
Make sure you have [chefdk](https://downloads.chef.io/chef-dk/) installed
You must also have pip available - ```brew install python``` provides this on current homebrew.

## Usage

git clone this cookbook and generate the new cookbook:

```
chef generate cookbook -g ./nc_cookbook_generator <cookbook_name> \
-m coders@newcontext.com -C "New Context Services, Inc."
```

#### Options

- To use inspec instead of the default serverspec, export this environment variable before running the generator

```
TK_FRAMEWORK=inspec
```

## License & Authors
**Author:** Engineers ([coders@newcontext.com](mailto:coders@newcontext.com))

**Copyright:** 2016, New Context Services, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
