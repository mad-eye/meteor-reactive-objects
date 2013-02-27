# Reactive Objects

This is a library making it easy to create reactive objects and arrays in Meteor.
We'd like it to eventually include reactive queues, form objects, etc.

## Usage

```
person = new ReactiveObject(['name', 'happy'])
Meteor.autorun(function() {
  console.log('Hello, ' + person.name + '!');
});
Meteor.autorun(function() {
  if (!person.happy) {
    console.log('Don't be sad, ' + person.name + '!');
  }
});

person.happy = true;
person.name = 'Joe';
// "Hello, Joe!"
person.happy = false;
// "Don't be sad, Joe!"
```

