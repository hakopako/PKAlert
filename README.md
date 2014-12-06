PKAlert
=======

Simple and easy alert generator written with objective c

<video src="https://raw.githubusercontent.com/hakopako/PKAlert/master/PKAlertSample/PKAlert.mp4"></video> 

## Usage
1. Add `PKAlert.h`,`PKAlert.m` to your project.
2. `#import "PKAlert.h"` 
3. call method like so

```obj-c:simpleAlert
[PKAlert showWithTitle:@"Notice" //NSString or nil
                  text:@"hogehogehoghoe\nhugahuga\nIs this ok?\n\n\nhahahaha" //NSString or nil
      cancelButtonText:@"O K" //NSString or nil
                 items:nil 
             tintColor:[UIColor colorWithRed:0.5 green:0.849 blue:0.9 alpha:1.000] //UIColor or nil
];
```

```obj-c:optionAlert
[PKAlert showWithTitle:@"Success!!"
                  text:@"XXXX is completed successfuly.\n check ooooo now!"
      cancelButtonText:@"Cancel"
                 items:@[
                         [PKAlert generateButtonWithTitle:@"Bar" //backgoundColor button is generated.
                                                   action:^(){
                                                       NSLog(@"Bar is clicked.");
                                                   }
                                                     type:UIButtonTypeSystem
                                           backgoundColor:[UIColor colorWithRed:0.5 green:0.849 blue:0.9 alpha:1.000]],
                         [PKAlert generateButtonWithTitle:@"Foo" //tintColor button is generated.
                                                   action:^(){
                                                       NSLog(@"Foo is clicked.");
                                                   }
                                                     type:UIButtonTypeSystem]]
             tintColor:nil];
```

 
## MIT License
```
Copyright (c) 2014 hakopako.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```


