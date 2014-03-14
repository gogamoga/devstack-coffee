Gogamatic Devstack with Curl and Cram
=====================================

#### Minimal Seed project for coffeescript based development

Install
-------

```bash    
  project="foobar"
  git clone https://github.com/gogamoga/devstack-coffee.git $project
  
  cd $project
  git checkout withcurl    
  rm -rf .git
  git init
  
  echo > README.md    
  mkdir -p src/test    
  
  git add .
  git commit -a -m "Initial commit"    
  git checkout -b work
  
  npm install    
  npm init
```

Usage
-----

```bash
  gulp
```

